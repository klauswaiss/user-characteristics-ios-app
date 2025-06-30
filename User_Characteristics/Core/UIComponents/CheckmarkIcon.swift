//
//  CheckmarkIcon.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 30.06.25.
//

import SwiftUI

struct CheckmarkIcon: View {
    private let iconSize: CGFloat = 14
    
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: iconSize))
            .foregroundColor(.green)
            .background(
                Circle()
                    .fill(Color.white)
                    .frame(width: iconSize, height: iconSize)
            )
    }
}
