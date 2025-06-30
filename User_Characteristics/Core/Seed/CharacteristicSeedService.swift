//
//  CharacteristicSeedService.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import Foundation
import SwiftData

enum CharacteristicType: String, Codable {
    case text
    case number
    case date
}

struct CharacteristicSeed: Decodable {
    let name: String
    let type: CharacteristicType
}

struct CharacteristicSeedService {
    @MainActor
    static func preloadIfNeeded(context: ModelContext) async {
        let count: Int
        do {
            count = try context.fetchCount(FetchDescriptor<Characteristic>())
        } catch {
            // NOTE: Consider improving error handling later
            print("Failed to fetch count:", error)
            return
        }
        
        guard count == 0 else { return } // already preloaded before

        guard let seeds = loadSeedData() else { return }

        seeds.forEach {
            context.insert(Characteristic(name: $0.name, type: $0.type))
        }

        do {
            try context.save()
        } catch {
            // NOTE: Consider improving error handling later
            print("Failed to save seeded data:", error)
        }
    }
    
    // MARK: - Private
    
    private static func loadSeedData() -> [CharacteristicSeed]? {
        guard let url = Bundle.main.url(forResource: "characteristics", withExtension: "json") else {
            print("Failed to find characteristics.json in bundle")
            return nil
        }

        // NOTE: Consider improving error handling later (write log etc for 1st/2nd level support)
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([CharacteristicSeed].self, from: data)
            return decoded
        } catch {
            print("Failed to load or decode characteristics.json:", error)
            return nil
        }
    }
}
