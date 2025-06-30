//
//  CharacteristicFormVM.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import Foundation
import SwiftData

@Observable
final class CharacteristicFormVM {
    var name: String = ""
    
    var value: String?
    
    // wrapper for value
    var valueText: String {
        get { value ?? "" }
        set { value = newValue.isEmpty ? nil : newValue }
    }
    
    var type: CharacteristicType = .text
    var reminderEnabled: Bool = false
    
    var validationError: String?
    
    var dateValue: Date? {
        get { value.flatMap { IsoFormatter.shared.date(from: $0) } }
        set { value = newValue.map { IsoFormatter.shared.string(from: $0) } }
    }
}

// MARK: - Public

extension CharacteristicFormVM {
    func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            validationError = "Name is required"
            return false
        }
        
        if type == .number {
            guard let v = value, parseLocaleAwareDouble(from: v) != nil else {
                validationError = "Value must be a valid number"
                return false
            }
        }
        
        validationError = nil
        return true
    }
    
    func toModel() -> Characteristic {
        .init(
            name: name,
            value: value,
            type: type,
            reminderEnabled: reminderEnabled,
            lastUpdated: .now
        )
    }
    
    func populate(from model: Characteristic) {
        name = model.name
        value = model.value
        type = model.type
        reminderEnabled = model.reminderEnabled
    }
    
    func save(to context: ModelContext, editing model: Characteristic?) -> Bool {
        guard validate() else { return false }
        
        let wasReminderDisabled = !reminderEnabled
        let target: Characteristic
        
        if let model {
            model.name = name
            model.value = value
            model.type = type
            model.reminderEnabled = reminderEnabled
            model.lastUpdated = .now
            target = model
        } else {
            let newModel = toModel()
            context.insert(newModel)
            target = newModel
        }
        
        do {
            try context.save()
        } catch {
            // NOTE: Consider implementing UI error handling later
            print("Failed to save context:", error)
        }
        
        if reminderEnabled {
            ReminderNotificationService.scheduleRepeatingNotification(
                id: target.id.uuidString,
                title: target.name,
                body: "Please update \(target.name)",
                interval: 300
            )
        } else {
            ReminderNotificationService.cancelNotification(id: target.id.uuidString)
        }
        
        return wasReminderDisabled
    }
}

// MARK: - Private

extension CharacteristicFormVM {
    private func parseLocaleAwareDouble(from input: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        return formatter.number(from: input)?.doubleValue
    }
}
