//
//  SummaryView.swift
//  LiquidNote
//
//  Created by Yasir on 05/10/25.
//

import SwiftUI

struct SummaryView: View {
    @Environment(\.dismiss) private var dismiss
    let summary: String
    let originalContent: String
    let errorMessage: String?
    
    @State private var copiedToClipboard: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let error = errorMessage {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.orange)
                            
                            Text("Unable to Generate Summary")
                                .font(.headline)
                            
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Text("Make sure Apple Intelligence is enabled on your device.")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("AI Summary", systemImage: "sparkles")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            Text(summary)
                                .font(.body)
                                .textSelection(.enabled)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Original Content")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            
                            Text(originalContent)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .textSelection(.enabled)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Note Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                if errorMessage == nil {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            UIPasteboard.general.string = summary
                            copiedToClipboard = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                copiedToClipboard = false
                            }
                        } label: {
                            Label(copiedToClipboard ? "Copied!" : "Copy",
                                  systemImage: copiedToClipboard ? "checkmark" : "doc.on.doc")
                        }
                    }
                }
            }
        }
    }
}
