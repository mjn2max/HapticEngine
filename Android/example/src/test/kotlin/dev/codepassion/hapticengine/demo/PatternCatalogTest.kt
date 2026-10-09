package dev.codepassion.hapticengine.demo

import dev.codepassion.hapticengine.HapticPattern
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

/** Mirrors `PatternCatalogTests.swift`. */
class PatternCatalogTest {
    private val none = PatternSearch("")

    @Test
    fun allShowsEveryPatternUnderItsCategory() {
        val sections = PatternCatalog.sections(PatternFilter.All, none, favorites = emptyList())
        assertEquals(PatternCategory.entries.map { it.name }, sections.map { it.id })
        assertEquals(HapticPattern.entries.toSet(), sections.flatMap { it.patterns }.toSet())
        assertEquals(HapticPattern.entries.size, sections.sumOf { it.patterns.size })
        assertEquals("Feedback · ${PatternCategory.Feedback.patterns.size}", sections.first().title)
    }

    @Test
    fun favoritesShowInTheOrderStarredWithoutAHeading() {
        val favorites = listOf(HapticPattern.Rumble, HapticPattern.Tick)
        val sections = PatternCatalog.sections(PatternFilter.Favorites, none, favorites)
        assertEquals(listOf(PatternSection("favorites", null, favorites)), sections)
        assertEquals(emptyList<PatternSection>(), PatternCatalog.sections(PatternFilter.Favorites, none, emptyList()))
    }

    @Test
    fun recentShowsWhatWasPlayed() {
        val recents = listOf(HapticPattern.Knock, HapticPattern.Success)
        assertEquals(recents, PatternCatalog.sections(PatternFilter.Recent, none, emptyList(), recents).single().patterns)
        assertEquals(2, PatternCatalog.count(PatternFilter.Recent, emptyList(), recents))
    }

    @Test
    fun aCategoryShowsItsPatterns() {
        val sections = PatternCatalog.sections(PatternFilter.Category(PatternCategory.Game), none, emptyList())
        assertEquals(PatternCategory.Game.patterns, sections.single().patterns)
        assertNull(sections.single().title)
    }

    @Test
    fun searchLooksEverywhereWhateverTheFilter() {
        val sections = PatternCatalog.sections(PatternFilter.Favorites, PatternSearch("heavy metal"), emptyList())
        assertTrue(HapticPattern.HeavyMetalHit in sections.flatMap { it.patterns })
    }

    @Test
    fun countsMatchTheSections() {
        PatternFilter.allFilters.forEach { filter ->
            val favorites = listOf(HapticPattern.Tick)
            val shown = PatternCatalog.sections(filter, none, favorites).sumOf { it.patterns.size }
            assertEquals("$filter", shown, PatternCatalog.count(filter, favorites))
        }
    }
}

class PatternSearchTest {
    @Test
    fun matchesWordStartsInNameDescriptionOrCategory() {
        assertTrue(PatternSearch("succ").matches(HapticPattern.Success))
        assertTrue(PatternSearch("SUCCESS").matches(HapticPattern.Success))
        // The category, Feedback.
        assertTrue(PatternSearch("feedback").matches(HapticPattern.Tick))
        // Every word must match.
        assertFalse(PatternSearch("success rumble").matches(HapticPattern.Success))
    }

    @Test
    fun matchesWordStartsOnly() {
        // "rain" starts no word in "a rough, fine-grained texture".
        assertFalse(PatternSearch("rain").matches(HapticPattern.Sandpaper))
        assertTrue(PatternSearch("rain").matches(HapticPattern.Rain))
    }

    @Test
    fun ignoresAccentsAndPunctuation() {
        assertEquals(listOf("fade", "out"), PatternSearch.words("Fade-Out"))
        assertEquals(listOf("cafe"), PatternSearch.words("Café"))
        assertTrue(PatternSearch("-").isEmpty)
        assertTrue(PatternSearch("  ").isEmpty)
    }
}

