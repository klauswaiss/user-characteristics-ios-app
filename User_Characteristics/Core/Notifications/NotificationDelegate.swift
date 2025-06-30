//
//  NotificationDelegate.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    private let coordinator: NavigationCoordinator

    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
        super.init()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound]) // show notification when app is in foreground
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didreceive kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk")
        print("📬 NavigationCoordinator (SET) instance:", ObjectIdentifier(coordinator))
        print("📬 Before setting, selectedCharacteristicID was:", coordinator.selectedCharacteristicID ?? "errroorrrrr 1344" as Any)
        
        let userInfo = response.notification.request.content.userInfo
        if let idString = userInfo["characteristicID"] as? String,
           let uuid = UUID(uuidString: idString) {
            print("✅ Parsed characteristicID:", uuid)
            DispatchQueue.main.async {
                self.coordinator.selectedCharacteristicID = uuid
            }
        } else {
            print("❌ Failed to parse characteristicID")
        }
        completionHandler()
    }
}
