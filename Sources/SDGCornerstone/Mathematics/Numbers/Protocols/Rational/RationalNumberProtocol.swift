/*
 RationalNumberProtocol.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2016–2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

/// A type which *only ever* represents rational numbers.
///
/// Conformance Requirements:
///
/// - `RationalArithmetic`
/// - `func reduced() -> (numerator: Integer, denominator: Integer)`
public protocol RationalNumberProtocol : RationalArithmetic {

    // [_Define Documentation: SDGCornerstone.RationalNumberProtocol.Integer_]
    /// The type to use for the numerator and denominator.
    associatedtype Integer : IntegerProtocol

    // [_Define Documentation: SDGCornerstone.RationalNumberProtocol.reducedSimpleFraction()_]
    /// Returns the numerator and denominator of the number as a reduced simple fraction.
    func reducedSimpleFraction() -> (numerator: Integer, denominator: Integer)
}

extension RationalNumberProtocol {

    // MARK: - Text Representations

    private func digitsOnly(_ number: StrictString) -> Bool {
        return ¬number.contains(ConditionalPattern(condition: { $0 ∉ CharacterSet.decimalDigits ∪ ["−"] }))
    }

    private func parenthesizeIfNecessary(_ number: inout StrictString) {
        if ¬digitsOnly(number) {
            number.prepend("(")
            number.append(")")
        }
    }

    /// Returns the number as a simple fraction. (“−19⁄2”, “6”, “(50 001)⁄(10 000)”,  etc.)
    public func asSimpleFraction(thousandsSeparator: UnicodeScalar = " ") -> StrictString {
        let (numerator, denominator) = reducedSimpleFraction()

        if denominator == 1 {
            return numerator.inDigits(thousandsSeparator: thousandsSeparator)
        } else {

            var a = numerator.inDigits(thousandsSeparator: thousandsSeparator)
            var b = denominator.inDigits(thousandsSeparator: thousandsSeparator)

            parenthesizeIfNecessary(&a)
            parenthesizeIfNecessary(&b)

            return a + "⁄" + b
        }
    }

    /// Returns the number as a mixed fraction. (“−9 1⁄2”, “6”, “5 + 1⁄(10 000)”,  etc.)
    public func asMixedFraction(thousandsSeparator: UnicodeScalar = " ") -> StrictString {
        let wholeString = integralDigits(thousandsSeparator: thousandsSeparator)

        let fraction = (|self|).mod(1)
        if fraction == 0 {
            return wholeString
        } else {

            let fractionString = fraction.asSimpleFraction(thousandsSeparator: thousandsSeparator)
            if ¬fractionString.contains("(") {
                return wholeString + " " + fractionString
            } else {
                return wholeString + " + " + fractionString
            }
        }
    }

    /// Returns the number as a ratio. (“−19 ∶ 2”, “6 ∶ 1”, “50 001 ∶ 10 000”,  etc.)
    public func asRatio(thousandsSeparator: UnicodeScalar = " ") -> StrictString {
        let (numerator, denominator) = reducedSimpleFraction()
        return numerator.integralDigits(thousandsSeparator: thousandsSeparator) + " ∶ " + denominator.integralDigits(thousandsSeparator: thousandsSeparator)
    }
}