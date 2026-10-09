package dev.codepassion.hapticengine.demo

import android.content.ContentValues
import android.content.Context
import android.content.SharedPreferences
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import androidx.core.content.edit
import dev.codepassion.hapticengine.HapticPattern
import java.time.Instant

/**
 * What the demo remembers between launches, in one place: favorites, the filter, the layout, and whether
 * the launch ripple was felt. Mirrors `Preferences.swift`.
 *
 * A saved value that no longer exists, such as a renamed pattern or category, falls back to the default.
 */
class Preferences(private val prefs: SharedPreferences) {
    constructor(context: Context) : this(context.getSharedPreferences("demo", Context.MODE_PRIVATE))

    /** In the order they were starred. */
    var favorites: List<HapticPattern>
        get() = prefs.getString(FAVORITES, null).orEmpty().split(',').mapNotNull(::patternNamed)
        set(value) = prefs.edit { putString(FAVORITES, value.joinToString(",") { it.name }) }

    var filter: PatternFilter
        get() = prefs.getString(FILTER, null)?.let(PatternFilter::fromStorageValue) ?: PatternFilter.All
        set(value) = prefs.edit { putString(FILTER, value.storageValue) }

    var layout: PatternLayout
        get() = prefs.getString(LAYOUT, null)?.let { name -> PatternLayout.entries.firstOrNull { it.name == name } } ?: PatternLayout.Grid
        set(value) = prefs.edit { putString(LAYOUT, value.name) }

    /** Whether the haptic ripple that comes with the launch reveal has played: it's only for the first launch. */
    var hasFeltLaunchRipple: Boolean
        get() = prefs.getBoolean(HAS_FELT_LAUNCH_RIPPLE, false)
        set(value) = prefs.edit { putBoolean(HAS_FELT_LAUNCH_RIPPLE, value) }

    private companion object {
        const val FAVORITES = "favorites"
        const val FILTER = "patternFilter"
        // The old demo saved its layout here too; a layout it had and this one doesn't falls back to the grid.
        const val LAYOUT = "patternLayout"
        const val HAS_FELT_LAUNCH_RIPPLE = "hasFeltLaunchRipple"
    }
}

/** The pattern with [name], or `null` for one renamed or removed since it was saved. */
fun patternNamed(name: String): HapticPattern? = patternsByName[name]

private val patternsByName: Map<String, HapticPattern> by lazy { HapticPattern.entries.associateBy { it.name } }

/** One pattern played: see [ActivityStore]. */
data class LogEntry(val id: Long, val time: Instant, val pattern: HapticPattern)

/**
 * Where the activity log is saved between launches: the newest [LIMIT] entries, the oldest going first.
 * Mirrors `ActivityStore.swift`, in SQLite rather than SwiftData.
 *
 * [HapticDemoViewModel] keeps the log in memory too, for the screens to read, and writes each change
 * through. Saved at once, so a crash loses nothing.
 */
interface ActivityStore {
    /** Newest first. Entries for patterns renamed or removed since are skipped. */
    fun load(): List<LogEntry>

    fun add(entry: LogEntry)
    fun delete(id: Long)
    fun deleteAll()

    companion object {
        const val LIMIT = 1_000
    }
}

/** For tests and previews, which start empty and save nothing. */
class InMemoryActivityStore : ActivityStore {
    private val entries = mutableListOf<LogEntry>()

    override fun load() = entries.sortedByDescending { it.time }
    override fun add(entry: LogEntry) {
        entries += entry
        if (entries.size > ActivityStore.LIMIT) entries.remove(entries.minBy { it.time })
    }
    override fun delete(id: Long) {
        entries.removeAll { it.id == id }
    }
    override fun deleteAll() = entries.clear()
}

/** In the app's database. Called off the main thread: see [HapticDemoViewModel]. */
class SqliteActivityStore(context: Context) : ActivityStore {
    private val helper = object : SQLiteOpenHelper(context, "activity.db", null, 1) {
        override fun onCreate(db: SQLiteDatabase) {
            db.execSQL("CREATE TABLE entries (id INTEGER PRIMARY KEY, time INTEGER NOT NULL, pattern TEXT NOT NULL)")
            db.execSQL("CREATE INDEX entries_time ON entries (time)")
        }

        override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) = Unit
    }

    override fun load(): List<LogEntry> =
        helper.readableDatabase.query("entries", arrayOf("id", "time", "pattern"), null, null, null, null, "time DESC, id DESC", "${ActivityStore.LIMIT}")
            .use { cursor ->
                buildList {
                    while (cursor.moveToNext()) {
                        val pattern = patternNamed(cursor.getString(2)) ?: continue
                        add(LogEntry(cursor.getLong(0), Instant.ofEpochMilli(cursor.getLong(1)), pattern))
                    }
                }
            }

    override fun add(entry: LogEntry) {
        val db = helper.writableDatabase
        val values = ContentValues().apply {
            put("id", entry.id)
            put("time", entry.time.toEpochMilli())
            // The name, so a pattern renamed or removed since is skipped on loading rather than failing the log.
            put("pattern", entry.pattern.name)
        }
        db.insert("entries", null, values)
        // Down to the limit, the oldest first.
        db.execSQL(
            "DELETE FROM entries WHERE id NOT IN (SELECT id FROM entries ORDER BY time DESC, id DESC LIMIT ${ActivityStore.LIMIT})",
        )
    }

    override fun delete(id: Long) {
        helper.writableDatabase.delete("entries", "id = ?", arrayOf(id.toString()))
    }

    override fun deleteAll() {
        helper.writableDatabase.delete("entries", null, null)
    }
}
