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
            if let value = item.value, !value.isEmpty {
                Text(displayValue(for: item)).font(.subheadline)
            }
        }
    }

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
