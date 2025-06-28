//
//  CharacteristicFormView.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 27.06.25.
//

import SwiftUI

struct CharacteristicFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    var model: Characteristic?
    @State private var viewModel = CharacteristicFormVM()
    @State private var showReminderPrompt = false
    @State private var showDatePickerSheet = false
    
    @FocusState private var isValueFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $viewModel.name)

                if viewModel.type == .date {
                    if let _ = viewModel.dateValue {
                        DatePicker(
                            "Value",
                            selection: Binding(
                                get: { viewModel.dateValue ?? Date() },
                                set: { viewModel.dateValue = $0 }
                            ),
                            in: DateRange.plusMinus125Years,
                            displayedComponents: .date)
                        .datePickerStyle(.compact)
                    } else {
                        Button {
                            showDatePickerSheet = true
                        } label: {
                            HStack {
                                Text("Value")
                                    .foregroundColor(.gray)
                                Spacer()
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                } else {
                    ZStack(alignment: .trailing) {
                        TextField("Value", text: $viewModel.valueText)
                            .keyboardType(viewModel.type == .number ? .decimalPad : .default)
                            .autocorrectionDisabled(true)
                            .focused($isValueFocused)
                            .padding(.trailing, 30)

                        if !viewModel.valueText.isEmpty {
                            Button(action: {
                                viewModel.value = ""
                                isValueFocused = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                if let error = viewModel.validationError {
                    Text(error).foregroundColor(.red)
                }
            }
            .navigationTitle(model == nil ? "Add Characteristic" : "Edit Characteristic")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        handleSave()
                    }
                }
            }
            .onAppear {
                if let model {
                    viewModel.populate(from: model)
                }
            }
        }
        .sheet(isPresented: $showDatePickerSheet) {
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
        .alert("Set Reminder?", isPresented: $showReminderPrompt) {
            Button("Yes") {
                viewModel.reminderEnabled = true
                _ = viewModel.save(to: context, editing: model)
                dismiss()
            }
            Button("No", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Would you like to be reminded to update this periodically?")
        }
    }
    
    // MARK: - Private
    
    private func handleSave() {
        dismissKeyboard()

        let reminderWasOff = viewModel.save(to: context, editing: model)
        if reminderWasOff {
            showReminderPrompt = true
        } else {
            dismiss()
        }
    }
}
