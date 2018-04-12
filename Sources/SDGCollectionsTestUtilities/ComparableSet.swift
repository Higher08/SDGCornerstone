/*
 ComparableSet.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/SDGCornerstone

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogicTestUtilities

/// Tests a type’s conformance to ComparableSet.
@_inlineable public func testComparableSetConformance<T>(of set: T, member: T.Element, nonmember: T.Element, superset: T, overlapping: T, disjoint: T, file: StaticString = #file, line: UInt = #line) where T : ComparableSet {

    testEquatableConformance(differingInstances: (set, superset), file: file, line: line)

    testSetDefinitionConformance(of: set, member: member, nonmember: nonmember, file: file, line: line)

    test(operator: (⊆, "⊆"), on: (set, superset), returns: true, file: file, line: line)
    test(operator: (⊆, "⊆"), on: (superset, set), returns: false, file: file, line: line)
    test(operator: (⊆, "⊆"), on: (set, set), returns: true, file: file, line: line)

    test(operator: (⊈, "⊈"), on: (set, superset), returns: false, file: file, line: line)
    test(operator: (⊈, "⊈"), on: (superset, set), returns: true, file: file, line: line)
    test(operator: (⊈, "⊈"), on: (set, set), returns: false, file: file, line: line)

    test(operator: (⊇, "⊇"), on: (superset, set), returns: true, file: file, line: line)
    test(operator: (⊇, "⊇"), on: (set, superset), returns: false, file: file, line: line)
    test(operator: (⊇, "⊇"), on: (set, set), returns: true, file: file, line: line)

    test(operator: (⊉, "⊉"), on: (superset, set), returns: false, file: file, line: line)
    test(operator: (⊉, "⊉"), on: (set, superset), returns: true, file: file, line: line)
    test(operator: (⊉, "⊉"), on: (set, set), returns: false, file: file, line: line)

    test(operator: (⊊, "⊊"), on: (set, superset), returns: true, file: file, line: line)
    test(operator: (⊊, "⊊"), on: (superset, set), returns: false, file: file, line: line)
    test(operator: (⊊, "⊊"), on: (set, set), returns: false, file: file, line: line)

    test(operator: (⊋, "⊋"), on: (set, superset), returns: false, file: file, line: line)
    test(operator: (⊋, "⊋"), on: (superset, set), returns: true, file: file, line: line)
    test(operator: (⊋, "⊋"), on: (set, set), returns: false, file: file, line: line)

    test(method: (T.overlaps, "overlaps"), of: set, with: overlapping, returns: true, file: file, line: line)
    test(method: (T.overlaps, "overlaps"), of: set, with: disjoint, returns: false, file: file, line: line)
    test(method: (T.overlaps, "overlaps"), of: set, with: set, returns: true, file: file, line: line)

    test(method: (T.isDisjoint, "isDisjoint"), of: set, with: disjoint, returns: true, file: file, line: line)
    test(method: (T.isDisjoint, "isDisjoint"), of: set, with: overlapping, returns: false, file: file, line: line)
    test(method: (T.isDisjoint, "isDisjoint"), of: set, with: set, returns: false, file: file, line: line)
}