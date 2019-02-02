/*
 TextualPlaygroundDisplay.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A type which displays its textual description in playgrounds.
///
/// Conformance Requirements:
///
/// - `CustomStringConvertible`
public protocol TextualPlaygroundDisplay : CustomPlaygroundDisplayConvertible, CustomStringConvertible {}

extension TextualPlaygroundDisplay {

    // MARK: - CustomPlaygroundDisplayConvertible

    // #documentation(SDGCornerstone.CustomPlaygroundDisplayConvertible.playgroundDescription)
    /// Returns the custom playground description for this instance.
    @inlinable public var playgroundDescription: Any {
        return String(describing: self)
    }
}
