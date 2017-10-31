/*
 PatternMatchingExampleTests.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

import SDGCornerstone

class PatternMatchingExampleTests : TestCase {

    func testBackwardsDifferences1() {

        // [_Define Example: lastMatch(for:in:) Backwards Differences 1_]
        let collection = [0, 0, 0, 0, 0]
        let pattern = [0, 0]

        XCTAssertEqual(collection.lastMatch(for: pattern)?.range, 3 ..< 5)

        XCTAssertEqual(collection.matches(for: pattern).last?.range, 2 ..< 4)
        // (Here the matches are 0 ..< 2 and 2 ..< 4; the final zero is incomplete.)
        // [_End_]
    }

    func testBackwardsDifferences2() {

        // [_Define Example: lastMatch(for:in:) Backwards Differences 2_]
        let collection = [0, 0, 1]
        let pattern = CompositePattern([RepetitionPattern([0], count: 1 ..< Int.max, consumption: .lazy), LiteralPattern([1])])

        XCTAssertEqual(collection.lastMatch(for: pattern)?.range, 1 ..< 3)
        // (Backwards, the pattern has already matched the 1, so the lazy consumption stops after the first 0 it encounteres.)

        XCTAssertEqual(collection.matches(for: pattern).last?.range, 0 ..< 3)
        // (Forwards, the lazy consumption keeps consuming zeros until the pattern can be completed with a one.)
        // [_End_]
    }

    func testNestingLevel() {

        // [_Define Example: Nesting Level_]
        let equation = "2(3x − (y + 4)) = z"
        let nestingLevel = equation.scalars.firstNestingLevel(startingWith: "(".scalars, endingWith: ")".scalars)!

        XCTAssertEqual(String(nestingLevel.container.contents), "(3x − (y + 4))")
        XCTAssertEqual(String(nestingLevel.contents.contents), "3x − (y + 4)")
        // [_End_]
    }

    static var allTests: [(String, (PatternMatchingExampleTests) -> () throws -> Void)] {
        return [
            ("testBackwardsDifferences1", testBackwardsDifferences1),
            ("testBackwardsDifferences2", testBackwardsDifferences2),
            ("testNestingLevel", testNestingLevel)
        ]
    }
}