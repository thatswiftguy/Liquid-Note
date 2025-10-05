//
//  LiquidNoteApp.swift
//  LiquidNote
//
//  Created by Yasir on 12/09/25.
//

import SwiftUI
import SwiftData

@main
struct LiquidNoteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
            Folder.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .automatic
        )

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            print("ModelContainer creation failed: \(error)")
            fatalError("Crasshhh it")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
