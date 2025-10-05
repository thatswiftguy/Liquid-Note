//
//  FolderList.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI
import SwiftData

enum Screen: Hashable {
    case createFolder
    case folder(Folder)
}

struct FolderList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Folder.createdAt, order: .reverse) private var folders: [Folder]
    
    @State private var searchText: String = ""
    @State private var showCreateFolder: Bool = false
    @State private var editMode: EditMode = .inactive
    
    var filteredFolders: [Folder] {
        if searchText.isEmpty {
            return folders
        }
        return folders.filter { folder in
            folder.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if !filteredFolders.isEmpty {
                    Section("Folders") {
                        ForEach(filteredFolders) { folder in
                            NavigationLink(value: Screen.folder(folder)) {
                                Label {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(folder.name)
                                            .font(.body)
                                        Text("\(folder.noteCount) notes")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                } icon: {
                                    Image(systemName: "folder.fill")
                                        .foregroundStyle(.blue)
                                }
                            }
                        }
                        .onDelete(perform: deleteFolders)
                    }
                } else if searchText.isEmpty {
                    ContentUnavailableView(
                        "No Folders",
                        systemImage: "folder",
                        description: Text("Create a folder to organize your notes")
                    )
                } else {
                    ContentUnavailableView.search
                }
            }
            .navigationTitle("Folders")
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .folder(let folder):
                    NoteList(folder: folder)
                case .createFolder:
                    Text("Create Folder")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateFolder = true
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .searchable(text: $searchText, prompt: "Search folders")
            .sheet(isPresented: $showCreateFolder) {
                CreateFolderView()
            }
            .environment(\.editMode, $editMode)
        }
    }
    
    private func deleteFolders(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredFolders[index])
        }
    }
}

#Preview {
    FolderList()
        .modelContainer(for: [Folder.self, Note.self], inMemory: true)
}
