//
//  CreateFolderView.swift
//  LiquidNote
//
//  Created by Yasir on 05/10/25.
//

import SwiftUI
import SwiftData

struct CreateFolderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var folderName: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Folder Name", text: $folderName)
                    .focused($isFocused)
            }
            .navigationTitle("New Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createFolder()
                    }
                    .disabled(folderName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                isFocused = true
            }
        }
    }
    
    private func createFolder() {
        let folder = Folder(name: folderName)
        modelContext.insert(folder)
        dismiss()
    }
}
