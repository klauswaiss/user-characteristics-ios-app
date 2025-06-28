//
//  CharacteristicListView.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import SwiftUI
import SwiftData

struct CharacteristicListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = CharacteristicListVM.empty()

    @State private var selectedItem: Characteristic?

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: CharacteristicFormView(model: item)) {
                        VStack(alignment: .leading) {
                            Text(item.name).font(.headline)
                            if let value = item.value, !value.isEmpty {
                                Text(displayValue(for: item)).font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Characteristics")
            .sheet(item: $selectedItem) { item in
                CharacteristicFormView(model: item)
            }
            .onAppear {
                viewModel.setContextIfNeeded(context)
                CharacteristicSeedService.preloadIfNeeded(context: context) {
                    viewModel.loadItems()
                }
            }
        }
    }
    
    // MARK: Private
    
    private func displayValue(for item: Characteristic) -> String {
        guard let value = item.value, !value.isEmpty else { return "" }

        switch item.type {
        case .date:
            if let date = IsoFormatter.shared.date(from: value) {
                return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            } else {
                return value
            }
        case .number, .text:
            return value
        }
    }

}
