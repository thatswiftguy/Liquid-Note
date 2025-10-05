//
//  NoteView.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var note: Note
    
    @FocusState private var isNoteFocused: Bool
    @State private var showSummary: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TextEditor(text: $note.content)
                .focused($isNoteFocused)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 4)
                .onChange(of: note.content) { _, _ in
                    note.modifiedAt = Date()
                    updateTitle()
                }
        }
        .navigationTitle(note.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if note.content.isEmpty {
                isNoteFocused = true
            }
        }
    }
    
    private func updateTitle() {
        let lines = note.content.components(separatedBy: .newlines)
        if let firstLine = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) {
            note.title = String(firstLine.prefix(100))
        }
    }
}
