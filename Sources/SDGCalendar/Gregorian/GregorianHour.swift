/*
 GregorianHour.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone

 Copyright ©2017–2019 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import SDGCornerstoneLocalizations

/// An hour of the Gregorian day.
public struct GregorianHour :  CardinalCalendarComponent, CodableViaRawRepresentableCalendarComponent, ConsistentDurationCalendarComponent, ICalendarComponent, ISOCalendarComponent, RawRepresentableCalendarComponent, TextualPlaygroundDisplay {

    // MARK: - Static Properties

    /// The number of hours in a day.
    public static let hoursPerDay: Int = HebrewHour.hoursPerDay

    // MARK: - Properties

    private var hour: Int

    // MARK: - ConsistentDurationCalendarComponent

    // @documentation(SDGCornerstone.ConsistentDurationCalendarComponent.duration)
    /// The duration.
    public static var duration: CalendarInterval<FloatMax> {
        return (1 as FloatMax).hours
    }

    // MARK: - Text Representations

    /// Returns the hour in digits for twenty‐four–hour notation. (0–23)
    public func inDigitsInTwentyFourHourFormat() -> StrictString {
        return hour.inDigits()
    }

    /// Returns the hour in digits for twelve‐hour notation. (1–12)
    public func inDigitsInTwelveHourFormat() -> StrictString {
        var result = hour
        if result > 12 {
            result −= 12
        }
        if result == 0 {
            result = 12
        }
        return result.inDigits()
    }

    /// Returns “a.m.” or “p.m.”, corresponding to the hour.
    public func amOrPM() -> StrictString {
        if hour ≥ 12 {
            return "p.m."
        } else {
            return "a.m."
        }
    }

    // MARK: - CustomStringConvertible

    // #documentation(SDGCornerstone.CustomStringConvertible.description)
    /// A textual representation of the instance.
    public var description: String {
        return String(UserFacing<StrictString, FormatLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .deutschDeutschland, .françaisFrance, .ελληνικάΕλλάδα, .עברית־ישראל:
                return self.inDigitsInTwentyFourHourFormat()
            case .englishUnitedStates, .englishCanada:
                return self.inDigitsInTwelveHourFormat() + " " + self.amOrPM()
            }
        }).resolved())
    }

    // MARK: - ISOCalendarComponent

    // #documentation(SDGCornerstone.ISOCalendarCompenent.inISOFormat())
    /// Returns a string representation in the ISO format.
    public func inISOFormat() -> StrictString {
        return hour.inDigits().filled(to: 2, with: "0", from: .start)
    }

    // MARK: - PointProtocol

    // #documentation(SDGCornerstone.PointProtocol.Vector)
    /// The type to be used as a vector.
    public typealias Vector = Int

    // MARK: - RawRepresentableCalendarComponent

    // #documentation(SDGCornerstone.RawRepresentableCalendarComponent.init(unsafeRawValue:))
    /// Creates an instance with an unchecked raw value.
    ///
    /// - Note: Do not call this initializer directly. Call `init(_:)` instead, because it validates the raw value before passing it to this initializer.
    public init(unsafeRawValue: RawValue) {
        hour = unsafeRawValue
    }

    // #documentation(SDGCornerstone.RawRepresentableCalendarComponent.validRange)
    /// The valid range for raw values.
    public static let validRange: Range<RawValue>? = 0 ..< GregorianHour.hoursPerDay

    // #documentation(SDGCornerstone.RawRepresentableCalendarComponent.rawValue)
    /// The raw value.
    public var rawValue: RawValue {
        return hour
    }
}
