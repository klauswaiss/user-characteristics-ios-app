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
        let count = (try? context.fetchCount(FetchDescriptor<Characteristic>())) ?? 0
        guard count == 0 else { return }

        guard let seeds = loadSeedData() else { return }

        seeds.forEach {
            context.insert(Characteristic(name: $0.name, type: $0.type))
        }

        try? context.save()
    }
    
    // MARK: - Private
    
    private static func loadSeedData() -> [CharacteristicSeed]? {
        // todo add error handling for try
        guard let url = Bundle.main.url(forResource: "characteristics", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([CharacteristicSeed].self, from: data) else {
            return nil
        }
        return decoded
    }
}
