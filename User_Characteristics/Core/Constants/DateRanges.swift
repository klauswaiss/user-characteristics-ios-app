//
//  DateRanges.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import Foundation

enum DateRange {
    static let plusMinus125Years: ClosedRange<Date> = {
        let calendar = Calendar.current
        let now = Date()
        let maxDateRangeYrs = 125
        let start = calendar.date(byAdding: .year, value: -maxDateRangeYrs, to: now)!
        let end = calendar.date(byAdding: .year, value: maxDateRangeYrs, to: now)!
        return start...end
    }()
}
