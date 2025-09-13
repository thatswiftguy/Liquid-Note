//
//  NoteView.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI

struct NoteView: View {
    @State private var note: String = ""
    @FocusState private var isNoteFocused: Bool
    
    var body: some View {
        TextEditor(text: $note)
            .focused($isNoteFocused)
            .onAppear {
                note.isEmpty ? isNoteFocused.toggle() : ()
            }
    }
}
