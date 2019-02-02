/*
 WholeArithmetic.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone

 Copyright ©2016–2019 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

/// A type that can be used for whole‐number arithmetic.
///
/// Conformance Requirements:
///
/// - `NumericAdditiveArithmetic`
/// - `FixedScaleOneDimensionalPoint`
/// - `init(_ uInt: UIntMax)`
/// - `init?<T>(exactly source: T) where T : BinaryInteger`
/// - `static func ×= (precedingValue: inout Self, followingValue: Self)`
/// - `mutating func divideAccordingToEuclid(by divisor: Self)`
/// - `WholeNumberProtocol`, `IntegerProtocol`, `RationalNumberProtocol` or `static func ↑= (precedingValue: inout Self, followingValue: Self)`
public protocol WholeArithmetic : FixedScaleOneDimensionalPoint, Numeric, NumericAdditiveArithmetic {

    // MARK: - Initialization

    // @documentation(SDGCornerstone.WholeArithmetic.init(uInt:))
    /// Creates an instance equal to `uInt`.
    ///
    /// - Parameters:
    ///     - uInt: An instance of `UIntMax`.
    init(_ uInt: UIntMax)

    // MARK: - Operations

    // #workaround(Swift 4.2.1, Duplicates Subtractable, but works around disambiguation bugs.)
    // #documentation(SDGCornerstone.Subtractable.−)
    /// Returns the difference of the preceding value minus the following value.
    ///
    /// - Parameters:
    ///     - precedingValue: The starting value.
    ///     - followingValue: The value to subtract.
    static func − (precedingValue: Self, followingValue: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.×)
    /// Returns the product of the preceding value times the following value.
    ///
    /// - Parameters:
    ///     - precedingValue: A value.
    ///     - followingValue: Another value.
    static func × (precedingValue: Self, followingValue: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.×=)
    /// Modifies the preceding value by multiplication with the following value.
    ///
    /// - Parameters:
    ///     - precedingValue: The value to modify.
    ///     - followingValue: The coefficient by which to multiply.
    static func ×= (precedingValue: inout Self, followingValue: Self)

    // @documentation(SDGCornerstone.WholeArithmetic.divideAccordingToEuclid(by:))
    /// Sets `self` to the integral quotient of `self` divided by `divisor`.
    ///
    /// - Note: This is a true mathematical quotient. i.e. (−5) ÷ 3 = −2 remainder 1, *not* −1 remainder −2
    ///
    /// - Parameters:
    ///     - divisor: The divisor.
    mutating func divideAccordingToEuclid(by divisor: Self)

    // @documentation(SDGCornerstone.WholeArithmetic.dividedAccordingToEuclid(by:))
    /// Returns the integral quotient of `self` divided by `divisor`.
    ///
    /// - Note: This is a true mathematical quotient. i.e. (−5) ÷ 3 = −2 remainder 1, *not* −1 remainder −2
    ///
    /// - Parameters:
    ///     - divisor: The divisor.
    func dividedAccordingToEuclid(by divisor: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.mod(_:))
    /// Returns the Euclidean remainder of `self` ÷ `divisor`.
    ///
    /// - Parameters:
    ///     - divisor: The divisor.
    ///
    /// - Note: This is a true mathematical modulo operation. i.e. (−5) mod 3 = 1, *not* −2
    func mod(_ divisor: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.formRemainder(mod:))
    /// Sets `self` to the Euclidean remainder of `self` ÷ `divisor`.
    ///
    /// - Parameters:
    ///     - divisor: The divisor.
    ///
    /// - Note: This is a true mathematical modulo operation. i.e. (−5) mod 3 = 1, *not* −2
    mutating func formRemainder(mod divisor: Self)

    // @documentation(SDGCornerstone.WholeArithmetic.isDivisible(by:))
    /// Returns `true` if `self` is evenly divisible by `divisor`.
    ///
    /// - Parameters:
    ///     - divisor: The divisor to check.
    func isDivisible(by divisor: Self) -> Bool

    // @documentation(SDGCornerstone.WholeArithmetic.gcd(_:_:))
    /// Returns the greatest common divisor of `a` and `b`.
    ///
    /// - Parameters:
    ///     - a: A value.
    ///     - b: Another value.
    static func gcd(_ a: Self, _ b: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.formGreatestCommonDivisor(with:))
    /// Sets `self` to the greatest common divisor of `self` and `other`.
    ///
    /// - Parameters:
    ///     - other: Another value.
    mutating func formGreatestCommonDivisor(with other: Self)

    // @documentation(SDGCornerstone.WholeArithmetic.lcm(_:_:))
    /// Returns the least common multiple of `a` and `b`.
    ///
    /// - Parameters:
    ///     - a: A value.
    ///     - b: Another value.
    static func lcm(_ a: Self, _ b: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.formLeastCommonMultiple(with:))
    /// Sets `self` to the least common multiple of `self` and `other`.
    ///
    /// - Parameters:
    ///     - other: Another value.
    mutating func formLeastCommonMultiple(with other: Self)

    // @documentation(SDGCornerstone.WholeArithmetic.↑)
    /// Returns the result of the preceding value to the power of the following value.
    ///
    /// - Precondition:
    ///   - If `Self` conforms to `IntegerProtocol`, `followingValue` must be non‐negative.
    ///   - If `Self` conforms to `RationalNumberProtocol`, `followingValue` must be an integer.
    ///   - If `Self` conforms to `RealNumberProtocol`, either
    ///     - `precedingValue` must be positive, or
    ///     - `followingValue` must be an integer.
    ///
    /// - Parameters:
    ///     - precedingValue: The base.
    ///     - followingValue: The exponent.
    static func ↑ (precedingValue: Self, followingValue: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.↑=)
    /// Modifies the preceding value by exponentiation with the following value.
    ///
    /// - Precondition:
    ///   - If `Self` conforms to `IntegerProtocol`, `followingValue` must be non‐negative.
    ///   - If `Self` conforms to `RationalNumberProtocol`, `followingValue` must be an integer.
    ///   - If `Self` conforms to `RealNumberProtocol`, either
    ///     - `precedingValue` must be positive, or
    ///     - `followingValue` must be an integer.
    ///
    /// - Parameters:
    ///     - precedingValue: The value to modify.
    ///     - followingValue: The exponent.
    static func ↑= (precedingValue: inout Self, followingValue: Self)

    // MARK: - Classification

    // @documentation(SDGCornerstone.WholeArithmetic.isNatural)
    /// Returns `true` if `self` is a natural number.
    var isNatural: Bool { get }

    // @documentation(SDGCornerstone.WholeArithmetic.isWhole)
    /// Returns `true` if `self` is a whole number.
    var isWhole: Bool { get }

    // @documentation(SDGCornerstone.WholeArithmetic.isIntegral)
    /// Returns `true` if `self` is an integer.
    var isIntegral: Bool { get }

    // @documentation(SDGCornerstone.WholeArithmetic.isEven)
    /// Returns true if `self` is an even integer.
    var isEven: Bool { get }

    // @documentation(SDGCornerstone.WholeArithmetic.isOdd)
    /// Returns true if `self` is an odd integer.
    var isOdd: Bool { get }

    // MARK: - Rounding

    /// A rule for rounding.
    typealias RoundingRule = FloatingPointRoundingRule

    // @documentation(SDGCornerstone.WholeArithmetic.round(_:))
    /// Rounds the value to an integral value using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    mutating func round(_ rule: RoundingRule)

    // @documentation(SDGCornerstone.WholeArithmetic.rounded(_:))
    /// Returns the value rounded to an integral value using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    func rounded(_ rule: RoundingRule) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.round(_:toMultipleOf:))
    /// Rounds the value to a multiple of `factor` using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    ///     - factor: The factor to round to a multiple of.
    mutating func round(_ rule: RoundingRule, toMultipleOf factor: Self)

    // @documentation(SDGCornerstone.WholeArithmetic.rounded(_:toMultipleOf:))
    /// Returns the value rounded to a multiple of `factor` using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    ///     - factor: The factor to round to a multiple of.
    func rounded(_ rule: RoundingRule, toMultipleOf factor: Self) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.random(in:))
    /// Creates a random value within a particular range.
    ///
    /// - Parameters:
    ///     - range: The allowed range for the random value.
    static func random(in range: ClosedRange<Self>) -> Self

    // @documentation(SDGCornerstone.WholeArithmetic.random(in:using:))
    /// Creates a random value within a particular range using the specified randomizer.
    ///
    /// - Parameters:
    ///     - range: The allowed range for the random value.
    ///     - generator: The randomizer to use to generate the random value.
    static func random<R>(in range: ClosedRange<Self>, using generator: inout R) -> Self where R : RandomNumberGenerator
}

extension WholeArithmetic {

    // @documentation(SDGCornerstone.WholeArithmetic.init(uIntFamily:))
    /// Creates an instance equal to `uInt`.
    ///
    /// - Parameters:
    ///     - uInt: An instance of a type conforming to `UIntFamily`.
    @inlinable public init<U : UIntFamily>(_ uInt: U) {
        self.init(UIntMax(uInt))
    }

    // #documentation(SDGCornerstone.WholeArithmetic.×)
    /// Returns the product of the preceding value times the following value.
    ///
    /// - Parameters:
    ///     - precedingValue: A value.
    ///     - followingValue: Another value.
    @inlinable public static func × (precedingValue: Self, followingValue: Self) -> Self {
        return nonmutatingVariant(of: ×=, on: precedingValue, with: followingValue)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.dividedAccordingToEuclid(by:))
    /// Returns the integral quotient of `self` divided by `divisor`.
    ///
    /// - Note: This is a true mathematical quotient. i.e. (−5) ÷ 3 = −2 remainder 1, *not* −1 remainder −2
    ///
    /// - Parameters:
    ///     - divisor: The divisor.
    @inlinable public func dividedAccordingToEuclid(by divisor: Self) -> Self {
        return nonmutatingVariant(of: { $0.divideAccordingToEuclid(by: $1) }, on: self, with: divisor)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.mod(_:))
    /// Returns the Euclidean remainder of `self` ÷ `divisor`.
    ///
    /// - Parameters:
    ///     - divisor: The divisor.
    ///
    /// - Note: This is a true mathematical modulo operation. i.e. (−5) mod 3 = 1, *not* −2
    @inlinable public func mod(_ divisor: Self) -> Self {
        return nonmutatingVariant(of: { $0.formRemainder(mod: $1) }, on: self, with: divisor)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.formRemainder(mod:))
    /// Sets `self` to the Euclidean remainder of `self` ÷ `divisor`.
    ///
    /// - Parameters:
    ///     - divisor: The divisor.
    ///
    /// - Note: This is a true mathematical modulo operation. i.e. (−5) mod 3 = 1, *not* −2
    @inlinable public mutating func formRemainder(mod divisor: Self) {
        self −= dividedAccordingToEuclid(by: divisor) × divisor
    }

    // #documentation(SDGCornerstone.WholeArithmetic.isDivisible(by:))
    /// Returns `true` if `self` is evenly divisible by `divisor`.
    ///
    /// - Parameters:
    ///     - divisor: The divisor to check.
    @inlinable public func isDivisible(by divisor: Self) -> Bool {
        return mod(divisor) == 0
    }

    // #documentation(SDGCornerstone.WholeArithmetic.gcd(_:_:))
    /// Returns the greatest common divisor of `a` and `b`.
    ///
    /// - Parameters:
    ///     - a: A value.
    ///     - b: Another value.
    @inlinable public static func gcd(_ a: Self, _ b: Self) -> Self {
        return nonmutatingVariant(of: { $0.formGreatestCommonDivisor(with: $1) }, on: a, with: b)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.formGreatestCommonDivisor(with:))
    /// Sets `self` to the greatest common divisor of `self` and `other`.
    ///
    /// - Parameters:
    ///     - other: Another value.
    @inlinable public mutating func formGreatestCommonDivisor(with other: Self) {
        if self.isNegative ∨ other.isNegative {
            self.formAbsoluteValue()
            formGreatestCommonDivisor(with: |other|)
        } else if other == 0 /* finished */ {
            // self = self
        } else {
            self = Self.gcd(other, mod(other))
        }
    }

    // #documentation(SDGCornerstone.WholeArithmetic.lcm(_:_:))
    /// Returns the least common multiple of `a` and `b`.
    ///
    /// - Parameters:
    ///     - a: A value.
    ///     - b: Another value.
    @inlinable public static func lcm(_ a: Self, _ b: Self) -> Self {
        return nonmutatingVariant(of: { $0.formLeastCommonMultiple(with: $1) }, on: a, with: b)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.formLeastCommonMultiple(with:))
    /// Sets `self` to the least common multiple of `self` and `other`.
    ///
    /// - Parameters:
    ///     - other: Another value.
    @inlinable public mutating func formLeastCommonMultiple(with other: Self) {
        self ×= other.dividedAccordingToEuclid(by: Self.gcd(self, other))
    }

    // #documentation(SDGCornerstone.WholeArithmetic.↑)
    /// Returns the result of the preceding value to the power of the following value.
    ///
    /// - Precondition:
    ///   - If `Self` conforms to `IntegerProtocol`, `followingValue` must be non‐negative.
    ///   - If `Self` conforms to `RationalNumberProtocol`, `followingValue` must be an integer.
    ///   - If `Self` conforms to `RealNumberProtocol`, either
    ///     - `precedingValue` must be positive, or
    ///     - `followingValue` must be an integer.
    ///
    /// - Parameters:
    ///     - precedingValue: The base.
    ///     - followingValue: The exponent.
    @inlinable public static func ↑ (precedingValue: Self, followingValue: Self) -> Self {
        return nonmutatingVariant(of: ↑=, on: precedingValue, with: followingValue)
    }

    @inlinable internal mutating func raiseWholeNumberToThePowerOf(wholeNumber exponent: Self) {
        if exponent == 0 {
            self = 1
        } else if exponent == 1 {
            // self = self
        } else if exponent.isEven {
            // p = (b ↑ 2) ↑ (e ÷ 2)
            self ×= self
            self ↑= (exponent.dividedAccordingToEuclid(by: 2))
        } else /* followingValue.isOdd */ {
            // p = b × b ↑ (e − 1)
            self ×= (self ↑ (exponent − (1 as Self)))
        }
    }

    // #documentation(SDGCornerstone.WholeArithmetic.isNatural)
    /// Returns `true` if `self` is a natural number.
    @inlinable public var isNatural: Bool {
        return isWhole ∧ self ≠ 0
    }

    // #documentation(SDGCornerstone.WholeArithmetic.isWhole)
    /// Returns `true` if `self` is a whole number.
    @inlinable public var isWhole: Bool {
        return isIntegral ∧ isNonNegative
    }

    // #documentation(SDGCornerstone.WholeArithmetic.isIntegral)
    /// Returns `true` if `self` is an integer.
    @inlinable public var isIntegral: Bool {
        return isDivisible(by: 1)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.isEven)
    /// Returns true if `self` is an even integer.
    @inlinable public var isEven: Bool {
        return isDivisible(by: 2)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.isOdd)
    /// Returns true if `self` is an odd integer.
    @inlinable public var isOdd: Bool {
        return isIntegral ∧ ¬isEven
    }

    // #documentation(SDGCornerstone.WholeArithmetic.round(_:toMultipleOf:))
    /// Rounds the value to a multiple of `factor` using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    ///     - factor: The factor to round to a multiple of.
    @inlinable public mutating func round(_ rule: RoundingRule, toMultipleOf factor: Self) {
        switch rule {
        case .down:
            self.divideAccordingToEuclid(by: factor)
            self ×= factor
        case .up:
            if ¬isDivisible(by: factor) {
                round(.down, toMultipleOf: factor)
                self += factor
            }
        case .towardZero:
            if isNegative {
                round(.up, toMultipleOf: factor)
            } else {
                round(.down, toMultipleOf: factor)
            }
        case .awayFromZero:
            if isNegative {
                round(.down, toMultipleOf: factor)
            } else {
                round(.up, toMultipleOf: factor)
            }
        default:
            let floor = rounded(.down, toMultipleOf: factor)
            let portion: Self = self − floor
            let double = portion × 2

            if double < factor /* portion < half */ {
                self = floor
            } else if double > factor /* portion > half */ {
                self = floor + factor
            } else {
                // portion == half
                switch rule {
                case .toNearestOrAwayFromZero:
                    if isNegative {
                        self = floor
                    } else {
                        self = floor + factor
                    }
                case .toNearestOrEven:
                    if floor.dividedAccordingToEuclid(by: factor).isEven {
                        self = floor
                    } else {
                        self = floor + factor
                    }
                default:
                    _unreachable()
                }
            }
        }
    }

    // #documentation(SDGCornerstone.WholeArithmetic.rounded(_:toMultipleOf:))
    /// Returns the value rounded to a multiple of `factor` using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    ///     - factor: The factor to round to a multiple of.
    @inlinable public func rounded(_ rule: RoundingRule, toMultipleOf factor: Self) -> Self {
        return nonmutatingVariant(of: { $0.round($1, toMultipleOf: $2) }, on: self, with: (rule, factor))
    }

    // #documentation(SDGCornerstone.WholeArithmetic.round(_:))
    /// Rounds the value to an integral value using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    @inlinable public mutating func round(_ rule: RoundingRule) {
        round(rule, toMultipleOf: 1)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.rounded(_:))
    /// Returns the value rounded to an integral value using the specified rounding rule.
    ///
    /// - Parameters:
    ///     - rule: The rounding rule follow.
    @inlinable public func rounded(_ rule: RoundingRule) -> Self {
        return nonmutatingVariant(of: { $0.round($1) }, on: self, with: rule)
    }

    // #documentation(SDGCornerstone.WholeArithmetic.random(in:))
    /// Creates a random value within a particular range.
    ///
    /// - Parameters:
    ///     - range: The allowed range for the random value.
    @inlinable public static func random(in range: ClosedRange<Self>) -> Self {
        var generator = SystemRandomNumberGenerator()
        return random(in: range, using: &generator)
    }

    // MARK: - ExpressibleByIntegerLiteral

    // @documentation(SDGCornerstone.ExpressibleByIntegerLiteral.init(integerLiteral:))
    /// Creates an instance from an integer literal.
    ///
    /// - Parameters:
    ///     - integerLiteral: The integer literal.
    @inlinable public init(integerLiteral: UIntMax) {
        self.init(integerLiteral)
    }

    // MARK: - Numeric

    // @documentation(SDGCornerstone.Numeric.init(exactly:))
    /// Creates a new instance from the given integer, if it can be represented exactly.

    /// Multiplies two values and produces their product.
    @inlinable public static func * (precedingValue: Self, followingValue: Self) -> Self { // @exempt(from: unicode)
        return precedingValue × followingValue
    }

    /// Multiplies two values and stores the result in the left‐hand‐side variable.
    @inlinable public static func *= (precedingValue: inout Self, followingValue: Self) { // @exempt(from: unicode)
        precedingValue ×= followingValue
    }
}

