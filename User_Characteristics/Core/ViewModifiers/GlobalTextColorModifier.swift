//
//  GlobalTextColorModifier.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import SwiftUI

struct GlobalTextColor: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
    }
}

extension View {
    func globalTextColor(_ color: Color) -> some View {
        self.modifier(GlobalTextColor(color: color))
    }
}
