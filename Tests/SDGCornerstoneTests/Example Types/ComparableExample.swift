/*
 ComparableExample.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2016–2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

struct ComparableExample : Comparable {
    var value: Int

    // Comparable

    static func < (lhs: ComparableExample, rhs: ComparableExample) -> Bool {
        return lhs.value < rhs.value
    }

    // Equatable

    static func == (lhs: ComparableExample, rhs: ComparableExample) -> Bool {
        return lhs.value == rhs.value
    }
}
