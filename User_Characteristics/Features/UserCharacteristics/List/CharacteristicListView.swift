//
//  CharacteristicListView.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import SwiftUI
import SwiftData

struct CharacteristicListView: View {
    @Environment(\.modelContext) private var context // SwiftData context
    @StateObject private var viewModel = CharacteristicListVM.empty()
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: CharacteristicFormView(model: item)) {
                        CharacteristicRow(item: item)
                    }
                }
                .listRowBackground(Color("rowBackgroundColor"))
            }
            .scrollContentBackground(.hidden)
            .background(Color("customBackgroundColor"))
            .navigationTitle("Characteristics")
            .task {
                print("list view task executing:")
                viewModel.setContextIfNeeded(context)
                await CharacteristicSeedService.preloadIfNeeded(context: context)
                print("viewModel loading items now via viewModel.loadItems()")
                await viewModel.loadItems()
                print("now we call checkNotificationNavigation still inside the list view task")
                checkNotificationNavigation()
            }
            .onChange(of: scenePhase) { _, newPhase in
                print("list view onChange")
                if newPhase == .active {
                    //
                    print("scenePhase changed to .active")
                    checkNotificationNavigation()
                }
            }
            .onChange(of: coordinator.selectedCharacteristicID) { _, _ in
                print("🌀 onChange(selectedCharacteristicID) triggered")
                checkNotificationNavigation()
            }
        }
    }
    
    // MARK: Private
    
    private func checkNotificationNavigation() {
        print("fired checkNotificationNavigation")
        print("🔍 NavigationCoordinator (CHECK) instance:", ObjectIdentifier(coordinator))
        print("📬 Current selectedCharacteristicID:", coordinator.selectedCharacteristicID ?? "error9" as Any)
        print("📦 Current selectedItem:", coordinator.selectedItem?.id ?? "error10" as Any)

        guard let id = coordinator.selectedCharacteristicID else {
            print("❌ selectedCharacteristicID is nil")
            return
        }

        print("🔍 Looking for ID:", id)
        print("📦 viewModel.items contains \(viewModel.items.count) items")
        for item in viewModel.items {
            print("🆔 Item ID:", item.id)
        }

        if let match = viewModel.items.first(where: { $0.id == id }) {
            print("✅ Match found! Presenting sheet for:", match)
            coordinator.selectedItem = match
            print("🧹 Clearing selectedCharacteristicID")
            coordinator.selectedCharacteristicID = nil
        } else {
            print("⏳ No match found yet, will check again after data loads")
            // ❌ Do not clear the ID — will retry after loadItems
        }
    }
}

// MARK: Preview

#Preview {
    // Inject mock SwiftData ModelContainer into environment
    CharacteristicListView()
        .modelContainer(CharacteristicListPreviewMock.previewContainer())
}
