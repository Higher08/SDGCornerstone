/*
 HalvesView.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

internal struct HalvesView<UIntValue : UIntFamily> : BidirectionalCollection, Collection, MutableCollection, RandomAccessCollection {

    // MARK: - Initialization

    internal init(_ uInt: UIntValue) {
        self.uInt = uInt
    }

    // MARK: - Static Properties

    internal static var count: IndexDistance {
        return 2
    }

    // MARK: - Properties

    internal var uInt: UIntValue

    private typealias BinarySize = UIntValue
    private var elementSize: BinarySize {
        let totalSize = BinarySize(BinaryView<UIntValue>.count)
        let elementCount = BinarySize(count)
        return totalSize.dividedAccordingToEuclid(by: elementCount)
    }

    private var elementMask: UIntValue {
        return (1 << elementSize) − 1
    }

    // MARK: - BidirectionalCollection

    internal func index(before i: Index) -> Index {
        return i − (1 as Index)
    }

    // MARK: - Collection

    internal typealias Element = UIntValue
    internal typealias Index = UIntValue
    internal typealias IndexDistance = Int

    internal let startIndex: Index = 0
    internal let endIndex: Index = Index(HalvesView.count)

    internal func index(after i: Index) -> Index {
        return i + (1 as Index)
    }

    internal subscript(index: Index) -> Element {
        get {
            assertIndexExists(index)
            let offset = index × elementSize
            return uInt.bitwiseAnd(with: elementMask << offset) >> offset
        }
        set {
            assertIndexExists(index)
            let offset = index × elementSize
            let oldErased = uInt.bitwiseAnd(with: (elementMask << offset).bitwiseNot())
            uInt = oldErased.bitwiseOr(with: newValue << offset)
        }
    }

    // MARK: - RandomAccessCollection

    internal typealias Indices = DefaultRandomAccessIndices<HalvesView>
}