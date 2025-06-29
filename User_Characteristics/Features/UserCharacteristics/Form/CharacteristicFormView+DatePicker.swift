//
//  CharacteristicFormView+DatePicker.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 29.06.25.
//

import SwiftUI

extension CharacteristicFormView {
    @ViewBuilder
    func datePickerSheet(viewModel: CharacteristicFormVM) -> some View {
        DatePicker(
            "Select Date",
            selection: Binding(
                get: { viewModel.dateValue ?? Date() },
                set: { viewModel.dateValue = $0 }
            ),
            in: DateRange.plusMinus125Years,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .presentationDetents([.medium])
    }
}
