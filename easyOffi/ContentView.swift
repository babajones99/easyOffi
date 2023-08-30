//
//  ContentView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 30.08.23.
//

import SwiftUI
/*
 
 struct ContentView: View {
 @Environment(\.colorScheme) var currentMode
 @State private var tiles: [Int] = Array(1...10)
 let columns = [
 GridItem(.flexible(), spacing: 16),
 GridItem(.flexible(), spacing: 16)
 ]
 
 var body: some View {
 VStack {
 ScrollView {
 LazyVGrid(columns: columns, spacing: 16) {
 ForEach(tiles, id: \.self) { tile in
 RoundedRectangle(cornerRadius: 10)
 .frame(height: 100)
 .foregroundColor(Color.primary)
 .overlay(
 Text("Tile \(tile + 1)")
 .foregroundColor(currentMode == .dark ? Color.green : Color.accentColor)
 .font(.headline)
 )
 .contextMenu {
 Button(action: {
 // Handle the context menu action for this tile
 print("Action for Tile \(tile + 1)")
 }) {
 Text("Name ändern")
 Image(systemName: "character.cursor.ibeam")
 }
 
 Button(action: {
 // Handle the context menu action for this tile
 print("Action for Tile \(tile + 1)")
 }) {
 Text("Station ändern")
 Image(systemName: "square.and.pencil")
 }
 
 Button(action: {
 // Handle the context menu action for this tile
 print("Action for Tile \(tile + 1)")
 // Remove the specific tile from the array
 if let index = tiles.firstIndex(of: tile) {
 tiles.remove(at: index)
 }
 
 }) {
 Text("Station entfernen")
 .foregroundColor(Color.red)
 Image(systemName: "trash")
 }
 }
 }
 }
 .padding()
 }
 
 HStack {
 Button(action: {
 if tiles.count < 12 { // Limit the maximum number of tiles to 20
 tiles.append(tiles.count + 1)
 }
 }) {
 Text("Station hinzufügen")
 }
 .padding()
 
 }
 }
 }
 }
 
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView()
 }
 }
 
 */

struct Tile: Identifiable {
    let id: Int
    let name: String
}

struct ContentView: View {
    @State private var tiles: [Tile] = [
        Tile(id: 1, name: "Tile 1"),
        Tile(id: 2, name: "Tile 2"),
        Tile(id: 3, name: "Tile 3"),
        // Add more tiles as needed
    ]
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(tiles) { tile in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .foregroundColor(Color.blue)
                        .overlay(
                            Text("\(tile.name) ID:\(tile.id)")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .contextMenu {
                            Button(action: {

                            }) {
                                Text("Edit Name")
                                Image(systemName: "pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
                                    tiles.remove(at: index)
                                    self.tiles = self.tiles.enumerated().map { (index, tile) in
                                        Tile(id: index + 1, name: tile.name)
                                    }
                                }
                            }) {
                                Text("Remove Tile")
                                Image(systemName: "trash")
                            }
                        }
                    
                }
            }
            .padding()
            
            // Button to add a new tile
            HStack {
                Spacer()
                Button(action: {
                    if(tiles.count < 12){
                        // Add a new tile
                        tiles.append(Tile(id: tiles.count + 1, name: "Tile \(tiles.count + 1)"))
                    }
                }) {
                    Text("Add Tile")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
            }
            .padding()
            
        }
    }
    
}


@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
