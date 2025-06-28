//
//  KeyboardUtils.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 28.06.25.
//

import SwiftUI

func dismissKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
    )
}
