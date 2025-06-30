//
//  Characteristic.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import Foundation
import SwiftData

@Model
final class Characteristic {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var value: String?
    var type: CharacteristicType
    
    var reminderEnabled: Bool
    var lastUpdated: Date

    init(name: String, value: String? = nil, type: CharacteristicType, reminderEnabled: Bool = false, lastUpdated: Date = .now) {
        self.name = name
        self.value = value
        self.type = type
        self.reminderEnabled = reminderEnabled
        self.lastUpdated = lastUpdated
    }
}
