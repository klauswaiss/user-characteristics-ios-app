//
//  ValueTextField.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 30.06.25.
//

import SwiftUI

struct ValueTextField: View {
    @Binding var text: String
    var isNumberType: Bool
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Value", text: $text)
                .keyboardType(isNumberType ? .decimalPad : .default)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .padding(.trailing, 30)
                .foregroundColor(.white)

            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused = true
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .listRowBackground(Color("rowBackgroundColor"))
    }
}
