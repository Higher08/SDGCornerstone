/*
 SDGTextAPITests.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/SDGCornerstone

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGMathematics
import SDGCollections
import SDGText
import SDGXCTestUtilities

import SDGMathematicsTestUtilities
import SDGCollectionsTestUtilities
import SDGPersistenceTestUtilities

class SDGTextAPITests : TestCase {

    func testCharacterSet() {
        testSetInRepresentableUniverseConformance(of: CharacterSet.self, a: "a", b: "e", c: "i")
    }

    func testLineView() {
        testBidirectionalCollectionConformance(of: "A\nB\nC".lines)

        let fileLines = [
            "Line 1",
            "Line 2",
            "Line 3"
        ]
        var file = fileLines.joined(separator: "\n")
        XCTAssertEqual(file.lines.map({ String($0.line) }), fileLines)

        file = fileLines.joined(separator: "\u{D}\u{A}")
        XCTAssertEqual(file.lines.map({ String($0.line) }), fileLines)

        file.lines.removeFirst()
        XCTAssertEqual(file.lines.map({ String($0.line) }), Array(fileLines.dropFirst()))

        var index = file.lines.startIndex
        index = file.lines.index(after: index)
        XCTAssertEqual(file.lines.distance(from: file.lines.startIndex, to: index), 1)
        XCTAssertEqual(file.lines.index(before: index), file.lines.startIndex)

        file = fileLines.joined(separator: "\n")
        index = file.lines.index(after: file.lines.startIndex)
        file.lines[index] = Line(line: "Replaced", newline: "\u{2029}")
        XCTAssertEqual(file, "Line 1\nReplaced\u{2029}Line 3")

        XCTAssertEqual(String(LineView<String>()), "")
        XCTAssertEqual(String(LineView<String>([Line(line: "", newline: "\n")])), "\n")
        var lines = LineView<String>()
        lines.append(contentsOf: [Line(line: "", newline: "\n")])
        XCTAssertEqual(String(lines), "\n")
        lines.insert(contentsOf: [Line(line: "", newline: "\n")], at: lines.startIndex)
        XCTAssertEqual(String(lines), "\n\n")

        var abcdef = "ABC\n"
        abcdef.lines[abcdef.lines.endIndex] = abcdef.lines.first!
        XCTAssertEqual(abcdef, "ABC\nABC\n")
    }

    func testLineViewIndex() {

        let strict: StrictString = "123\n456\n789"
        let string = String(strict)

        testComparableConformance(less: strict.lines.startIndex, greater: strict.lines.endIndex)

        XCTAssertEqual(strict.lines.startIndex.samePosition(in: strict.scalars), strict.scalars.startIndex)
        XCTAssertEqual(string.lines.startIndex.samePosition(in: string.scalars), string.scalars.startIndex)

        let index = strict.lines.index(after: strict.lines.startIndex)
        XCTAssertEqual(index.samePosition(in: strict.scalars), strict.scalars.index(strict.scalars.startIndex, offsetBy: 4))
        let stringIndex = string.lines.index(after: string.lines.startIndex)
        XCTAssertEqual(stringIndex.samePosition(in: string.scalars), string.scalars.index(string.scalars.startIndex, offsetBy: 4))

        XCTAssertEqual(index.samePosition(in: strict.clusters), strict.clusters.index(strict.clusters.startIndex, offsetBy: 4))
        XCTAssertEqual(stringIndex.samePosition(in: string.clusters), string.clusters.index(string.clusters.startIndex, offsetBy: 4))

        let abc = "ABC"
        XCTAssertEqual(abc.lines.index(after: abc.lines.startIndex), abc.lines.endIndex)

        let tricky = "1\u{D}\u{A}2\u{D}\u{A}3"
        XCTAssertEqual(tricky.scalars.index(tricky.scalars.startIndex, offsetBy: 2).line(in: tricky.lines), tricky.lines.startIndex)
        XCTAssertEqual(tricky.scalars.index(tricky.scalars.startIndex, offsetBy: 5).line(in: tricky.lines), tricky.lines.index(after: tricky.lines.startIndex))
    }

    func testRange() {
        let string = "á\nb̂\nc̀"
        XCTAssertEqual(string.lines.bounds.sameRange(in: string.scalars), string.scalars.bounds)
        let strict = StrictString(string)
        XCTAssertEqual(strict.lines.bounds.sameRange(in: strict.scalars), strict.scalars.bounds)

        XCTAssertEqual(string.lines.bounds.sameRange(in: string.clusters), string.clusters.bounds)
        XCTAssertEqual(strict.lines.bounds.sameRange(in: strict.clusters), strict.clusters.bounds)

        XCTAssertEqual(string.clusters.bounds.sameRange(in: string.scalars), string.scalars.bounds)
        XCTAssertEqual(strict.clusters.bounds.sameRange(in: strict.scalars), strict.scalars.bounds)

        let partialLine = string.clusters.startIndex ..< string.clusters.index(after: string.clusters.startIndex)
        XCTAssertNil(partialLine.sameRange(in: string.lines))
        XCTAssertNil(partialLine.sameRange(in: strict.lines))

        XCTAssertEqual(string.scalars.bounds.sameRange(in: string.lines), string.lines.bounds)
        XCTAssertEqual(strict.scalars.bounds.sameRange(in: strict.lines), strict.lines.bounds)

        XCTAssertEqual(string.scalars.bounds.sameRange(in: string.clusters), string.clusters.bounds)
        XCTAssertEqual(strict.scalars.bounds.sameRange(in: strict.clusters), strict.clusters.bounds)

        let partialCluster = string.scalars.startIndex ..< string.scalars.index(after: string.scalars.startIndex)
        XCTAssertNil(partialCluster.sameRange(in: string.lines))
        XCTAssertNil(partialCluster.sameRange(in: strict.lines))

        XCTAssertNil(partialCluster.sameRange(in: string.clusters))
        XCTAssertNil(partialCluster.sameRange(in: strict.clusters))

        XCTAssertEqual(partialLine.lines(in: string.lines), string.lines.startIndex ..< string.lines.index(after: string.lines.startIndex))
        XCTAssertEqual(partialLine.lines(in: strict.lines), strict.lines.startIndex ..< strict.lines.index(after: strict.lines.startIndex))

        XCTAssertEqual(partialCluster.lines(in: string.lines), string.lines.startIndex ..< string.lines.index(after: string.lines.startIndex))
        XCTAssertEqual(partialCluster.lines(in: strict.lines), strict.lines.startIndex ..< strict.lines.index(after: strict.lines.startIndex))
        XCTAssertEqual(partialCluster.clusters(in: string.clusters), string.clusters.startIndex ..< string.clusters.index(after: string.clusters.startIndex))
        XCTAssertEqual(partialCluster.clusters(in: strict.clusters), strict.clusters.startIndex ..< strict.clusters.index(after: strict.clusters.startIndex))

        XCTAssertEqual(string.clusters.bounds.sameRange(in: string.lines), string.lines.bounds)
        XCTAssertEqual(strict.clusters.bounds.sameRange(in: strict.lines), strict.lines.bounds)

        XCTAssertEqual(string.clusters.bounds.lines(in: string.lines), string.lines.bounds)
        XCTAssertEqual(strict.clusters.bounds.lines(in: strict.lines), strict.lines.bounds)

        XCTAssertEqual(string.scalars.bounds.clusters(in: string.clusters), string.clusters.bounds)
        XCTAssertEqual(strict.scalars.bounds.clusters(in: strict.clusters), strict.clusters.bounds)

        XCTAssertEqual(string.scalars.bounds.lines(in: string.lines), string.lines.bounds)
        XCTAssertEqual(strict.scalars.bounds.lines(in: strict.lines), strict.lines.bounds)
    }

    func testNewlinePattern() {
        testPattern(CharacterSet.newlinePattern, match: "\n".scalars)
        testPattern(CharacterSet.newlinePattern, match: "\u{D}\u{A}".scalars)
        XCTAssert(CharacterSet.newlinePattern.matches(in: ["a", "b", "c"], at: 0).isEmpty)
    }

    func testScalarView() {
        func runTests<S : StringFamily>(helloWorld: S) {

            XCTAssert(helloWorld.scalars.contains("world".scalars))
            XCTAssert(¬helloWorld.scalars.contains("xyz".scalars))

            XCTAssertEqual(helloWorld.scalars[helloWorld.scalars.startIndex], "H")

            for _ in helloWorld.scalars {}

            var variable = helloWorld
            variable.scalars.replaceSubrange(variable.scalars.index(after: variable.scalars.startIndex) ..< variable.scalars.index(before: variable.scalars.endIndex), with: "...".scalars)
            XCTAssert(variable.scalars.elementsEqual("H...!".scalars))
        }

        runTests(helloWorld: "Hello, world!")
        runTests(helloWorld: StrictString("Hello, world!"))
    }

    func testSemanticMarkup() {
        testBidirectionalCollectionConformance(of: SemanticMarkup("ABC"))
        testRangeReplaceableCollectionConformance(of: SemanticMarkup.self, element: "A")
        testCodableConformance(of: SemanticMarkup("àbçđę...").superscripted(), uniqueTestName: "Unicode")

        let markup: SemanticMarkup = "..."
        XCTAssertEqual(markup.scalars, markup.source.scalars)
        XCTAssertEqual(StrictString(markup.clusters), StrictString(markup.source.clusters))
        XCTAssertEqual(StrictString(markup.lines), StrictString(markup.source.lines))

        var mutable = markup
        mutable.scalars = markup.scalars
        mutable.clusters = markup.clusters
        mutable.lines = markup.lines
        XCTAssertEqual(mutable.scalars, markup.scalars)
        XCTAssertEqual(StrictString(mutable.clusters), StrictString(markup.clusters))
        XCTAssertEqual(StrictString(mutable.lines), StrictString(markup.lines))

        XCTAssertEqual(markup.subscripted().rawTextApproximation(), "...")

        XCTAssert(markup.hashValue ≤ Int.max)
        XCTAssertEqual(SemanticMarkup("").source, "")
        XCTAssertEqual(SemanticMarkup(["A", "B", "C"]).source, "ABC")
        XCTAssertEqual(SemanticMarkup().source, "")
    }

    func testStrictString() {
        testBidirectionalCollectionConformance(of: StrictString("ABC"))
        testRangeReplaceableCollectionConformance(of: StrictString.self, element: "A")
        testCodableConformance(of: StrictString("àbçđę..."), uniqueTestName: "Unicode")
        testFileConvertibleConformance(of: StrictString("àbçđę..."), uniqueTestName: "Unicode")

        var string = StrictString("\u{BC}")
        let appendix: UnicodeScalar = "\u{BD}"
        string.append(appendix)
        XCTAssertEqual(String(string), "1⁄41⁄2", "Normalization problem.")

        let decomposed = StrictString("éé")
        let decomposed2 = StrictString("́ée")
        XCTAssertEqual(decomposed.firstMatch(for: "e".scalars)?.range, decomposed.startIndex ..< decomposed.index(after: decomposed.startIndex))
        XCTAssertEqual(decomposed2.firstMatch(for: "́".scalars)?.range, decomposed2.startIndex..<decomposed2.index(after: decomposed2.startIndex))

        let components = decomposed.components(separatedBy: "́".scalars).map({StrictString($0.contents)})
        XCTAssertEqual(components, [StrictString("e"), StrictString("e"), StrictString()])
        let separatedComponents = decomposed.components(separatedBy: "e".scalars).map({StrictString($0.contents)})
        XCTAssertEqual(separatedComponents, [StrictString(), StrictString("́"), StrictString("́")])

        XCTAssert(decomposed.hasPrefix("e".scalars), "Problem with decomposition.")
        XCTAssert(decomposed.hasSuffix("́".scalars), "Problem with decomposition.")

        XCTAssert(decomposed2.hasPrefix("́".scalars), "Problem with decomposition.")
        XCTAssert(decomposed2.hasSuffix("e".scalars), "Problem with decomposition.")

        let commonPrefix = StrictString(decomposed.commonPrefix(with: "ee".scalars).contents)
        XCTAssertEqual(commonPrefix, StrictString("e"))
        XCTAssertEqual(StrictString(decomposed2.commonPrefix(with: "́́".scalars).contents), StrictString("́"))

        XCTAssertEqual(StrictString(decomposed.commonSuffix(with: "́́".scalars).contents), StrictString("́"))
        XCTAssertEqual(StrictString(decomposed2.commonSuffix(with: "ee".scalars).contents), StrictString("e"))

        var decomposedCopy = decomposed
        decomposedCopy.replaceMatches(for: "e".scalars, with: "a".scalars)
        XCTAssertEqual(decomposedCopy, "áá")

        decomposedCopy = decomposed
        decomposedCopy.replaceMatches(for: "́".scalars, with: "̀".scalars)
        XCTAssertEqual(decomposedCopy, "èè")

        decomposedCopy = decomposed2
        decomposedCopy.replaceMatches(for: "e".scalars, with: "a".scalars)
        XCTAssertEqual(decomposedCopy, "́áa")

        decomposedCopy = decomposed2
        decomposedCopy.replaceMatches(for: "́".scalars, with: "̀".scalars)
        XCTAssertEqual(decomposedCopy, "̀èe")

        let clusters = StrictString("0").clusters
        XCTAssertEqual(clusters.index(before: clusters.endIndex), clusters.startIndex)

        XCTAssert(StrictString.ClusterView("0".clusters).elementsEqual(clusters))
        let slice = clusters[clusters.startIndex ..< clusters.endIndex]
        XCTAssert(StrictString.ClusterView(slice).elementsEqual(clusters))

        XCTAssertEqual(StrictString("A" as ExtendedGraphemeCluster), "A")
        XCTAssertEqual("...\(StrictString("A"))...", "...A...")

        var mutable: StrictString = "0"
        mutable.clusters.truncate(at: mutable.clusters.startIndex)
        XCTAssertEqual(mutable, "")

        mutable = "ABC"
        mutable.write("DEF")
        XCTAssertEqual(mutable, "ABCDEF")

        mutable.write(to: &mutable)
        XCTAssertEqual(mutable, "ABCDEFABCDEF")

        XCTAssertEqual(StrictString("A").description, "A")

        XCTAssert(StrictString("A") < StrictString("B"))

        XCTAssertEqual(StrictString("..." as StaticString), "...")

        XCTAssert("\n".isMultiline)
        XCTAssert(¬"...".isMultiline)

        XCTAssertEqual(StrictString(StrictString.ClusterView()), "")
        XCTAssert(StrictString.ClusterView("..." as String).elementsEqual(("..." as StrictString).clusters))

        XCTAssert((["A", "B", "C"] as [StrictString]).joined().elementsEqual("ABC" as StrictString))
        XCTAssert(([] as [StrictString]).joined().elementsEqual("" as StrictString))

        // Ensure literal type can be inferred:
        let patternSampleSpace: StrictString = "ABCDEF"
        var mutableSampleSpace: StrictString = patternSampleSpace
        XCTAssertNotNil(patternSampleSpace.firstMatch(for: "AB"))
        XCTAssertEqual(patternSampleSpace.matches(for: "AB").count, 1)
        XCTAssertEqual(patternSampleSpace.prefix(upTo: "CD")?.contents.count, 2)
        XCTAssertEqual(patternSampleSpace.prefix(through: "CD")?.contents.count, 4)
        XCTAssertEqual(patternSampleSpace.suffix(from: "CD")?.contents.count, 4)
        XCTAssertEqual(patternSampleSpace.suffix(after: "CD")?.contents.count, 2)
        XCTAssertEqual(patternSampleSpace.components(separatedBy: "CD").count, 2)
        XCTAssert(patternSampleSpace.contains("CD"))
        XCTAssert(patternSampleSpace.hasPrefix("AB"))
        XCTAssert(patternSampleSpace.hasSuffix("EF"))
        XCTAssertEqual(patternSampleSpace.commonPrefix(with: "ABX").contents.count, 2)
        XCTAssertEqual(patternSampleSpace.firstNestingLevel(startingWith: "AB", endingWith: "DE")?.contents.contents.count, 1)
        var index = patternSampleSpace.startIndex
        XCTAssert(patternSampleSpace.advance(&index, over: "AB"))
        XCTAssertNotNil(patternSampleSpace.lastMatch(for: "AB"))
        XCTAssertEqual(patternSampleSpace.commonSuffix(with: "XEF").contents.count, 2)
        mutableSampleSpace.truncate(before: "EF")
        XCTAssertEqual(patternSampleSpace.truncated(before: "CD"), "AB")
        mutableSampleSpace.truncate(after: "BC")
        XCTAssertEqual(patternSampleSpace.truncated(after: "CD"), "ABCD")
        mutableSampleSpace.drop(upTo: "BC")
        XCTAssertEqual(patternSampleSpace.dropping(upTo: "CD"), "CDEF")
        mutableSampleSpace.drop(through: "BC")
        XCTAssertEqual(patternSampleSpace.dropping(through: "CD"), "EF")
        mutableSampleSpace.replaceMatches(for: "EF", with: "...")
        XCTAssertEqual(patternSampleSpace.replacingMatches(for: "EF", with: "..."), "ABCD...")
        mutableSampleSpace.mutateMatches(for: "EF") { $0.contents }
        XCTAssertEqual(patternSampleSpace.mutatingMatches(for: "EF", mutation: { $0.contents }), "ABCDEF")
    }

    func testStrictStringClusterView() {
        testBidirectionalCollectionConformance(of: StrictString("ABC").clusters)
        testRangeReplaceableCollectionConformance(of: StrictString.ClusterView.self, element: "A")
    }

    func testString() {
        testBidirectionalCollectionConformance(of: "ABC")
        testRangeReplaceableCollectionConformance(of: String.self, element: "A")

        func runTests<S : StringFamily>(helloWorld: S) {

            XCTAssertEqual(S(helloWorld.scalars), helloWorld)
            //XCTAssertEqual(S(helloWorld.clusters), helloWorld)
            // [_Workaround: The above initializer is temporarily disabled from the protocol because of an abort trap. (Swift 4.0.3)_]

            XCTAssertNotNil(helloWorld.scalars.first)

            let set: Set<S> = [helloWorld]
            XCTAssert(helloWorld ∈ set)

            //XCTAssert(S(S.ClusterView()).scalars.isEmpty)
            // [_Workaround: The above initializer is temporarily disabled from the protocol because of an abort trap. (Swift 4.0.3)_]
            XCTAssert(S(S.ScalarView()).clusters.isEmpty)
        }

        runTests(helloWorld: "Hello, world!")
        runTests(helloWorld: StrictString("Hello, world!"))

        XCTAssertEqual(StrictString("Hello, world!"), "Hello, world!")

        let simple = "1"
        let simpleUTF8 = try? String(file: simple.data(using: .utf8)!, origin: nil)
        XCTAssertEqual(simpleUTF8, simple)

        let unicode = "שלום! 🇮🇱 Γεια σας! 🇬🇷"
        let utf8 = try? String(file: unicode.data(using: .utf8)!, origin: nil)
        XCTAssertEqual(utf8, unicode)
        let utf16 = try? String(file: unicode.data(using: .utf16)!, origin: nil)
        XCTAssertEqual(utf16, unicode)
        #if false
            // [_Workaround: macOS does not fail UTF‐16 on invalid surrogate use, so this is mistaken for UTF‐16. (Swift 4.0.3)_]
            let utf32 = try? String(file: unicode.data(using: .utf32)!, origin: nil)
            XCTAssertEqual(utf32, unicode)

            let european = "¡¢£¤¥§©«¬®°±¶·»¿ÆÐ×Þßæð÷þ".data(using: .isoLatin1)! + Data([0xD8, 0x00, 0xD8, 0x00, 0x00, 0xD8, 0x00, 0xD8])
            let latin1 = try? String(file: european, origin: nil)
            XCTAssertEqual(latin1?.data(using: .isoLatin1), european)
        #endif

        XCTAssertNil("ABC".scalars.firstMatch(for: ConditionalPattern({ $0 == "D" })))

        let blah = "Blah blah blah..."
        XCTAssertNotNil(blah.scalars.firstMatch(for: "blah".scalars))

        var moreBlah = ""
        for _ in 1 ... 10 {
            moreBlah.append("Blah blah blah...\n")
        }
        XCTAssertEqual(moreBlah.lines.map({ String($0.line) }).count, 11)
        XCTAssertEqual(String(moreBlah.lines.first!.line), "Blah blah blah...")
        XCTAssertEqual(String(moreBlah.lines.last!.line), "")
    }

    func testStringClusterIndex() {
        let strict = StrictString("français")
        let string = String(strict)
        let index = string.clusters.index(string.clusters.startIndex, offsetBy: 7)
        XCTAssertEqual(index.samePosition(in: strict.scalars), strict.scalars.index(strict.scalars.startIndex, offsetBy: 8))
        XCTAssertEqual(string.clusters.startIndex.samePosition(in: strict.lines), strict.lines.startIndex)
        XCTAssertNil(index.samePosition(in: strict.lines))
        XCTAssertEqual(index.line(in: strict.lines), strict.lines.startIndex)

        XCTAssertEqual(index.samePosition(in: string.scalars), string.scalars.index(string.scalars.startIndex, offsetBy: 8))
        XCTAssertEqual(string.clusters.startIndex.samePosition(in: string.lines), string.lines.startIndex)
        XCTAssertNil(index.samePosition(in: string.lines))
        XCTAssertEqual(index.line(in: string.lines), string.lines.startIndex)
    }

    func testStringScalarIndex() {
        let strict = StrictString("français")
        let string = String(strict)
        let index = string.scalars.index(string.scalars.startIndex, offsetBy: 8)
        let internalIndex = string.scalars.index(string.scalars.startIndex, offsetBy: 5)
        XCTAssertEqual(index.samePosition(in: strict.clusters), strict.clusters.index(strict.clusters.startIndex, offsetBy: 7))
        XCTAssertNil(internalIndex.samePosition(in: strict.clusters))
        XCTAssertEqual(strict.scalars.startIndex.samePosition(in: strict.lines), strict.lines.startIndex)
        XCTAssertEqual(strict.scalars.endIndex.samePosition(in: strict.lines), strict.lines.endIndex)
        XCTAssertNil(internalIndex.samePosition(in: strict.lines))
        XCTAssertEqual(internalIndex.cluster(in: strict.clusters), strict.clusters.index(strict.clusters.startIndex, offsetBy: 4))

        let multiline = StrictString("123\n456\n789")
        let secondLine = multiline.scalars.index(multiline.scalars.startIndex, offsetBy: 4)
        XCTAssertEqual(secondLine.samePosition(in: multiline.lines), multiline.lines.index(after: multiline.lines.startIndex))
        let middleOfSecondLine = multiline.scalars.index(multiline.scalars.startIndex, offsetBy: 6)
        XCTAssertNil(middleOfSecondLine.samePosition(in: multiline.lines))
        let thirdLine = multiline.scalars.index(multiline.scalars.startIndex, offsetBy: 8)
        XCTAssertEqual(thirdLine.samePosition(in: multiline.lines), multiline.lines.index(multiline.lines.startIndex, offsetBy: 2))

        XCTAssertEqual(multiline.scalars.startIndex.line(in: multiline.lines), multiline.lines.startIndex)
        XCTAssertEqual(secondLine.line(in: multiline.lines), multiline.lines.index(after: multiline.lines.startIndex))
        XCTAssertEqual(middleOfSecondLine.line(in: multiline.lines), multiline.lines.index(after: multiline.lines.startIndex))
        XCTAssertEqual(thirdLine.line(in: multiline.lines), multiline.lines.index(multiline.lines.startIndex, offsetBy: 2))
        XCTAssertEqual(multiline.scalars.endIndex.line(in: multiline.lines), multiline.lines.endIndex)

        let multilineString = String(multiline)
        XCTAssertEqual(secondLine.samePosition(in: multilineString.lines), multilineString.lines.index(after: multilineString.lines.startIndex))
        XCTAssertNil(middleOfSecondLine.samePosition(in: multilineString.lines))
        XCTAssertEqual(thirdLine.samePosition(in: multilineString.lines), multilineString.lines.index(multilineString.lines.startIndex, offsetBy: 2))

        XCTAssertEqual(multilineString.scalars.startIndex.line(in: multilineString.lines), multilineString.lines.startIndex)
        XCTAssertEqual(secondLine.line(in: multilineString.lines), multilineString.lines.index(after: multilineString.lines.startIndex))
        XCTAssertEqual(middleOfSecondLine.line(in: multilineString.lines), multilineString.lines.index(after: multilineString.lines.startIndex))
        XCTAssertEqual(thirdLine.line(in: multilineString.lines), multilineString.lines.index(multilineString.lines.startIndex, offsetBy: 2))
        XCTAssertEqual(multilineString.scalars.endIndex.line(in: multilineString.lines), multilineString.lines.endIndex)

        XCTAssertEqual(multilineString.scalars.endIndex.samePosition(in: multilineString.lines), multilineString.lines.endIndex)
    }

    func testStringScalarView() {
        testBidirectionalCollectionConformance(of: "ABC".scalars)
        testRangeReplaceableCollectionConformance(of: String.ScalarView.self, element: "A")
    }

    func testUnicodeScalar() {
        XCTAssertEqual(("A" as UnicodeScalar).hexadecimalCode, "0041")
        XCTAssertEqual(("‐" as UnicodeScalar).hexadecimalCode, "2010")

        func verifyVisible(_ codePoint: Int) {
            if let scalar = UnicodeScalar(codePoint) {
                #if !os(Linux)
                    // [_Workaround: A number of obscure compatibility characters end up empty on Linux. (Swift 4.0.3)_]
                    XCTAssertNotEqual(scalar.visibleRepresentation, "")
                #endif
            }
        }
        for codePoint in 0 ..< 0xFF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x300 ..< 0x3FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x600 ..< 0x6FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x700 ..< 0x7FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x800 ..< 0x8FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x1600 ..< 0x16FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x1800 ..< 0x18FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x2000 ..< 0x20FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x3000 ..< 0x30FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0xFE00 ..< 0xFFFF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x11000 ..< 0x110FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x1BC00 ..< 0x1BCFF {
            verifyVisible(codePoint)
        }
        for codePoint in 0x1D100 ..< 0x1D1FF {
            verifyVisible(codePoint)
        }
        for codePoint in 0xE0000 ..< 0xE00FF {
            verifyVisible(codePoint)
        }
    }

    static var allTests: [(String, (SDGTextAPITests) -> () throws -> Void)] {
        return [
            ("testCharacterSet", testCharacterSet),
            ("testLineView", testLineView),
            ("testLineViewIndex", testLineViewIndex),
            ("testRange", testRange),
            ("testScalarView", testScalarView),
            ("testSemanticMarkup", testSemanticMarkup),
            ("testStrictString", testStrictString),
            ("testStrictStringClusterView", testStrictStringClusterView),
            ("testString", testString),
            ("testStringClusterIndex", testStringClusterIndex),
            ("testStringScalarIndex", testStringScalarIndex),
            ("testStringScalarView", testStringScalarView),
            ("testUnicodeScalar", testUnicodeScalar)
        ]
    }
}