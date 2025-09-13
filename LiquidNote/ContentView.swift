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
    var body: some View {
        FolderList()
    }
}

#Preview {
    ContentView()
}
