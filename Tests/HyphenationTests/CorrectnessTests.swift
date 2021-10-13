// Hyphenation
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

// swiftlint:disable explicit_top_level_acl

import Hyphenation
import XCTest

final class CorrectnessTests: XCTestCase {
    var hyphenator = Hyphenator()

    override func setUp() {
        super.setUp()
        hyphenator.separator = "-"
    }

    func testSingleWordHyphenation() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "modularity"), "mod-u-lar-ity")
        XCTAssertEqual(hyphenator.hyphenate(text: "superfluous"), "su-per-flu-ous")
        XCTAssertEqual(hyphenator.hyphenate(text: "algorithm"), "al-go-rithm")
        XCTAssertEqual(hyphenator.hyphenate(text: "hyphenation"), "hy-phen-ation")
        XCTAssertEqual(hyphenator.hyphenate(text: "accoutrements"), "ac-cou-trements")
        XCTAssertEqual(hyphenator.hyphenate(text: "acumen"), "acu-men")
        XCTAssertEqual(hyphenator.hyphenate(text: "anomalistic"), "anom-al-is-tic")
        XCTAssertEqual(hyphenator.hyphenate(text: "auspicious"), "aus-pi-cious")
        XCTAssertEqual(hyphenator.hyphenate(text: "bellwether"), "bell-wether")
        XCTAssertEqual(hyphenator.hyphenate(text: "callipygian"), "cal-lipy-gian")
        XCTAssertEqual(hyphenator.hyphenate(text: "circumlocution"), "cir-cum-lo-cu-tion")
        XCTAssertEqual(hyphenator.hyphenate(text: "concupiscent"), "con-cu-pis-cent")
        XCTAssertEqual(hyphenator.hyphenate(text: "conviviality"), "con-vivi-al-ity")
        XCTAssertEqual(hyphenator.hyphenate(text: "coruscant"), "cor-us-cant")
        XCTAssertEqual(hyphenator.hyphenate(text: "cuddlesome"), "cud-dle-some")
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cu-pid-ity")
        XCTAssertEqual(hyphenator.hyphenate(text: "cynosure"), "cyno-sure")
        XCTAssertEqual(hyphenator.hyphenate(text: "ebullient"), "ebul-lient")
        XCTAssertEqual(hyphenator.hyphenate(text: "equanimity"), "equa-nim-ity")
        XCTAssertEqual(hyphenator.hyphenate(text: "excogitate"), "ex-cog-i-tate")
        XCTAssertEqual(hyphenator.hyphenate(text: "gasconading"), "gas-conad-ing")
        XCTAssertEqual(hyphenator.hyphenate(text: "idiosyncratic"), "idio-syn-cratic")
        XCTAssertEqual(hyphenator.hyphenate(text: "luminescent"), "lu-mi-nes-cent")
        XCTAssertEqual(hyphenator.hyphenate(text: "magnanimous"), "mag-nan-i-mous")
        XCTAssertEqual(hyphenator.hyphenate(text: "nidificate"), "ni-d-ifi-cate")
        XCTAssertEqual(hyphenator.hyphenate(text: "osculator"), "os-cu-la-tor")
        XCTAssertEqual(hyphenator.hyphenate(text: "parsimonious"), "par-si-mo-nious")
        XCTAssertEqual(hyphenator.hyphenate(text: "penultimate"), "penul-ti-mate")
        XCTAssertEqual(hyphenator.hyphenate(text: "perfidiousness"), "per-fid-i-ous-ness")
        XCTAssertEqual(hyphenator.hyphenate(text: "perspicacious"), "per-spi-ca-cious")
        XCTAssertEqual(hyphenator.hyphenate(text: "proficuous"), "profi-c-u-ous")
        XCTAssertEqual(hyphenator.hyphenate(text: "remunerative"), "re-mu-ner-a-tive")
        XCTAssertEqual(hyphenator.hyphenate(text: "saxicolous"), "saxi-colous")
        XCTAssertEqual(hyphenator.hyphenate(text: "sesquipedalian"), "sesquipedalian")
        XCTAssertEqual(hyphenator.hyphenate(text: "superabundant"), "su-per-abun-dant")
        XCTAssertEqual(hyphenator.hyphenate(text: "unencumbered"), "un-en-cum-bered")
        XCTAssertEqual(hyphenator.hyphenate(text: "unparagoned"), "un-paragoned")
        XCTAssertEqual(hyphenator.hyphenate(text: "usufruct"), "usufruct")
        XCTAssertEqual(hyphenator.hyphenate(text: "winebibber"), "winebib-ber")
    }

    func testMultiWordHyphenation() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "modularity superfluous algorithm hyphenation"),
                       "mod-u-lar-ity su-per-flu-ous al-go-rithm hy-phen-ation")
        XCTAssertEqual(hyphenator.hyphenate(text: " modularity  superfluous   \nalgorithm    hyphenation     "),
                       " mod-u-lar-ity  su-per-flu-ous   \nal-go-rithm    hy-phen-ation     ")
        XCTAssertEqual(hyphenator.hyphenate(text: "modul1arity superf,luous algor$ithm hyphe$nation"),
                       "modul1ar-ity su-perf,lu-ous al-gor$ithm hy-phe$na-tion")
    }

    func testExceptions() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "associate"), "as-so-ciate")
        XCTAssertEqual(hyphenator.hyphenate(text: "associates"), "as-so-ciates")
        XCTAssertEqual(hyphenator.hyphenate(text: "declination"), "dec-li-na-tion")
        XCTAssertEqual(hyphenator.hyphenate(text: "obligatory"), "oblig-a-tory")
        XCTAssertEqual(hyphenator.hyphenate(text: "philanthropic"), "phil-an-thropic")
        XCTAssertEqual(hyphenator.hyphenate(text: "present"), "present")
        XCTAssertEqual(hyphenator.hyphenate(text: "presents"), "presents")
        XCTAssertEqual(hyphenator.hyphenate(text: "project"), "project")
        XCTAssertEqual(hyphenator.hyphenate(text: "projects"), "projects")
        XCTAssertEqual(hyphenator.hyphenate(text: "reciprocity"), "reci-procity")
        XCTAssertEqual(hyphenator.hyphenate(text: "recognizance"), "re-cog-ni-zance")
        XCTAssertEqual(hyphenator.hyphenate(text: "reformation"), "ref-or-ma-tion")
        XCTAssertEqual(hyphenator.hyphenate(text: "retribution"), "ret-ri-bu-tion")
        XCTAssertEqual(hyphenator.hyphenate(text: "table"), "ta-ble")
    }

    func testPreHyphenatedWords() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "super-~fluous"), "su-per-~flu-ous")
        XCTAssertEqual(hyphenator.hyphenate(text: "super-fluous"), "super-fluous")
        hyphenator.separator = "~"
        XCTAssertEqual(hyphenator.hyphenate(text: "super~~fluous"), "su~per~~flu~ous")
        XCTAssertEqual(hyphenator.hyphenate(text: "super~fluous"), "super~fluous")
        XCTAssertEqual(hyphenator.hyphenate(text: "123~fluous"), "123~flu~ous")
        XCTAssertEqual(hyphenator.hyphenate(text: "super~456"), "su~per~456")
        XCTAssertEqual(hyphenator.hyphenate(text: "123~456"), "123~456")
        XCTAssertEqual(hyphenator.hyphenate(text: "super~"), "su~per~")
        XCTAssertEqual(hyphenator.hyphenate(text: "123~"), "123~")
        XCTAssertEqual(hyphenator.hyphenate(text: "~fluous"), "~flu~ous")
        XCTAssertEqual(hyphenator.hyphenate(text: "~456"), "~456")
    }

    func testCaseInsensitivity() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "MoDuLaRiTy"), "MoD-u-LaR-iTy")
        hyphenator.addCustomExceptions(["mOdU-lAr-I-tY"])
        XCTAssertEqual(hyphenator.hyphenate(text: "MoDuLaRiTy"), "MoDu-LaR-i-Ty")
    }

    func testCustomExceptions() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "project"), "project")
        hyphenator.addCustomExceptions(["pro-ject"])
        XCTAssertEqual(hyphenator.hyphenate(text: "project"), "pro-ject")
        hyphenator.addCustomExceptions(["proj-ect"])
        XCTAssertEqual(hyphenator.hyphenate(text: "project"), "proj-ect")
        hyphenator.removeAllCustomExceptions()
        XCTAssertEqual(hyphenator.hyphenate(text: "project"), "project")
        hyphenator.addCustomExceptions(["Micro-soft", "ses-qui-pe-da-li-an"])
        XCTAssertEqual(hyphenator.hyphenate(text: "Microsoft"), "Micro-soft")
        XCTAssertEqual(hyphenator.hyphenate(text: "sesquipedalian"), "ses-qui-pe-da-li-an")
        hyphenator.removeCustomExceptions(["Microsoft"])
        XCTAssertEqual(hyphenator.hyphenate(text: "Microsoft"), "Mi-crosoft")
        XCTAssertEqual(hyphenator.hyphenate(text: "sesquipedalian"), "ses-qui-pe-da-li-an")
    }

    func testCacheInvalidation() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cu-pid-ity")
        hyphenator.separator = "~"
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cu~pid~ity")
        hyphenator.minLeading = 3
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cupid~ity")
        hyphenator.minTrailing = 2
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cupid~i~ty")
        hyphenator.minLength = 9
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cupidity")
        hyphenator.minLength = 5
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cupid~i~ty")
    }

    func testMinValuesExtrema() throws {
        hyphenator.minLeading = UInt.max
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cupidity")
        hyphenator.minLeading = 0
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cu-pid-ity")
        hyphenator.minTrailing = UInt.max
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cupidity")
        hyphenator.minTrailing = 0
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cu-pid-i-ty")
        hyphenator.minLength = UInt.max
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cupidity")
        hyphenator.minLength = 0
        XCTAssertEqual(hyphenator.hyphenate(text: "cupidity"), "cu-pid-i-ty")
    }

    func testHyphenatorCopy() throws {
        hyphenator = try Hyphenator(patterns: "mod5u  mod8u.", exceptions: "pro-ject")
        hyphenator.separator = "-"
        let hyphenatorCopy = hyphenator.copy()
        hyphenator.addCustomExceptions(["modulari-ty"])
        hyphenatorCopy.separator = "~"
        XCTAssertEqual(hyphenator.hyphenate(text: "modularity"), "modulari-ty")
        XCTAssertEqual(hyphenatorCopy.hyphenate(text: "modularity"), "mod~ularity")
        XCTAssertEqual(hyphenator.hyphenate(text: "project"), "pro-ject")
        XCTAssertEqual(hyphenatorCopy.hyphenate(text: "project"), "pro~ject")
    }

    func testCustomPatternFiles() throws {
        XCTAssertEqual(hyphenator.hyphenate(text: "hyphenation"), "hy-phen-ation")
        hyphenator = try Hyphenator(patternFile: .testPatterns)
        hyphenator.separator = "-"
        XCTAssertEqual(hyphenator.hyphenate(text: "hyphenation"), "hy-phen-a-tion")
        hyphenator = try Hyphenator(patternFile: .testPatterns, exceptionFile: .testExceptions)
        hyphenator.separator = "-"
        XCTAssertEqual(hyphenator.hyphenate(text: "hyphenation"), "hyph-ena-tion")
        hyphenator = try Hyphenator(patterns: "hyph3 ena3 4tion")
        hyphenator.separator = "-"
        XCTAssertEqual(hyphenator.hyphenate(text: "hyphenation"), "hyph-enation")
        hyphenator = try Hyphenator(patterns: "hyph3 ena3 4tion", exceptions: "hyphe-nation")
        hyphenator.separator = "-"
        XCTAssertEqual(hyphenator.hyphenate(text: "hyphenation"), "hyphe-nation")
    }

    func testPatternMatching() throws {
        hyphenator = try Hyphenator(patterns: "mod5u  mod8u.")
        hyphenator.separator = "-"
        XCTAssertEqual(hyphenator.hyphenate(text: "modularity"), "mod-ularity")
    }

    func testBadPatternErrors() throws {
        assert(try Hyphenator(patterns: "hyph"), throws: PatternParsingError.deficientPattern("hyph"))
        assert(try Hyphenator(patterns: "hy3ph;"), throws: PatternParsingError.invalidCharacter("hy3ph;"))
        assert(try Hyphenator(patterns: "hy33ph"), throws: PatternParsingError.consecutiveDigits("hy33ph"))
    }

    func testUnhyphenateMethod() throws {
        XCTAssertEqual(hyphenator.unhyphenate(text: "mod-u-lar-i-ty"), "modularity")
    }

    func testSubstringHyphenation() throws {
        let string = "Testing hyphenation of substrings"
        let range = string.range(of: "hyphenation")!
        let newString = string.replacingCharacters(in: range, with: hyphenator.hyphenate(text: string[range]))
        XCTAssertEqual(newString, "Testing hy-phen-ation of substrings")
        XCTAssertEqual(hyphenator.unhyphenate(text: newString[newString.startIndex ..< newString.endIndex]), string)
    }
}
