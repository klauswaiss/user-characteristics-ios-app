//
//  NavigationBarConfigurator.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import SwiftUI

enum NavigationBarConfigurator {
    static func configure() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        // Set custom text color
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(named: "customTextColor") ?? .label
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(named: "customTextColor") ?? .label
        ]

        // Apply appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
