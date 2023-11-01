//
//  easyOffiApp.swift
//  easyOffi
//
//  Created by Jonas Kunze on 30.08.23.
//

import SwiftUI
import SwiftData

@main
struct easyOffiApp: App {
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Tile.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}


