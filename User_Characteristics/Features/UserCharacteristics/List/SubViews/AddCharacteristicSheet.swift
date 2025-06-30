//
//  AddCharacteristicSheet.swift
//  User_Characteristics
//
//  Created by Klaus Mac Mini Account on 30.06.25.
//

import SwiftUI
import SwiftData

struct AddCharacteristicSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var name = ""
    @State private var selectedType: CharacteristicType = .text
    @State private var errorMessage: String?
    
    @FocusState private var isTextFieldFocused: Bool
    
    var onSave: () async -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Add Characteristic")
                    .font(.title2)

                TextField("Name", text: $name)
                    .focused($isTextFieldFocused)
                    .padding(12)
                    .background(Color("rowBackgroundColor"))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .foregroundColor(Color("customTextColor"))

                Spacer().frame(height: 4)
                Text("Characteristic type:")
                    .font(.subheadline)
                
                Picker("Type", selection: $selectedType) {
                    ForEach(CharacteristicType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding()
            .background(Color("customBackgroundColor").ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await save()
                        }
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

// MARK: Private

extension AddCharacteristicSheet {
    @MainActor
    private func save() async {
        guard !name.isEmpty else {
            errorMessage = "Name is required"
            return
        }
        let newChar = Characteristic(name: name, type: selectedType)
        context.insert(newChar)
        do {
            try context.save()
            await onSave()
            dismiss()
        } catch {
            errorMessage = "Save failed: \(error.localizedDescription)"
        }
    }
}
