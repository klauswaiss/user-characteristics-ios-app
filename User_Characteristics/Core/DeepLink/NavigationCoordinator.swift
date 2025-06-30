//
//  NavigationCoordinator.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import Foundation

final class NavigationCoordinator: ObservableObject {
    @Published var selectedCharacteristicID: UUID? = nil {
        didSet {
            if let id = selectedCharacteristicID {
                print("📬 NavigationCoordinator set selectedCharacteristicID:", id)
            } else {
                print("📭 selectedCharacteristicID was cleared (nil)")
            }
        }
    }

    @Published var selectedItem: Characteristic?
}
