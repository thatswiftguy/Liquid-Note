//
//  NoteList.swift
//  LiquidNote
//
//  Created by Yasir on 14/09/25.
//

import SwiftUI

struct NoteList: View {
    var body: some View {
        List {
            Section("Yesterday") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Work")
                    Text("10:304 sdf")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Notes")
        .navigationSubtitle("35 Notes")
    }
}

#Preview {
    NoteList()
}
