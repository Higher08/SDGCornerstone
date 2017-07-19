/*
 PointProtocol.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2016–2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A type that can be used with `+(_:_:)` and `−(_:_:)` in conjunction with an associated `Vector` type.
///
/// - Note: Unlike `Strideable`, types conforming to `PointProtocol` do not need to conform to `Comparable`, allowing conformance by two‐dimensional points, etc.
///
/// Conformance Requirements:
///
/// - `Equatable`
/// - `static func += (lhs: inout Self, rhs: Vector)`
/// - `static func − (lhs: Self, rhs: Self) -> Vector`
public protocol PointProtocol : Equatable {

    // [_Define Documentation: SDGCornerstone.PointProtocol.Vector_]
    /// The type to be used as a vector.
    associatedtype Vector : Negatable

    // [_Define Documentation: SDGCornerstone.PointProtocol.+_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to add.
    ///
    /// - MutatingVariant: +=
    static func + (lhs: Self, rhs: Vector) -> Self

    // [_Define Documentation: SDGCornerstone.PointProtocol.+=_]
    /// Moves the point on the left by the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to add.
    ///
    /// - NonmutatingVariant: +
    static func += (lhs: inout Self, rhs: Vector)

    // [_Define Documentation: SDGCornerstone.PointProtocol.−(_:vector:)_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the inverse of the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to subtract.
    ///
    /// - MutatingVariant: −=
    //static func − (lhs: Self, rhs: Vector) -> Self
    // [_Workaround: The above line is temporarily commented because it falsely triggers “ambiguous use of operator” errors. See testSubtractable. (Swift 3.1.0)_]

    // [_Define Documentation: SDGCornerstone.PointProtocol.−_]
    /// Returns the vector that leads from the point on the left to the point on the right.
    ///
    /// - Parameters:
    ///     - lhs: The endpoint.
    ///     - rhs: The startpoint.
    static func − (lhs: Self, rhs: Self) -> Vector

    // [_Define Documentation: SDGCornerstone.PointProtocol.−=_]
    /// Moves the point on the left by the inverse of the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to subtract.
    ///
    /// - NonmutatingVariant: −
    static func −= (lhs: inout Self, rhs: Vector)
}

extension PointProtocol {

    fileprivate static func addAsPointProtocol(_ lhs: Self, _ rhs: Vector) -> Self {
        var result = lhs
        result += rhs
        return result
    }
    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to add.
    ///
    /// - MutatingVariant: +=
    public static func + (lhs: Self, rhs: Vector) -> Self {
        return addAsPointProtocol(lhs, rhs)
    }

    fileprivate static func subtractAsPointProtocol(_ lhs: Self, _ rhs: Vector) -> Self {
        var result = lhs
        result −= rhs
        return result
    }
    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−(_:vector:)_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the inverse of the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to subtract.
    ///
    /// - MutatingVariant: −=
    public static func − (lhs: Self, rhs: Vector) -> Self {
        return subtractAsPointProtocol(lhs, rhs)
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−=_]
    /// Moves the point on the left by the inverse of the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to subtract.
    ///
    /// - NonmutatingVariant: −
    public static func −= (lhs: inout Self, rhs: Vector) {
        lhs += −rhs
    }
}

extension PointProtocol where Self.Vector == Self {
    // MARK: - Self.Vector == Self

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−(_:vector:)_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the inverse of the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to subtract.
    ///
    /// - MutatingVariant: −=
    public static func − (lhs: Self, rhs: Vector) -> Self { // [_Exempt from Code Coverage_] Apparently unreachable.
        // Disambiguate Self − Vector = Self vs Self − Self = Vector
        return subtractAsPointProtocol(lhs, rhs)
    }
}

extension PointProtocol where Self : ConsistentlyOrderedCalendarComponent, Self : EnumerationCalendarComponent {
    // MARK: - where Self : ConsistentlyOrderedCalendarComponent, Self : EnumerationCalendarComponent

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+=_]
    /// Moves the point on the left by the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to add.
    ///
    /// - NonmutatingVariant: +
    public static func += (lhs: inout Self, rhs: Vector) {
        lhs = Self(numberAlreadyElapsed: lhs.numberAlreadyElapsed + rhs)
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−_]
    /// Returns the vector that leads from the point on the left to the point on the right.
    ///
    /// - Parameters:
    ///     - lhs: The endpoint.
    ///     - rhs: The startpoint.
    public static func − (lhs: Self, rhs: Self) -> Vector {
        return lhs.numberAlreadyElapsed − rhs.numberAlreadyElapsed
    }
}

extension PointProtocol where Self : IntXFamily {
    // MARK: - where Self : IntXFamily

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to add.
    ///
    /// - MutatingVariant: +=
    public static func + (lhs: Self, rhs: Stride) -> Self {
        return lhs.advanced(by: rhs)
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+=_]
    /// Moves the point on the left by the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to add.
    ///
    /// - NonmutatingVariant: +
    public static func += (lhs: inout Self, rhs: Stride) {
        lhs = lhs.advanced(by: rhs)
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−_]
    /// Returns the vector that leads from the point on the left to the point on the right.
    ///
    /// - Parameters:
    ///     - lhs: The endpoint.
    ///     - rhs: The startpoint.
    public static func − (lhs: Self, rhs: Self) -> Stride {
        return rhs.distance(to: lhs)
    }
}

extension PointProtocol where Self : NumericCalendarComponent {
    // MARK: - where Self : NumericCalendarComponent

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+=_]
    /// Moves the point on the left by the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to add.
    ///
    /// - NonmutatingVariant: +
    public static func += (lhs: inout Self, rhs: RawValue) {
        lhs = Self(lhs.rawValue + rhs)
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−_]
    /// Returns the vector that leads from the point on the left to the point on the right.
    ///
    /// - Parameters:
    ///     - lhs: The endpoint.
    ///     - rhs: The startpoint.
    public static func − (lhs: Self, rhs: Self) -> RawValue {
        return lhs.rawValue − rhs.rawValue
    }
}

extension PointProtocol where Self : Strideable {
    // MARK: - where Self : Strideable

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to add.
    ///
    /// - MutatingVariant: +=
    public static func + (lhs: Self, rhs: Vector) -> Self {
        // Disambiguate PointProtocol.+ vs Strideable.+
        return addAsPointProtocol(lhs, rhs)
    }
}

extension PointProtocol where Self : TwoDimensionalPoint {
    // MARK: - where Self : TwoDimensionalPoint

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+=_]
    /// Moves the point on the left by the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to add.
    ///
    /// - NonmutatingVariant: +
    public static func += (lhs: inout Self, rhs: Vector) {
        lhs.x += rhs.Δx
        lhs.y += rhs.Δy
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−_]
    /// Returns the vector that leads from the point on the left to the point on the right.
    ///
    /// - Parameters:
    ///     - lhs: The endpoint.
    ///     - rhs: The startpoint.
    public static func − (lhs: Self, rhs: Self) -> Vector {
        let Δx = lhs.x − rhs.x
        let Δy = lhs.y − rhs.y
        return Vector(Δx : Δx, Δy : Δy)
    }
}

extension PointProtocol where Self : UIntFamily {
    // MARK: - where Self : UIntFamily

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+_]
    /// Returns the point arrived at by starting at the point on the left and moving according to the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The starting point.
    ///     - rhs: The vector to add.
    ///
    /// - MutatingVariant: +=
    public static func + (lhs: Self, rhs: Stride) -> Self {
        return lhs.advanced(by: rhs)
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.+=_]
    /// Moves the point on the left by the vector on the right.
    ///
    /// - Parameters:
    ///     - lhs: The point to modify.
    ///     - rhs: The vector to add.
    ///
    /// - NonmutatingVariant: +
    public static func += (lhs: inout Self, rhs: Stride) {
        lhs = lhs.advanced(by: rhs)
    }

    // [_Inherit Documentation: SDGCornerstone.PointProtocol.−_]
    /// Returns the vector that leads from the point on the left to the point on the right.
    ///
    /// - Parameters:
    ///     - lhs: The endpoint.
    ///     - rhs: The startpoint.
    public static func − (lhs: Self, rhs: Self) -> Stride {
        return rhs.distance(to: lhs)
    }
}