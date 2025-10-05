//
//  NoteView.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI
import FoundationModels

struct NoteView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var note: Note
    
    @FocusState private var isNoteFocused: Bool
    @State private var showSummary: Bool = false
    @State private var summary: String = ""
    @State private var isGeneratingSummary: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: .zero) {
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    generateAISummary()
                } label: {
                    if isGeneratingSummary {
                        ProgressView()
                    } else {
                        Label("Summarize", systemImage: "sparkles")
                    }
                }
                .disabled(note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isGeneratingSummary)
            }
        }
        .sheet(isPresented: $showSummary) {
            SummaryView(summary: summary, originalContent: note.content, errorMessage: errorMessage)
        }
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
    
    private func generateAISummary() {
        isGeneratingSummary = true
        errorMessage = nil

        Task {
            // Check model availability before attempting to summarize
            let model = SystemLanguageModel.default
            if case .unavailable(let reason) = model.availability {
                await MainActor.run {
                    self.errorMessage = "Apple Intelligence model unavailable: \(reason)"
                    self.summary = ""
                    self.isGeneratingSummary = false
                    self.showSummary = true
                }
                return
            }

            do {
                // Use Foundation Models' LanguageModelSession to generate a summary
                let instructions = """
                You are a helpful writing assistant. Summarize the provided note into a single concise paragraph of medium length (about 5–7 sentences). Keep the tone neutral and informative. Do not add new facts.
                """

                let session = LanguageModelSession(instructions: instructions)

                let prompt = """
                Note text:
                \"\"\"
                \(note.content)
                \"\"\"
                Provide the summary paragraph now.
                """

                let response = try await session.respond(to: prompt)

                await MainActor.run {
                    self.summary = response.content
                    self.isGeneratingSummary = false
                    self.showSummary = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.summary = ""
                    self.isGeneratingSummary = false
                    self.showSummary = true
                }
            }
        }
    }
}
