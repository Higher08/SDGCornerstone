/*
 BitwiseLogic.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2016–2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A type that can be used with bitwise operations.
///
/// Conformance Requirements:
///     - `static var allZeros: Self { get }`
///     - `mutating func formBitwiseNot()`
///     - `mutating func formBitwiseAnd(with other: Self)`
///     - `mutating func formBitwiseOr(with other: Self)`
///     - `mutating func formBitwiseExclusiveOr(with other: Self)`
public protocol BitwiseLogic : BitwiseOperations {

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.bitwiseNot()_]
    /// Returns the bits not present in `self`.
    func bitwiseNot() -> Self

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.formBitwiseNot()_]
    /// Inverts the bits.
    mutating func formBitwiseNot()

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.bitwiseAnd(with:)_]
    /// Returns the bits present in both `self` and `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    func bitwiseAnd(with other: Self) -> Self

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.formBitwiseAnd(with:)_]
    /// Removes the bits not also present in `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    mutating func formBitwiseAnd(with other: Self)

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.bitwiseOr(with:)_]
    /// Returns the bits present in either `self` or `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    func bitwiseOr(with other: Self) -> Self

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.formBitwiseOr(with:)_]
    /// Inserts the bits present in `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    mutating func formBitwiseOr(with other: Self)

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.bitwiseExclusiveOr(with:)_]
    /// Returns the bits present only in `self` or only in `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    func bitwiseExclusiveOr(with other: Self) -> Self

    // [_Define Documentation: SDGCornerstone.BitwiseLogic.formBitwiseExclusiveOr(with:)_]
    /// Inserts the bits present in `other` and removes the bits present in both.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    mutating func formBitwiseExclusiveOr(with other: Self)
}

extension BitwiseLogic {

    // [_Inherit Documentation: SDGCornerstone.BitwiseLogic.bitwiseNot()_]
    /// Returns the bits not present in `self`.
    public func bitwiseNot() -> Self {
        var result = self
        result.formBitwiseNot()
        return result
    }

    // [_Inherit Documentation: SDGCornerstone.BitwiseLogic.bitwiseAnd(with:)_]
    /// Returns the bits present in both `self` and `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    public func bitwiseAnd(with other: Self) -> Self {
        var result = self
        result.formBitwiseAnd(with: other)
        return result
    }

    // [_Inherit Documentation: SDGCornerstone.BitwiseLogic.bitwiseOr(with:)_]
    /// Returns the bits present in either `self` or `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    public func bitwiseOr(with other: Self) -> Self {
        var result = self
        result.formBitwiseOr(with: other)
        return result
    }

    // [_Inherit Documentation: SDGCornerstone.BitwiseLogic.bitwiseExclusiveOr(with:)_]
    /// Returns the bits present only in `self` or only in `other`.
    ///
    /// - Parameters:
    ///     - other: The other bits.
    public func bitwiseExclusiveOr(with other: Self) -> Self {
        var result = self
        result.formBitwiseExclusiveOr(with: other)
        return result
    }
}
