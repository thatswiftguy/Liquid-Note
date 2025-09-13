//
//  FolderList.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI

struct FolderList: View {
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Section Title") {
                    ForEach(["", ""], id: \.self) { _ in
                        NavigationLink(value: Screen.createFolder) {
                            Label("folder.name", systemImage: "folder")
                        }
                    }
                }
            }
            .navigationTitle("Folders")
            .searchable(text: $searchText, prompt: "Search Folders")
            .navigationDestination(for: Screen.self) { _ in
                NoteList()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Sdf")
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        print("Sdf")
                    }
                }
            }
        }
    }
}

#Preview {
    FolderList()
}
