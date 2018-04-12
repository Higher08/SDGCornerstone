/*
 CGVector.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/SDGCornerstone

 Copyright ©2016–2018 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !os(Linux)
    // MARK: - #if !os(Linux)

    import CoreGraphics

    import SDGMathematics

    extension CGVector : AdditiveArithmetic, Negatable, TwoDimensionalVector {

        // MARK: - AdditiveArithmetic

        // [_Inherit Documentation: SDGCornerstone.AdditiveArithmetic.additiveIdentity_]
        /// The additive identity (origin).
        public static let additiveIdentity = zero

        // MARK: - TwoDimensionalVector

        // [_Inherit Documentation: SDGCornerstone.VectorProtocol.Scalar_]
        /// The scalar type.
        // The scalar type.
        public typealias Scalar = CGFloat

        // [_Inherit Documentation: SDGCornerstone.TwoDimensionalVector.init(Δx:Δy:)_]
        /// The difference in *y*.
        public init(Δx : Scalar, Δy : Scalar) {
            self = CGVector(dx: Δx, dy: Δy)
        }

        // [_Inherit Documentation: SDGCornerstone.TwoDimensionalVector.Δx_]
        /// The difference in *x*.
        @_inlineable public var Δx : Scalar {
            get {
                return dx
            }
            set {
                dx = newValue
            }
        }

        // [_Inherit Documentation: SDGCornerstone.TwoDimensionalVector.Δy_]
        /// The difference in *y*.
        @_inlineable public var Δy : Scalar {
            get {
                return dy
            }
            set {
                dy = newValue
            }
        }
    }

#endif