/*
 IntegralArithmetic.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2016–2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A type that can be used for integral arithmetic.
///
/// Conformance Requirements:
///
/// - `WholeArithmetic`
/// - `Negatable`
/// - `init(_ int: IntMax)`
public protocol IntegralArithmetic : AbsoluteValuable /* requires negatability */, Negatable, SignedNumber, WholeArithmetic {

    // [_Define Documentation: SDGCornerstone.IntegralArithmetic.init(int:)_]
    /// Creates an instance equal to `int`.
    ///
    /// - Properties:
    ///     - int: An instance of `IntMax`.
    init(_ int: IntMax)
}

extension IntegralArithmetic {

    // [_Define Documentation: SDGCornerstone.IntegralArithmetic.init(intFamily:)_]
    /// Creates an instance equal to `int`.
    ///
    /// - Properties:
    ///     - int: An instance of a member of the `Int` family.
    public init<I : IntFamily>(_ int: I) {
        self.init(int.toIntMax())
    }
}
