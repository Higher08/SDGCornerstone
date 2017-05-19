/*
 NilLiteral.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A `nil` literal.
public struct NilLiteral : ExpressibleByNilLiteral {

    // MARK: - Initialization

    /// Creates an instance of `NilLiteral`.
    ///
    /// - Parameters:
    ///     - nilLiteral: Void.
    public init(nilLiteral: Void) {}

    // MARK: - Equality

    // [_Inherit Documentation: SDGCornerstone.Equatable.≠_]
    /// Returns `true` if the two values are inequal.
    ///
    /// - Parameters:
    ///     - lhs: A value to compare.
    ///     - rhs: Another value to compare.
    ///
    /// - RecommendedOver: !=
    public static func ≠ <T>(lhs: T?, rhs: NilLiteral) -> Bool {
        return lhs != nil
        // Allows “x ≠ nil” even when x is not Equatable.
    }
}
