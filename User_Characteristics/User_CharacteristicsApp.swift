//
//  User_CharacteristicsApp.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import SwiftUI

@main
struct User_CharacteristicsApp: App {
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    @State private var notificationDelegate: NotificationDelegate?

    init() {
        NavigationBarConfigurator.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationCoordinator)
                .onAppear {
                    ReminderNotificationService.requestPermissionIfNeeded()
                    if notificationDelegate == nil {
                        let delegate = NotificationDelegate(coordinator: navigationCoordinator)
                        notificationDelegate = delegate
                        UNUserNotificationCenter.current().delegate = delegate
                    }
                }
                .globalTextColor(Color("customTextColor"))
        }
        .modelContainer(PersistenceController.container) // inject SwiftData ModelContainer into environment
    }
}
