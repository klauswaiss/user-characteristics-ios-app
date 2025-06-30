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
    
    @State private var showAddCharacteristicSheet = false
    
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
                .listRowSeparatorTint(Color("listRowDividerColor"))
            }
            .scrollContentBackground(.hidden)
            .background(Color("customBackgroundColor"))
            .navigationTitle("Characteristics")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddCharacteristicSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                viewModel.setContextIfNeeded(context)
                await CharacteristicSeedService.preloadIfNeeded(context: context)
                await viewModel.loadItems()
                checkNotificationNavigation()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    checkNotificationNavigation()
                }
            }
            .onChange(of: coordinator.selectedCharacteristicID) { _, _ in
                checkNotificationNavigation()
            }
            .sheet(isPresented: $showAddCharacteristicSheet) {
                AddCharacteristicSheet() {
                    Task {
                        await viewModel.loadItems()
                    }
                }
            }
        }
    }
}

// MARK: Private

extension CharacteristicListView {
    private func checkNotificationNavigation() {
        guard let id = coordinator.selectedCharacteristicID else {
            return
        }

        if let match = viewModel.items.first(where: { $0.id == id }) {
            coordinator.selectedItem = match
            coordinator.selectedCharacteristicID = nil
        }
    }
}

// MARK: Preview

#Preview {
    // Inject mock SwiftData ModelContainer into environment
    CharacteristicListView()
        .modelContainer(CharacteristicListPreviewMock.previewContainer())
}