// MARK: - Whole Arithmetic

// #documentation(SDGCornerstone.WholeArithmetic.gcd(_:_:))
/// Returns the greatest common divisor of `a` and `b`.
///
/// - Parameters:
///     - a: A value.
///     - b: Another value.
@inlinable public func gcd<N : WholeArithmetic>(_ a: N, _ b: N) -> N {
    return N.gcd(a, b)
}

// #documentation(SDGCornerstone.WholeArithmetic.lcm(_:_:))
/// Returns the least common multiple of `a` and `b`.
///
/// - Parameters:
///     - a: A value.
///     - b: Another value.
@inlinable public func lcm<N : WholeArithmetic>(_ a: N, _ b: N) -> N {
    return N.lcm(a, b)
}

extension BinaryFloatingPoint where Self.RawSignificand : FixedWidthInteger {
    @inlinable internal static func _random(in range: ClosedRange<Self>) -> Self {
        return random(in: range)
    }
}
extension WholeArithmetic where Self : BinaryFloatingPoint, Self.RawSignificand : FixedWidthInteger {
    // Disambiguate

    // #documentation(SDGCornerstone.WholeArithmetic.random(in:))
    /// Creates a random value within a particular range.
    ///
    /// - Parameters:
    ///     - range: The allowed range for the random value.
    @inlinable public static func random(in range: ClosedRange<Self>) -> Self {
        return _random(in: range)
    }
}

extension FixedWidthInteger {
    @inlinable internal static func _random(in range: ClosedRange<Self>) -> Self {
        return random(in: range)
    }
}
extension WholeArithmetic where Self : FixedWidthInteger {
    // Disambiguate

    // #documentation(SDGCornerstone.WholeArithmetic.random(in:))
    /// Creates a random value within a particular range.
    ///
    /// - Parameters:
    ///     - range: The allowed range for the random value.
    @inlinable public static func random(in range: ClosedRange<Self>) -> Self {
        return _random(in: range)
    }
}
