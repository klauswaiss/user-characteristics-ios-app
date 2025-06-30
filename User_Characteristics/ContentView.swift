//
//  ContentView.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 30.06.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator

    var body: some View {
        CharacteristicListView()
            .sheet(item: $coordinator.selectedItem) { item in
                CharacteristicFormView(model: item)
            }
            .accentColor(Color("customTextColor"))
    }
}
