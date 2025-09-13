//
//  ContentView.swift
//  LiquidNote
//
//  Created by Yasir on 12/09/25.
//

import SwiftUI

/*
 Screens
 1. Folders List
 2. Create Folders
 3. Notes List
 4. Create/Edit Note
 5. Search
 */

enum Screen {
    case foldersList
    case createFolder
    case notesList
    case createNote
    case search
}

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var isExpanded: Bool = false
    
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
                Text("New Screen")
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
    ContentView()
}
