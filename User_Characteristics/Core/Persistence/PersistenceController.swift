//
//  PersistenceController.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import SwiftData

enum PersistenceController {
    static let container: ModelContainer = {
        let schema = Schema([Characteristic.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()
}
