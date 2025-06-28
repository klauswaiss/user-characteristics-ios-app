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
    
    // MARK: - Public

    func setContextIfNeeded(_ ctx: ModelContext) {
        if context == nil { context = ctx }
    }

    func loadItems() {
        guard let context else { return }
        let descriptor = FetchDescriptor<Characteristic>(sortBy: [SortDescriptor(\.lastUpdated, order: .reverse)])

        DispatchQueue.global(qos: .userInitiated).async {
            let result: [Characteristic]
            do {
                result = try context.fetch(descriptor)
            } catch {
                result = []
            }
            DispatchQueue.main.async {
                self.items = result
            }
        }
    }
}
