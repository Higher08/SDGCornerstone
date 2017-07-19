/*
 Line.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/macOS

 Copyright ©2017 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A view of a string’s contents as a collection of lines.
public struct Line<Base : StringFamily> {

    /// Creates a line.
    public init(line: Base, newline: Base) {
        self.line = line
        self.newline = newline
    }

    // MARK: - Properties

    /// The contents of the line.
    public var line: Base
    /// The newline character(s).
    public var newline: Base
}