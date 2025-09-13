//
//  NoteView.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI

struct NoteView: View {
    @State private var note: String = ""
    
    var body: some View {
        TextEditor(text: $note)
    }
}
