//
//  NoteList.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI
import SwiftData

struct NoteList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allNotes: [Note]
    
    let folder: Folder
    
    @State private var selectedNote: Note?
    @State private var searchText: String = ""
    
    init(folder: Folder) {
        self.folder = folder
        let folderId = folder.id
        _allNotes = Query(
            filter: #Predicate<Note> { note in
                note.folder?.id == folderId
            },
            sort: \Note.modifiedAt,
            order: .reverse
        )
    }
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return allNotes
        }
        return allNotes.filter { note in
            note.displayTitle.localizedCaseInsensitiveContains(searchText) ||
            note.content.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var groupedNotes: [(String, [Note])] {
        let calendar = Calendar.current
        let now = Date()
        
        var groups: [String: [Note]] = [:]
        
        for note in filteredNotes {
            let section: String
            if calendar.isDateInToday(note.modifiedAt) {
                section = "Today"
            } else if calendar.isDateInYesterday(note.modifiedAt) {
                section = "Yesterday"
            } else if calendar.isDate(note.modifiedAt, equalTo: now, toGranularity: .weekOfYear) {
                section = "This Week"
            } else if calendar.isDate(note.modifiedAt, equalTo: now, toGranularity: .month) {
                section = "This Month"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM yyyy"
                section = formatter.string(from: note.modifiedAt)
            }
            
            if groups[section] == nil {
                groups[section] = []
            }
            groups[section]?.append(note)
        }
        
        let sectionOrder = ["Today", "Yesterday", "This Week", "This Month"]
        var sorted: [(String, [Note])] = []
        
        for section in sectionOrder {
            if let notes = groups[section] {
                sorted.append((section, notes))
            }
        }
        
        let otherSections = groups.keys
            .filter { !sectionOrder.contains($0) }
            .sorted { first, second in
                guard let firstNote = groups[first]?.first,
                      let secondNote = groups[second]?.first else {
                    return false
                }
                return firstNote.modifiedAt > secondNote.modifiedAt
            }
        
        for section in otherSections {
            if let notes = groups[section] {
                sorted.append((section, notes))
            }
        }
        
        return sorted
    }
    
    var body: some View {
        List {
            if !filteredNotes.isEmpty {
                ForEach(groupedNotes, id: \.0) { section, notes in
                    Section(section) {
                        ForEach(notes) { note in
                            Button {
                                selectedNote = note
                            } label: {
                                NoteRow(note: note)
                            }
                        }
                        .onDelete { offsets in
                            deleteNotes(from: notes, at: offsets)
                        }
                    }
                }
            } else if searchText.isEmpty {
                ContentUnavailableView(
                    "No Notes",
                    systemImage: "note.text",
                    description: Text("Create a note to get started")
                )
            } else {
                ContentUnavailableView.search
            }
        }
        .navigationTitle(folder.name)
        .navigationSubtitle("\(allNotes.count) Notes")
        .navigationDestination(item: $selectedNote) { note in
            NoteView(note: note)
        }
        .searchable(text: $searchText, prompt: "Search notes")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    createNote()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
    }
    
    private func createNote() {
        let note = Note(folder: folder)
        modelContext.insert(note)
        selectedNote = note
    }
    
    private func deleteNotes(from notes: [Note], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(notes[index])
        }
    }
}

struct NoteRow: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.displayTitle)
                .font(.headline)
                .lineLimit(1)
            
            HStack {
                Text(note.modifiedAt, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if !note.summary.isEmpty {
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(note.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
