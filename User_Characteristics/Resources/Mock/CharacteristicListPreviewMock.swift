//
//  CharacteristicListPreviewMock.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import SwiftData

@MainActor
enum CharacteristicListPreviewMock {
    static func previewContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Characteristic.self, configurations: config)

        let context = container.mainContext
        context.insert(Characteristic(name: "Birth Date", value: "1995-01-01T00:00:00Z", type: .date))
        context.insert(Characteristic(name: "Eye Test Score", value: "1.5", type: .number))
        context.insert(Characteristic(name: "Driver's License Expiration", value: "2029-12-31T00:00:00Z", type: .date))

        return container
    }
}
