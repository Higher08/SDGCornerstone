/*
 SDGCalendarAPITests.swift

 This source file is part of the SDGCornerstone open source project.
 https://sdggiesbrecht.github.io/SDGCornerstone/SDGCornerstone

 Copyright ©2018 Jeremy David Giesbrecht and the SDGCornerstone project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGMathematics
import SDGMathematicsTestUtilities
import SDGPersistenceTestUtilities
import SDGCalendar
import SDGXCTestUtilities

class SDGCalendarAPITests : TestCase {

    func testCalendarComponent() {
        XCTAssertEqual(GregorianDay.meanDuration, GregorianDay.maximumDuration)
        XCTAssertEqual(GregorianDay.minimumDuration, GregorianDay.maximumDuration)

        XCTAssertEqual(GregorianMinute(ordinal: 5), GregorianMinute(numberAlreadyElapsed: 4))
        XCTAssertEqual(GregorianMinute(ordinal: 4).ordinal, 4)

        XCTAssertEqual(GregorianMonth(ordinal: 2), .february)

        XCTAssertEqual(GregorianDay(ordinal: 8), 8)

        XCTAssertEqual(GregorianHour.duration, (1 as FloatMax).hours)
        XCTAssertEqual(GregorianMinute.duration, (1 as FloatMax).minutes)
        XCTAssertEqual(GregorianSecond.duration, (1 as FloatMax).seconds)
        XCTAssertEqual(GregorianWeekday.duration, (1 as FloatMax).days)
        XCTAssertEqual(HebrewDay.duration, (1 as FloatMax).days)
        XCTAssertEqual(HebrewHour.duration, (1 as FloatMax).hours)
        XCTAssertEqual(HebrewPart.duration, (1 as FloatMax).hebrewParts)
        XCTAssertEqual(HebrewWeekday.duration, (1 as FloatMax).days)

        XCTAssertEqual(GregorianDay(10) − GregorianDay(4), 6)
        XCTAssertEqual(GregorianMonth.february − GregorianMonth.january, 1)

        var day = GregorianWeekday.monday
        day.decrement()
        XCTAssertEqual(day, .sunday)
    }

    func testCalendarDate() {
        // Force these to take place first.
        SDGCalendarInternalTests.testHebrewYear()

        XCTAssertEqual(CalendarDate(hebrew: .iyar, 4, 5751), CalendarDate(gregorian: .april, 17, 1991, at: 18), "Date conversion failed.")
        XCTAssertEqual(CalendarDate(hebrew: .iyar, 4, 5751, at: 6), CalendarDate(gregorian: .april, 18, 1991), "Date conversion failed.")

        XCTAssertEqual(CalendarDate(hebrew: .tevet, 10, 5776, at: 3), CalendarDate(gregorian: .december, 21, 2015, at: 21), "Date conversion failed.")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy‐MM‐dd hh:mm:ss +zzzz"
        XCTAssert(Date(CalendarDate(gregorian: .april, 18, 1991)).timeIntervalSinceReferenceDate ≈ formatter.date(from: "1991‐04‐18 00:00:00 +0000")!.timeIntervalSinceReferenceDate, "CalendarDate does not match Foundation.")

        XCTAssertEqual(CalendarDate(gregorian: .december, 23, 2015).gregorianWeekday, .wednesday, "Weekday failure.")
        XCTAssertEqual(CalendarDate(hebrew: .tevet, 11, 5776).hebrewWeekday, .wednesday, "Weekday failure.")

        XCTAssertNotEqual(GregorianMonth.january, GregorianMonth.december)

        let referenceDate = CalendarDate(gregorian: .january, 1, 2001)
        XCTAssertEqual(referenceDate.gregorianMonth, .january)
        XCTAssertEqual(referenceDate.gregorianDay, 1)
        XCTAssertEqual(referenceDate.gregorianYear, 2001)
        XCTAssertEqual(referenceDate.gregorianHour, 0)
        XCTAssertEqual(referenceDate.gregorianMinute, 0)
        XCTAssertEqual(referenceDate.gregorianSecond, 0)

        let anotherDate = CalendarDate(gregorian: .december, 31, 2015)
        XCTAssertEqual(anotherDate.gregorianMonth, .december)
        XCTAssertEqual(anotherDate.gregorianDay, 31)
        XCTAssertEqual(anotherDate.gregorianYear, 2015)
        XCTAssertEqual(anotherDate.gregorianHour, 0)
        XCTAssertEqual(anotherDate.gregorianMinute, 0)
        XCTAssertEqual(anotherDate.gregorianSecond, 0)

        XCTAssert(CalendarDate.hebrewNow() > CalendarDate(hebrew: .tishrei, 1, 5777))
        XCTAssert(CalendarDate.gregorianNow() > CalendarDate(gregorian: .january, 1, 2017))

        let yetAnotherDate = CalendarDate(gregorian: .july, 5, 2017, at: 18)
        XCTAssertEqual(yetAnotherDate.hebrewYear, 5777)
        XCTAssertEqual(yetAnotherDate.hebrewMonth, .tammuz)
        XCTAssertEqual(yetAnotherDate.hebrewDay, 12)
        XCTAssertEqual(yetAnotherDate.hebrewHour, 0)
        XCTAssertEqual(yetAnotherDate.hebrewPart, 0)

        XCTAssertEqual(yetAnotherDate.dateInISOFormat(), "2017‐07‐05")
        XCTAssertEqual(yetAnotherDate.hebrewDateInBritishEnglish(withWeekday: true), "Thursday, 12 Tammuz 5777")
        XCTAssertEqual(yetAnotherDate.gregorianDateInBritishEnglish(withWeekday: true), "Wednesday, 5 July 2017")
        XCTAssertEqual(yetAnotherDate.hebrewDateInAmericanEnglish(withWeekday: true), "Thursday, Tammuz 12, 5777")
        XCTAssertEqual(yetAnotherDate.gregorianDateInAmericanEnglish(withWeekday: true), "Wednesday, July 5, 2017")

        let time = CalendarDate(gregorian: .july, 6, 2017, at: 2, 05, 06)
        let time2 = CalendarDate(gregorian: .july, 6, 2017, at: 23, 55, 58)
        let time3 = CalendarDate(gregorian: .july, 6, 2017, at: 0, 00, 00)
        XCTAssertEqual(time.timeInISOFormat(includeSeconds: true), "02:05:06")
        XCTAssertEqual(time2.timeInISOFormat(includeSeconds: true), "23:55:58")
        XCTAssertEqual(time3.timeInISOFormat(includeSeconds: true), "00:00:00")

        XCTAssertEqual(time.twentyFourHourTimeInEnglish(), "2:05")
        XCTAssertEqual(time2.twentyFourHourTimeInEnglish(), "23:55")
        XCTAssertEqual(time3.twentyFourHourTimeInEnglish(), "0:00")

        XCTAssertEqual(time.twelveHourTimeInEnglish(), "2:05 a.m.")
        XCTAssertEqual(time2.twelveHourTimeInEnglish(), "11:55 p.m.")
        XCTAssertEqual(time3.twelveHourTimeInEnglish(), "12:00 a.m.")

        XCTAssertEqual(time.iCalendarFormat(), "20170706T020506Z")
        XCTAssertEqual(time2.iCalendarFormat(), "20170706T235558Z")
        XCTAssertEqual(time3.iCalendarFormat(), "20170706T000000Z")

        XCTAssertEqual(time.floatingICalendarFormat(), "20170706T020506")
        XCTAssertEqual(time2.floatingICalendarFormat(), "20170706T235558")
        XCTAssertEqual(time3.floatingICalendarFormat(), "20170706T000000")

        let hebrew = CalendarDate(hebrew: HebrewMonth.tishrei, 23, 3456, at: 7, part: 890)
        testCodableConformance(of: hebrew, uniqueTestName: "Hebrew")
        testCodableConformance(of: CalendarDate(gregorian: .january, 23, 3456, at: 7, 8, 9), uniqueTestName: "Gregorian")
        testCodableConformance(of: CalendarDate(Date(timeIntervalSinceReferenceDate: 123456789)), uniqueTestName: "Foundation")
        testCodableConformance(of: hebrew + (12345 as FloatMax).days, uniqueTestName: "Relative")
        // For unregistered definitions, see DocumentationExampleTests.DateExampleTests.

        struct Mock : Encodable { // swiftlint:disable:this nesting
            let key = "gregoriano"
            let container = "[]"
            let other = [138059393067, 259200]
            func encode(to encoder: Encoder) throws {
                var container = encoder.unkeyedContainer()
                try container.encode(key)
                try container.encode(self.container)
                try container.encode(other)
            }
        }
        testDecoding(CalendarDate.self, failsFor: Mock()) // Empty container array.
    }

    func testCalendarInterval() {
        testMeasurementConformance(of: CalendarInterval<FloatMax>.self)

        XCTAssert((365.days × 400).inGregorianLeapYearCycles < 1)
        XCTAssert(28.days.inHebrewMoons < 1)
    }

    func testGregorianDay() {
        testCodableConformance(of: GregorianDay(12), uniqueTestName: "12")

        var day: GregorianDay = 29
        var month: GregorianMonth = .february
        day.correct(forMonth: &month, year: 2017)
        XCTAssertEqual(day, 1)
        XCTAssertEqual(month, .march)

        day = 31
        month = .november
        day.correct(forMonth: &month, year: 2017)
        XCTAssertEqual(day, 1)
        XCTAssertEqual(month, .december)
    }

    func testGregorianHour() {
        testCodableConformance(of: GregorianHour(12), uniqueTestName: "12")
        testDecoding(GregorianHour.self, failsFor: 600) // Invalid raw value.
    }

    func testGregorianMinute() {
        testCodableConformance(of: GregorianMinute(12), uniqueTestName: "12")
    }

    func testGregorianMonth() {
        testCodableConformance(of: GregorianMonth.january, uniqueTestName: "January")
        testDecoding(GregorianMonth.self, failsFor: 120) // Invalid raw value.

        let length = FloatMax(GregorianMonth.january.numberOfDays(leapYear: false)) × (1 as FloatMax).days
        XCTAssert(length ≥ GregorianMonth.minimumDuration)
        XCTAssert(length ≤ GregorianMonth.maximumDuration)

        for month in GregorianMonth.january ... GregorianMonth.december {
            XCTAssertNotEqual(month.inEnglish(), "")

            if month == .january {
                XCTAssertEqual(month.inEnglish(), "January")
            }
        }

        XCTAssertNil(HebrewMonth.adarII.numberAlreadyElapsed(leapYear: false))
        XCTAssertEqual(HebrewMonth.tishrei.ordinal(leapYear: false), 1)
        XCTAssertNil(HebrewMonth.adarII.ordinal(leapYear: false))
        XCTAssertEqual(HebrewMonth.adar.ordinal(leapYear: false), 6)
        XCTAssertEqual(HebrewMonth.elul.ordinal(leapYear: false), 12)
        XCTAssertEqual(HebrewMonth.tishrei.ordinal(leapYear: true), 1)
        XCTAssertNil(HebrewMonth.adar.ordinal(leapYear: true))
        XCTAssertEqual(HebrewMonth.adarI.ordinal(leapYear: true), 6)
        XCTAssertEqual(HebrewMonth.adarII.ordinal(leapYear: true), 7)
        XCTAssertEqual(HebrewMonth.elul.ordinal(leapYear: true), 13)
    }

    func testGregorianSecond() {
        testCodableConformance(of: GregorianSecond(12), uniqueTestName: "12")

        let second: GregorianSecond = 0.0
        XCTAssertEqual(second, 0)

        XCTAssertEqual(GregorianSecond(0).inDigits(), "00")
    }

    func testGregorianWeekday() {
        testCodableConformance(of: GregorianWeekday.sunday, uniqueTestName: "Sunday")
    }

    func testGregorianYear() {
        testCodableConformance(of: GregorianYear(1234), uniqueTestName: "1234")

        let length = FloatMax(GregorianYear(2017).numberOfDays) × (1 as FloatMax).days
        XCTAssert(length ≥ GregorianYear.minimumDuration)
        XCTAssert(length ≤ GregorianYear.maximumDuration)

        XCTAssertEqual(GregorianYear(ordinal: 1), 1)
        XCTAssertEqual(GregorianYear(2017).numberAlreadyElapsed, 2016)

        XCTAssertEqual(GregorianYear(1).inISOFormat(), "0001")
        XCTAssertEqual(GregorianYear(−1).inISOFormat(), "0000")
        XCTAssertEqual(GregorianYear(−2).inISOFormat(), "−0001")

        XCTAssertEqual(GregorianYear(−1) + 1, GregorianYear(1))
        XCTAssertEqual(GregorianYear(1) − 1, GregorianYear(−1))
        XCTAssertEqual(GregorianYear(−1) − GregorianYear(1), −1)

        XCTAssertEqual(GregorianYear(−1000).inEnglishDigits(), "1000 BC")

        XCTAssertEqual(GregorianYear(numberAlreadyElapsed: 0), 1)
        XCTAssertEqual(GregorianYear(2017).ordinal, 2017)
    }

    func testHebrewDay() {
        testCodableConformance(of: HebrewDay(12), uniqueTestName: "12")

        var day: HebrewDay = 30
        var month: HebrewMonth = .adar
        var year: HebrewYear = 5774
        day.correct(forMonth: &month, year: &year)
        XCTAssertEqual(day, 1)
        XCTAssertEqual(month, .nisan)

        day = 30
        month = .elul
        year = 5777
        day.correct(forMonth: &month, year: &year)
        XCTAssertEqual(day, 1)
        XCTAssertEqual(month, .tishrei)
        XCTAssertEqual(year, 5778)

        XCTAssertEqual(HebrewMonth.nisan.numberAlreadyElapsed(leapYear: true), 7)
        XCTAssertEqual(HebrewMonth.nisan.ordinal(leapYear: false), 7)
        XCTAssertEqual(HebrewMonth.nisan.ordinal(leapYear: true), 8)
    }

    func testHebrewHour() {
        testCodableConformance(of: HebrewHour(12), uniqueTestName: "12")

        XCTAssertEqual(HebrewHour(5).inDigits(), "5")
    }

    func testHebrewMonth() {
        testCodableConformance(of: HebrewMonth.tishrei, uniqueTestName: "Tishrei")
        testCodableConformance(of: HebrewMonth.adar, uniqueTestName: "Adar")
        testCodableConformance(of: HebrewMonth.adarI, uniqueTestName: "Adar I")
        testCodableConformance(of: HebrewMonth.adarII, uniqueTestName: "Adar II")
        testCodableConformance(of: HebrewMonth.elul, uniqueTestName: "Elul")

        let length = FloatMax(HebrewMonth.tishrei.numberOfDays(yearLength: .normal, leapYear: false)) × (1 as FloatMax).days
        XCTAssert(length ≥ HebrewMonth.minimumDuration)
        XCTAssert(length ≤ HebrewMonth.maximumDuration)

        var month: HebrewMonth = .adar
        month.increment(leapYear: false)
        XCTAssertEqual(month, .nisan)
        month.decrement(leapYear: false)
        XCTAssertEqual(month, .adar)

        XCTAssertEqual(HebrewMonth.tishrei.cyclicPredecessor(leapYear: false, {}), .elul)

        month = .adar
        month.correctForYear(leapYear: true)
        XCTAssertEqual(month, .adarII)

        month = .adarII
        month.correctForYear(leapYear: false)
        XCTAssertEqual(month, .adar)

        for month in sequence(first: HebrewMonth.tishrei, next: { $0.successor() }) {
            XCTAssertNotEqual(month.inEnglish(), "")

            if month == .tishrei {
                XCTAssertEqual(month.inEnglish(), "Tishrei")
            } else if month == .adarII {
                XCTAssertEqual(month.inEnglish(), "Adar II")
            }
        }

        XCTAssertEqual(HebrewMonthAndYear(month: .elul, year: 5777).successor().month, .tishrei)
        XCTAssertEqual(HebrewMonthAndYear(month: .tishrei, year: 5777).predecessor().month, .elul)
        XCTAssertEqual(HebrewMonthAndYear(month: .tishrei, year: 5778) − HebrewMonthAndYear(month: .elul, year: 5777), 1)
        XCTAssertEqual(HebrewMonthAndYear(month: .nisan, year: 5777) − HebrewMonthAndYear(month: .sivan, year: 5777), −2)
    }

    func testHebrewMonthAndYear() {
        testCodableConformance(of: HebrewMonthAndYear(month: .tishrei, year: 2345), uniqueTestName: "Tishrei, 2345")
    }

    func testHebrewPart() {
        testCodableConformance(of: HebrewPart(124), uniqueTestName: "124")

        XCTAssertEqual(HebrewPart(102).inDigits(), "102")
    }

    func testHebrewWeekday() {
        testCodableConformance(of: HebrewWeekday.sunday, uniqueTestName: "Sunday")
    }

    func testHebrewYear() {
        testCodableConformance(of: HebrewYear(1234), uniqueTestName: "1234")

        let length = FloatMax(HebrewYear(5777).numberOfDays) × (1 as FloatMax).days
        XCTAssert(length ≥ HebrewYear.minimumDuration)
        XCTAssert(length ≤ HebrewYear.maximumDuration)
    }

    func testWeekday() {
        for weekday in GregorianWeekday.sunday ... GregorianWeekday.saturday {
            XCTAssertNotEqual(weekday.inEnglish(), "")

            if weekday == .sunday {
                XCTAssertEqual(weekday.inEnglish(), "Sunday")
            }
        }
    }

    static var allTests: [(String, (SDGCalendarAPITests) -> () throws -> Void)] {
        return [
            ("testCalendarComponent", testCalendarComponent),
            ("testCalendarDate", testCalendarDate),
            ("testCalendarInterval", testCalendarInterval),
            ("testGregorianDay", testGregorianDay),
            ("testGregorianHour", testGregorianHour),
            ("testGregorianMinute", testGregorianMinute),
            ("testGregorianMonth", testGregorianMonth),
            ("testGregorianSecond", testGregorianSecond),
            ("testGregorianWeekday", testGregorianWeekday),
            ("testGregorianYear", testGregorianYear),
            ("testHebrewDay", testHebrewDay),
            ("testHebrewHour", testHebrewHour),
            ("testHebrewMonth", testHebrewMonth),
            ("testHebrewMonthAndYear", testHebrewMonthAndYear),
            ("testHebrewPart", testHebrewPart),
            ("testHebrewWeekday", testHebrewWeekday),
            ("testHebrewYear", testHebrewYear),
            ("testWeekday", testWeekday)
        ]
    }
}