//
//  CharacteristicRow.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import SwiftUI

struct CharacteristicRow: View {
    let item: Characteristic
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name).font(.headline)
            Spacer().frame(height: 4)
            if let value = item.value, !value.isEmpty {
                HStack {
                    CheckmarkIcon()
                    Text(displayValue(for: item)).font(.subheadline)
                }
            } else {
                Text("Please enter a value")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
            }
        }
    }
}

// MARK: Private

extension CharacteristicRow {
    private func displayValue(for item: Characteristic) -> String {
        guard let value = item.value, !value.isEmpty else { return "" }

        switch item.type {
        case .date:
            if let date = IsoFormatter.shared.date(from: value) {
                return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
            } else {
                return value
            }
        case .number, .text:
            return value
        }
    }
}
