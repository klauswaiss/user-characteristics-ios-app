//
//  IsoFormatter.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 28.06.25.
//

import Foundation

enum IsoFormatter {
    static let shared: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
