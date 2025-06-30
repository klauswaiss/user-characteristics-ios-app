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
                Text(viewModel.name)
                    .listRowBackground(Color("rowBackgroundColor"))
                
                if viewModel.type == .date {
                    Button {
                        showDatePickerSheet = true
                    } label: {
                        HStack {
                            Text("Value")
                            Spacer()
                            if let date = viewModel.dateValue {
                                Text(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none))
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "calendar")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .listRowBackground(Color("rowBackgroundColor"))
                } else {
                    ZStack(alignment: .trailing) {
                        TextField("Value", text: $viewModel.valueText)
                            .keyboardType(viewModel.type == .number ? .decimalPad : .default)
                            .autocorrectionDisabled(true)
                            .focused($isValueFocused)
                            .padding(.trailing, 30)
                            .foregroundColor(.white)
                        
                        if !viewModel.valueText.isEmpty {
                            Button(action: {
                                viewModel.value = ""
                                isValueFocused = true
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .listRowBackground(Color("rowBackgroundColor"))
                }
                if let error = viewModel.validationError {
                    Text(error).foregroundColor(.red)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("customBackgroundColor"))
            .navigationTitle("Edit Characteristic")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        handleSave()
                    }
                }
            }
        }
        .onAppear {
            handleOnAppear()
        }
        .sheet(isPresented: $showDatePickerSheet) {
            datePickerSheet(viewModel: viewModel)
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
}

// MARK: - Private

extension CharacteristicFormView {
    private func handleOnAppear() {
        if let model {
            viewModel.populate(from: model)
        }
        if viewModel.type != .date {
            isValueFocused = true
        }
        if viewModel.type == .date && viewModel.dateValue == nil {
            showDatePickerSheet = true
        }
    }
    
    private func handleSave() {
        let reminderWasOff = viewModel.save(to: context, editing: model)
        
        // return and don't dismiss if error happened in validation
        guard viewModel.validationError == nil else { return }
        
        dismissKeyboard()
        
        if reminderWasOff {
            showReminderPrompt = true
        } else {
            dismiss()
        }
    }
}
