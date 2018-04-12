/*
 DateDefinition.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/SDGCornerstone

 Copyright ©2017–2018 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCornerstoneLocalizations

// [_Example 1: DateDefinition_]
/// A type that provides a definition for a `CalendarDate`.
///
/// ```swift
/// extension CalendarDate {
///
///     // This initializer creates a date using the number of days into the current millennium.
///     public init(daysIntoMillennium: FloatMax) {
///         self.init(definition: DaysIntoMillennium(daysIntoMillennium))
///     }
///
///     // This property is available to dates with any kind of definition.
///     public var daysIntoMillennium: FloatMax {
///         return converted(to: DaysIntoMillennium.self).daysIntoMillennium
///     }
/// }
///
/// private struct DaysIntoMillennium : DateDefinition {
///
///     // The reference date is January 1, 2001 at 00:00
///     fileprivate static let referenceDate = CalendarDate(gregorian: .january, 1, 2001, at: 0, 0, 0)
///
///     fileprivate static let identifier: StrictString = "MyModule.DaysIntoMillenium"
///     fileprivate let daysIntoMillennium: FloatMax
///     fileprivate let intervalSinceReferenceDate: CalendarInterval<FloatMax>
///
///     fileprivate init(_ daysIntoMillennium: FloatMax) {
///         self.daysIntoMillennium = daysIntoMillennium
///         intervalSinceReferenceDate = daysIntoMillennium.days
///     }
///
///     fileprivate init(intervalSinceReferenceDate: CalendarInterval<FloatMax>) {
///         self.intervalSinceReferenceDate = intervalSinceReferenceDate
///         daysIntoMillennium = intervalSinceReferenceDate.inDays
///     }
///
///     fileprivate func encode(to encoder: Encoder) throws {
///         // Only the definition (i.e. daysIntoMillennium) needs to be encoded.
///         // Derived information (i.e. intervalSinceRefrenceDate) can be recomputed.
///         try encode(to: encoder, via: daysIntoMillennium)
///     }
///     fileprivate init(from decoder: Decoder) throws {
///         try self.init(from: decoder, via: FloatMax.self, convert: { DaysIntoMillennium($0) })
///     }
/// }
/// ```
///
/// - Warning: If you intend to encode and decode a custom definition type, you must register the type with `CalendarDate.register(_:)` before performing any decoding operations.
///
/// Conformance Requirements:
///
/// - `static var referenceDate: CalendarDate { get }`
/// - `init(intervalSinceReferenceDate: CalendarInterval<FloatMax>)`
/// - `var intervalSinceReferenceDate: CalendarInterval<FloatMax> { get }`
public protocol DateDefinition : Codable {

    // MARK: - Static Properties

    // [_Define Documentation: SDGCornerstone.DateDefinition.identifier_]
    /// A string that uniquely identifies the type for encoding and decoding.
    static var identifier: StrictString { get }

    // [_Define Documentation: SDGCornerstone.DateDefinition.referenceDate_]
    /// The reference date for the type.
    static var referenceDate: CalendarDate { get }

    // MARK: - Initialization

    // [_Define Documentation: SDGCornerstone.DateDefinition.init(intervalSinceReferenceDate:)_]
    /// Creates a date from an interval since the reference date.
    init(intervalSinceReferenceDate: CalendarInterval<FloatMax>)

    // MARK: - Properties

    // [_Define Documentation: SDGCornerstone.DateDefinition.intervalSinceReferenceDate_]
    /// The interval since the reference date.
    var intervalSinceReferenceDate: CalendarInterval<FloatMax> { get }

    // MARK: - Coding

    /// :nodoc:
    func _encode() throws -> StrictString

    /// :nodoc:
    init(_decoding json: StrictString, codingPath: [CodingKey]) throws
}

extension DateDefinition {

    /// :nodoc:
    @_inlineable public func _encode() throws -> StrictString {
        return try StrictString(file: try JSONEncoder().encode([self]), origin: nil)
    }
    internal func encode() throws -> StrictString {
        return try _encode()
    }

    /// :nodoc:
    @_inlineable public init(_decoding json: StrictString, codingPath: [CodingKey]) throws {
        guard let result = (try JSONDecoder().decode([Self].self, from: json.file)).first else {

            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: String(UserFacingText({ (localization: APILocalization) in
                switch localization {
                case .englishCanada:
                    return "Empty container array."
                }
            }).resolved())))
        }
        self = result
    }
    internal init(decoding json: StrictString, codingPath: [CodingKey]) throws {
        try self.init(_decoding: json, codingPath: codingPath)
    }
}