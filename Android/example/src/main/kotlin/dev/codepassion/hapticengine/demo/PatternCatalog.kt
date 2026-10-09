package dev.codepassion.hapticengine.demo

import androidx.compose.runtime.Immutable
import dev.codepassion.hapticengine.HapticPattern
import java.text.Normalizer

/**
 * What the pattern browser shows: every pattern, the favorites, those played recently, or one category.
 * Remembered between launches, so someone testing their favorites comes back to them. Mirrors
 * `PatternFilter.swift`.
 */
@Immutable
sealed interface PatternFilter {
    data object All : PatternFilter
    data object Favorites : PatternFilter

    /** The patterns played lately, newest first: the activity log without its repeats. */
    data object Recent : PatternFilter
    data class Category(val category: PatternCategory) : PatternFilter

    val title: String
        get() = when (this) {
            All -> "All"
            Favorites -> "Favorites"
            Recent -> "Recent"
            is Category -> category.title
        }

    /** Shown in the filter panel, and on its toolbar button so the button says what's showing. */
    val symbol: String
        get() = when (this) {
            All -> "line.3.horizontal.decrease"
            Favorites -> "star.fill"
            Recent -> "clock.arrow.circlepath"
            is Category -> category.symbol
        }

    /** The selected filter's color. `null` for all, which takes the app's accent. */
    val tint: DemoTint?
        get() = when (this) {
            All -> null
            Favorites -> DemoTint.Yellow
            // The history's color, on the menu page.
            Recent -> DemoTint.Blue
            is Category -> category.tint
        }

    /** How [Preferences] saves it, as on iOS: such as `category.game`. */
    val storageValue: String
        get() = when (this) {
            All -> "all"
            Favorites -> "favorites"
            Recent -> "recent"
            is Category -> "category.${category.name.replaceFirstChar(Char::lowercase)}"
        }

    companion object {
        /**
         * Every filter, in the order the filter panel shows them. New categories join automatically. A getter:
         * stored, it was built while the filters it lists were still being created, and held nulls.
         */
        val allFilters: List<PatternFilter> get() = listOf(All, Favorites, Recent) + PatternCategory.entries.map(::Category)

        /** `null` for a value that no longer names a filter, such as a removed category. */
        fun fromStorageValue(value: String): PatternFilter? = when (value) {
            "all" -> All
            "favorites" -> Favorites
            "recent" -> Recent
            else -> value.removePrefix("category.").takeIf { value.startsWith("category.") }?.let { name ->
                PatternCategory.entries.firstOrNull { it.name.equals(name, ignoreCase = true) }?.let(::Category)
            }
        }
    }
}

/** How the patterns are laid out. Remembered between launches. Mirrors `PatternLayout.swift`. */
enum class PatternLayout(val title: String, val symbol: String) {
    /** Icon and name, three or more to a row: for tapping quickly. */
    Grid("Grid", "square.grid.2x2"),

    /** One row per pattern with description and length: for reading what each one does. */
    List("List", "list.bullet"),
}

/** The patterns to show together, under an optional heading. */
@Immutable
data class PatternSection(val id: String, val title: String?, val patterns: List<HapticPattern>)

/**
 * Which patterns the browser shows, for a filter or a search. Plain functions of their inputs, kept out of
 * the screens so they can be unit tested. Mirrors `PatternCatalog.swift`.
 */
object PatternCatalog {
    /**
     * A search shows every category with a match, whatever the filter: someone searching wants a pattern
     * wherever it is. Otherwise the filter's patterns show, under category headings only for all.
     */
    fun sections(
        filter: PatternFilter,
        search: PatternSearch,
        favorites: List<HapticPattern>,
        recents: List<HapticPattern> = emptyList(),
    ): List<PatternSection> {
        if (!search.isEmpty) return categorySections(search::matches)
        return when (filter) {
            PatternFilter.All -> categorySections { true }
            PatternFilter.Favorites -> if (favorites.isEmpty()) emptyList() else listOf(PatternSection("favorites", null, favorites))
            PatternFilter.Recent -> if (recents.isEmpty()) emptyList() else listOf(PatternSection("recent", null, recents))
            is PatternFilter.Category -> listOf(PatternSection(filter.category.name, null, filter.category.patterns))
        }
    }

    /** How many patterns [filter] shows. */
    fun count(filter: PatternFilter, favorites: List<HapticPattern>, recents: List<HapticPattern> = emptyList()): Int =
        when (filter) {
            PatternFilter.All -> HapticPattern.entries.size
            PatternFilter.Favorites -> favorites.size
            PatternFilter.Recent -> recents.size
            is PatternFilter.Category -> filter.category.patterns.size
        }

    /** One section per category with a pattern that passes [include], headed by its name and count. */
    private fun categorySections(include: (HapticPattern) -> Boolean): List<PatternSection> =
        PatternCategory.entries.mapNotNull { category ->
            val patterns = category.patterns.filter(include)
            if (patterns.isEmpty()) null else PatternSection(category.name, "${category.title} · ${patterns.size}", patterns)
        }
}

/**
 * What's typed in the search field, ready to match patterns. Mirrors `PatternSearch` on iOS.
 *
 * A pattern matches when every word typed starts a word in its name, description or category, ignoring
 * case and accents. Matching word starts, not any fragment, keeps "rain" from finding "fine-grained". Text
 * with no letters or digits, such as "-", searches for nothing, so the patterns stay in view.
 */
@Immutable
class PatternSearch(query: String) {
    private val words: List<String> = words(query)

    /** Whether nothing searchable was typed. */
    val isEmpty: Boolean get() = words.isEmpty()

    fun matches(pattern: HapticPattern): Boolean {
        val patternWords = index[pattern.ordinal]
        return words.all { word -> patternWords.any { it.startsWith(word) } }
    }

    override fun equals(other: Any?): Boolean = other is PatternSearch && other.words == words
    override fun hashCode(): Int = words.hashCode()

    companion object {
        /** Each pattern's words, folded once rather than on every keystroke for all four thousand patterns. */
        private val index: Array<List<String>> by lazy {
            Array(HapticPattern.entries.size) { ordinal ->
                val pattern = HapticPattern.entries[ordinal]
                words("${pattern.title} ${pattern.subtitle} ${pattern.category.title}")
            }
        }

        private val marks = Regex("\\p{Mn}+")
        private val separators = Regex("[^\\p{L}\\p{N}]+")

        /** The words in [text], folded for comparison: "Fade-Out" gives "fade" and "out". */
        fun words(text: String): List<String> =
            Normalizer.normalize(text, Normalizer.Form.NFD)
                .replace(marks, "")
                .lowercase()
                .split(separators)
                .filter { it.isNotEmpty() }
    }
}
