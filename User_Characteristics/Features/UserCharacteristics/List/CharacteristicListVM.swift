//
//  CharacteristicListVM.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import Foundation
import SwiftData

final class CharacteristicListVM: ObservableObject {
    @Published var items: [Characteristic] = []
    private var context: ModelContext?
    
    static func empty() -> CharacteristicListVM {
        .init(context: nil)
    }
    
    init(context: ModelContext?) {
        self.context = context
    }
}

// MARK: - Public

extension CharacteristicListVM {
    func setContextIfNeeded(_ ctx: ModelContext) {
        if context == nil { context = ctx }
    }

    @MainActor
    func loadItems() async {
        guard let context else { return }

        let descriptor = FetchDescriptor<Characteristic>(
            sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)]
        )

        do {
            self.items = try context.fetch(descriptor)
        } catch {
            // NOTE: Improve error handling later, consider showing user-friendly error message
            print("Fetch failed:", error)
            self.items = []
        }
    }
}