class PatternFilterTest {
    @Test
    fun everyFilterSurvivesSaving() {
        PatternFilter.allFilters.forEach { assertEquals(it, PatternFilter.fromStorageValue(it.storageValue)) }
    }

    @Test
    fun savesAsIOSDoes() {
        // The same values as `PatternFilter.storageValue` on iOS, where categories save their raw value.
        assertEquals("all", PatternFilter.All.storageValue)
        assertEquals("category.tapCounts", PatternFilter.Category(PatternCategory.TapCounts).storageValue)
    }

    @Test
    fun forgetsWhatNoLongerExists() {
        assertNull(PatternFilter.fromStorageValue("category.gone"))
        assertNull(PatternFilter.fromStorageValue("cards"))
    }
}

class PatternDisplayTest {
    @Test
    fun everyPatternIsDescribed() {
        HapticPattern.entries.forEach {
            assertTrue("$it", it.title.isNotBlank())
            assertTrue("$it", it.subtitle.isNotBlank())
        }
    }

    @Test
    fun namesAreUnique() {
        assertEquals(HapticPattern.entries.size, HapticPattern.entries.map { it.title }.toSet().size)
    }

    @Test
    fun everySymbolCanBeDrawn() {
        val symbols = PatternDetailsData.symbols + PatternFilter.allFilters.map { it.symbol } + PatternLayout.entries.map { it.symbol }
        assertEquals(emptyList<String>(), symbols.filterNot(::hasSymbol))
    }

    @Test
    fun everyCategoryHasPatterns() {
        PatternCategory.entries.forEach { assertTrue("$it", it.patterns.isNotEmpty()) }
        assertEquals(HapticPattern.entries.size, PatternCategory.entries.sumOf { it.patterns.size })
    }

    @Test
    fun describesPatternsAsIOSDoes() {
        // Spot checks that the rows from iOS line up with the patterns.
        assertEquals("Success", HapticPattern.Success.title)
        assertEquals(PatternCategory.Feedback, HapticPattern.Success.category)
        assertEquals("Heavy Metal Hit", HapticPattern.HeavyMetalHit.title)
        assertEquals(PatternCategory.Impacts, HapticPattern.HeavyMetalHit.category)
        assertEquals("Ember Nebula", HapticPattern.EmberNebula.title)
        assertEquals(PatternCategory.Rhythm, HapticPattern.Pulse.category)
    }

    @Test
    fun formatsDurationsAsIOSDoes() {
        assertEquals("Instant", formatDuration(0))
        assertEquals("Instant", formatDuration(49))
        assertEquals("250 ms", formatDuration(250))
        assertEquals("1 s", formatDuration(1_000))
        assertEquals("1.5 s", formatDuration(1_500))
        assertEquals("6 s", formatDuration(6_000))
        assertEquals("1 s", formatDuration(1_040))
        // Half a tenth rounds up, whatever floating point makes of it.
        assertEquals("1.5 s", formatDuration(1_450))
        assertEquals("1.2 s", formatDuration(1_150))
        assertEquals("1.7 s", formatDuration(1_650))
    }
}

class AppInfoTest {
    @Test
    fun versionLeavesOutABuildThatSaysNothingMore() {
        assertEquals("Version 1.0 (1)", AppInfo.version("1.0", 1))
        assertEquals("Version 2", AppInfo.version("2", 2))
        assertEquals("Version – (3)", AppInfo.version(null, 3))
    }

    @Test
    fun issueSaysWhatAHapticsBugDependsOn() {
        val body = AppInfo.issueBody("Google Pixel 9", "Android 16 (API 36)", "Version 1.0 (1)", isHapticsSupported = false)
        assertTrue(body.contains("Device: Google Pixel 9"))
        assertTrue(body.contains("System: Android 16 (API 36)"))
        assertTrue(body.contains("Haptics: Not supported"))
    }
}
