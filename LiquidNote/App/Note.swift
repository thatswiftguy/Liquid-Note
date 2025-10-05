//
//  Note.swift
//  LiquidNote
//
//  Created by Yasir on 05/10/25.
//

import Foundation
import SwiftData

@Model
final class Note {
    var id: UUID = UUID()
    var title: String = ""
    var content: String = ""
    var createdAt: Date = Date()
    var modifiedAt: Date = Date()
    var folder: Folder?
    
    init(title: String = "", content: String = "", folder: Folder? = nil) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.modifiedAt = Date()
        self.folder = folder
    }
    
    var summary: String {
        let lines = content.components(separatedBy: .newlines)
        return lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) ?? ""
    }
    
    var displayTitle: String {
        if !title.isEmpty {
            return title
        }
        return summary.isEmpty ? "New Note" : summary
    }
}

@Model
final class Folder {
    var id: UUID = UUID()
    var name: String = ""
    var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \Note.folder)
    var notes: [Note]?
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
    
    var noteCount: Int {
        notes?.count ?? 0
    }
}
