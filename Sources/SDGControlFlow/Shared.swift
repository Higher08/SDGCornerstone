/*
 Shared.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A reference to a shared value.
public class Shared<Value> : TransparentWrapper {

    // MARK: - Initialization

    /// Creates a reference to a value.
    public init(_ value: Value) {
        self.value = value
    }

    // MARK: - Properties

    /// The value.
    public var value: Value {
        didSet {
            for index in observers.indices.reversed() {
                let (possibleObserver, identifier) = observers[index]

                if let observer = possibleObserver.pointee as? SharedValueObserver {
                    observer.valueChanged(for: identifier)
                } else {
                    observers.remove(at: index)
                }
            }
        }
    }

    @usableFromInline internal var observers: [(observer: Weak<AnyObject>, identifier: String)] = []

    // MARK: - Observing

    /// Registers an observer. The observer will be notified when the value changes.
    ///
    /// The observer will receive its first such message immediately.
    ///
    /// - Parameters:
    ///     - observer: The observer.
    ///     - identifier: An identifier for the shared value. If provided, it can be used later to differentiate between several values watched by the same observer.
    ///     - reportInitialState: If `true`, the observer will receive its first notification immediately to report the initial state. If `false`, the observer will not be notified until the state actually changes.
    ///
    /// - SeeAlso: `valueChanged(for:)`
    @inlinable public func register(observer: SharedValueObserver, identifier: String = "", reportInitialState: Bool = true) {

        // Prevent duplicates.
        cancel(observer: observer)

        // Register and notify.
        observers.append((Weak(observer), identifier))
        if reportInitialState {
            observer.valueChanged(for: identifier)
        }
    }

    /// Cancels an observer. The observer will be no longer be notified when the value changes.
    ///
    /// This method is only necessary when an observer needs to persist after cancelling observation. In most cases, cancellation is automated through ARC.
    ///
    /// - Parameters:
    ///     - observer: The observer.
    @inlinable public func cancel(observer: SharedValueObserver) {
        for index in observers.indices.reversed() {
            let (existingObserver, _) = observers[index]

            if existingObserver.pointee == nil {
                observers.remove(at: index)
            } else if existingObserver.pointee === observer {
                observers.remove(at: index)
            }
        }
    }

    // MARK: - TransparentWrapper

    // #documentation(SDGCornerstone.TransparentWrapper.wrapped)
    /// The wrapped instance.
    @inlinable public var wrappedInstance: Any {
        return value
    }
}
