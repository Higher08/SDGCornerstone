/*
 Shared.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone

 Copyright ©2017–2021 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if canImport(Combine)
  import Combine
#endif

#if canImport(Combine)
  extension Shared: ObservableObject {}
#endif
/// A reference to a shared value.
public final class Shared<Value>: TransparentWrapper {

  // MARK: - Initialization

  /// Creates a reference to a value.
  ///
  /// - Parameters:
  ///     - value: The value.
  public init(_ value: Value) {
    self.value = value
  }

  // MARK: - Properties

  /// The value.
  public var value: Value {
    willSet {
      #if canImport(Combine)
        if #available(macOS 10.15, tvOS 13, iOS 13, watchOS 6, *) {
          objectWillChange.send()
        }
      #endif
    }
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

  private var observers: [(observer: Weak<AnyObject>, identifier: String)] = []

  // MARK: - Observing

  /// Registers an observer, so that the observer will be notified when the value changes.
  ///
  /// The observer will receive its first such message immediately.
  ///
  /// - Parameters:
  ///     - observer: The observer.
  ///     - identifier: An identifier for the shared value. If provided, it can be used later to differentiate between several values watched by the same observer.
  ///     - reportInitialState: If `true`, the observer will receive its first notification immediately to report the initial state. If `false`, the observer will not be notified until the state actually changes.
  ///
  /// - SeeAlso: `valueChanged(for:)`
  public func register(
    observer: SharedValueObserver,
    identifier: String = "",
    reportInitialState: Bool = true
  ) {

    // Prevent duplicates.
    cancel(observer: observer)

    // Register and notify.
    observers.append((Weak(observer), identifier))
    if reportInitialState {
      observer.valueChanged(for: identifier)
    }
  }

  /// Cancels an observer, so that the observer will be no longer be notified when the value changes.
  ///
  /// This method is only necessary when an observer needs to persist after cancelling observation. In most cases, cancellation is automated through ARC.
  ///
  /// - Parameters:
  ///     - observer: The observer.
  public func cancel(observer: SharedValueObserver) {
    for index in observers.indices.reversed() {
      let (existingObserver, _) = observers[index]

      if existingObserver.pointee == nil {
        observers.remove(at: index)
      } else if existingObserver.pointee === observer {
        observers.remove(at: index)
      }
    }
  }

  #if canImport(Combine)
    // MARK: - ObservableObject

    private var objectWillChangeStorage: Any?
    /// A publisher that emits before the object has changed.
    @available(macOS 10.15, tvOS 13, iOS 13, watchOS 6, *)
    public var objectWillChange: ObservableObjectPublisher {
      return cached(in: &objectWillChangeStorage) {
        return ObservableObjectPublisher()
      } as! ObservableObjectPublisher
    }
  #endif

  // MARK: - TransparentWrapper

  public var wrappedInstance: Any {
    return value
  }
}
