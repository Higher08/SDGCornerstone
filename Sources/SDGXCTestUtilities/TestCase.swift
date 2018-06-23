/*
 TestCase.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/SDGCornerstone

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if canImport(XCTest) && (!(os(iOS) || os(watchOS) || os(tvOS)) || targetEnvironment(simulator)) // XCTest does not contain bitcode.
// MARK: - #if canImport(XCTest) && (!(os(iOS) || os(watchOS) || os(tvOS)) || targetEnvironment(simulator))

import SDGLogic
import SDGPersistence
import SDGTesting

/// A test case which simplifies testing for targets which link against the `SDGCornerstone` package.
open class TestCase : XCTestCase {

    static var initialized = false
    /// Provides an opportunity to reset state before each test method in a test case is called.
    ///
    /// - Note: Subclasses must call `super.setUp()`.
    open override func setUp() {
        if ¬TestCase.initialized {
            TestCase.initialized = true
            ProcessInfo.applicationIdentifier = "ca.solideogloria.SDGCornerstone.SharedTestingDomain"
        }

        testAssertionMethod = XCTAssert

        #if !os(Linux) // [_Workaround: Linux does not have this property. (Swift 4.1.2)_]
        Thread.current.qualityOfService = .utility // The default of .userInteractive is absurd.
        #endif

        super.setUp()
    }

    /// :nodoc:
    public func testLinuxMainGenerationCompatibility() {}
}

#endif
