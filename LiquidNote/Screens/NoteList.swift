//
//  NoteList.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI

struct NoteList: View {
    @State private var showNoteView: Bool = false
    @State private var searchText: String = ""
    
    var body: some View {
        List {
            Section("Yesterday") {
                Button {
                    showNoteView = true
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Work")
                        Text("10:304 sdf")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

            }
        }
        .navigationTitle("Notes")
        .navigationSubtitle("35 Notes")
        .navigationDestination(isPresented: $showNoteView) {
            NoteView()
        }
        .searchable(text: $searchText, prompt: "Search")
    }
}

#Preview {
    NoteList()
}
