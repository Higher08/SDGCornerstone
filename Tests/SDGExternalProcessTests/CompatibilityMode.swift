/*
 CompatibilityMode.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone

 Copyright ©2019 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if !(os(iOS) || os(tvOS))
@testable import SDGExternalProcess

func forAllCompatibilityModes(_ closure: () throws -> Void) rethrows {
    for mode in [false, true] {
        let previous = ExternalProcess.compatibilityMode
        ExternalProcess.compatibilityMode = mode
        defer { ExternalProcess.compatibilityMode = previous }

        try closure()
    }
}
#endif