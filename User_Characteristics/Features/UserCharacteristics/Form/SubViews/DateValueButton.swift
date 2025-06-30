//
//  DateValueButton.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 30.06.25.
//

import SwiftUI

struct DateValueButton: View {
    let date: Date?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text("Value")
                Spacer()
                if let date {
                    Text(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                }
            }
        }
        .listRowBackground(Color("rowBackgroundColor"))
    }
}
