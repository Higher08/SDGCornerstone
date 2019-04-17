/*
 GenericAdditiveArithmetic.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone

 Copyright ©2016–2019 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A value that can be added and subtracted.
///
/// `GenericAdditiveArithmetic` types do not need to conform to `Comparable`, allowing conformance by two‐dimensional vectors, etc. For additional behaviour specific to one‐dimensional types, see `NumericAdditiveArithmetic`.
///
/// Conformance Requirements:
///
/// - `Hashable`
/// - `Subtractable`
/// - `IntegralArithmetic`, `WholeNumberProtocol`, `ExpressibleByIntegerLiteral` or `static var zero: Self { get }`
public protocol GenericAdditiveArithmetic : AdditiveArithmetic, Decodable, Encodable, Hashable, Subtractable {}

extension GenericAdditiveArithmetic {

    @inlinable public static func - (precedingValue: Self, followingValue: Self) -> Self { // @exempt(from: unicode)
        return precedingValue − followingValue
    }

    @inlinable public static func -= (precedingValue: inout Self, followingValue: Self) { // @exempt(from: unicode)
        precedingValue −= followingValue
    }
}

extension GenericAdditiveArithmetic where Self : ExpressibleByIntegerLiteral {

    @inlinable public static var zero: Self {
        return 0
    }
}