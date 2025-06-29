//
//  User_CharacteristicsApp.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import SwiftUI

@main
struct User_CharacteristicsApp: App {
    init() {
        NavigationBarConfigurator.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            CharacteristicListView()
                .task {
                    ReminderNotificationService.requestPermissionIfNeeded()
                }
                .globalTextColor(Color("customTextColor"))
        }
        .modelContainer(PersistenceController.container)
    }
}
