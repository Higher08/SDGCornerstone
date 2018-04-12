/*
 MutableSet.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/SDGCornerstone

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Tests a type’s conformance to MutableSet.
@_inlineable public func testMutableSetConformance<T>(of type: T.Type, a: T.Element, b: T.Element, c: T.Element, file: StaticString = #file, line: UInt = #line) where T : MutableSet, T.Element : Hashable {

    var set = T()
    set.insert(a)
    set.update(with: b)

    var superset = set
    superset.insert(c)

    var overlapping = set
    overlapping.remove(a)
    overlapping.update(with: c)

    var disjoint = T()
    disjoint.insert(c)

    testComparableSetConformance(of: set, member: a, nonmember: c, superset: superset, overlapping: overlapping, disjoint: disjoint, file: file, line: line)
    // SetAlgebra
    test(method: (T.contains, "contains"), of: set, with: a, returns: true, file: file, line: line)

    var intersection = T()
    intersection.update(with: b)

    test(operator: (∩, "∩"), on: (set, Set([b, c])), returns: intersection, file: file, line: line)
    test(operator: (∩, "∩"), on: (set, overlapping), returns: intersection, file: file, line: line)
    test(operator: (∩, "∩"), on: (set, overlapping), returns: intersection, file: file, line: line)
    test(assignmentOperator: (∩=, "∩="), with: (set, Set([b, c])), resultsIn: intersection, file: file, line: line)
    test(assignmentOperator: (∩=, "∩="), with: (set, overlapping), resultsIn: intersection, file: file, line: line)
    // SetAlgebra
    test(method: (T.intersection, "intersection"), of: set, with: overlapping, returns: intersection, file: file, line: line)
    test(mutatingMethod: (T.formIntersection, "formIntersection"), of: set, with: overlapping, resultsIn: intersection, file: file, line: line)

    test(operator: (∪, "∪"), on: (set, Set([b, c])), returns: superset, file: file, line: line)
    test(operator: (∪, "∪"), on: (set, overlapping), returns: superset, file: file, line: line)
    test(assignmentOperator: (∪=, "∪="), with: (set, Set([b, c])), resultsIn: superset, file: file, line: line)
    test(assignmentOperator: (∪=, "∪="), with: (set, overlapping), resultsIn: superset, file: file, line: line)
    // SetAlgebra
    test(method: (T.union, "union"), of: set, with: overlapping, returns: superset, file: file, line: line)
    test(mutatingMethod: (T.formUnion, "formUnion"), of: set, with: overlapping, resultsIn: superset, file: file, line: line)

    var complement = T()
    complement.insert(a)

    test(operator: (∖, "∖"), on: (set, Set([b, c])), returns: complement, file: file, line: line)
    test(operator: (∖, "∖"), on: (set, overlapping), returns: complement, file: file, line: line)
    test(assignmentOperator: (∖=, "∖="), with: (set, Set([b, c])), resultsIn: complement, file: file, line: line)
    test(assignmentOperator: (∖=, "∖="), with: (set, overlapping), resultsIn: complement, file: file, line: line)

    var symmetricDifference = superset
    symmetricDifference.remove(b)

    test(operator: (∆, "∆"), on: (set, overlapping), returns: symmetricDifference, file: file, line: line)
    test(assignmentOperator: (∆=, "∆="), with: (set, overlapping), resultsIn: symmetricDifference, file: file, line: line)
    // SetAlgebra
    test(method: (T.symmetricDifference, "symmetricDifference"), of: set, with: overlapping, returns: symmetricDifference, file: file, line: line)
    test(mutatingMethod: (T.formSymmetricDifference, "formSymmetricDifference"), of: set, with: overlapping, resultsIn: symmetricDifference, file: file, line: line)
}