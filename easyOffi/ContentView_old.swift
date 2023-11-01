//
//  ContentView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 30.08.23.
//
/*
import SwiftUI
import UIKit



struct Line: Shape {
    var from: CGPoint
    var to: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }
}


struct ContentView_old: View {
    @State private var addButtonHidden = false;
    @State private var tilePositions: [Int: CGPoint] = [:]
    
    
    @State private var lineStartPoint: CGPoint?
    @State private var lineEndPoint: CGPoint?
    @State private var currentDraggedTileID: Int?
    @State private var dragStartTile: Tile?
    @State private var dragEndTile: Tile?
    
    @State private var showSheet: Bool = false
    
    // Function to check if a line intersects with a rectangle
    func lineIntersectsTile(lineStart: CGPoint, lineEnd: CGPoint, tileRect: CGRect) -> Bool {
        let minX = min(lineStart.x, lineEnd.x)
        let minY = min(lineStart.y, lineEnd.y)
        let maxX = max(lineStart.x, lineEnd.x)
        let maxY = max(lineStart.y, lineEnd.y)
        
        let lineRect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        
        return lineRect.intersects(tileRect)
    }
    
    // Update tile positions when a tile is added or removed
    private func updateTilePositions() {
        for (index, tile) in tiles.enumerated() {
            let x = CGFloat(index % 2) * 170 + (index % 2 == 0 ? 0 : 36)// Adjust for your tile size and spacing
            let y = CGFloat(index / 2) * 116  //Adjust for your tile size and spacing
            tilePositions[tile.id] = CGPoint(x: x, y: y)
            //print("ID: " + String(tile.id) + " " + String("\(tilePositions[tile.id])"))
        }
    }
    
    private func printTilePoitions(){
        
        for (tileID, tilePosition) in tilePositions {
            var tileStart = "[" + String("\(tilePositions[tileID]!.x)") + ", "+String("\(tilePositions[tileID]!.y)" + "]")
            var tileEnd = "[" + String("\(tilePositions[tileID]!.x + 170)") + ", "+String("\(tilePositions[tileID]!.y + 100)" + "]")
            
            var printing = "The tile " + String(tileID) + " coordinates are: "
            printing += tileStart + " - " + tileEnd
            print(printing)
        }
    }
    
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(tiles) { tile in
                    let isDragging = tile.id == currentDraggedTileID
                    //let tileIndex = tiles.firstIndex { $0.id == tile.id }
                    
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .frame(width: 170)
                        .foregroundColor(Color.black)
                    //.foregroundColor(tile.isDragging ? Color.red : Color.black)
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
                                    tiles = tiles.enumerated().map { (index, tile) in
                                        Tile(id: index + 1, name: tile.name)
                                    }
                                }
                                addButtonHidden = false
                            }) {
                                Text("Remove Tile")
                                Image(systemName: "trash")
                            }
                        }
                        .overlay(
                            Group {
                                if isDragging {
                                    Line(from: CGPoint(x: 170/2, y: 100/2), to: lineEndPoint ?? CGPoint(x: 0, y: 0))
                                        .stroke(Color.red, lineWidth: 5)
                                    //.frame(width: 200, height: 200)
                                    //.zIndex(99)
                                }
                            }
                        )
                    
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    lineEndPoint = value.location
                                    currentDraggedTileID = tile.id
                                    
                                    if lineStartPoint == nil {
                                        lineStartPoint = value.location
                                    }
                                    
                                    
                                }
                                .onEnded { value in
                                    //dragStartTile = tile
                                    lineEndPoint = nil
                                    
                                    
                                    let touchCoordinates = value.location
                                    
                                    print(currentDraggedTileID!)
                                    
                                    let realLocation = CGPointMake(tilePositions[currentDraggedTileID!]!.x + touchCoordinates.x, tilePositions[currentDraggedTileID!]!.y + touchCoordinates.y)
                                    
                                    
                                    print(realLocation)
                                    
                                    //print("Touch Coordinates: \(touchCoordinates)")
                                    //(currentDraggedTileID)
                                    //printTilePoitions()
                                    //let touchCoordinates = CGPoint(x: lineStartPoint!.x + value.location.x, y: lineStartPoint!.y + value.location.y)
                                    //let absoluteTouchCoordinates = tile.geometry.frame(in: .global).origin + touchCoordinates
                                    
                                    
                                    // Check which tile the drag ended in
                                    for (tileID, tilePosition) in tilePositions {
                                        let tileRect = CGRect(origin: tilePosition, size: CGSize(width: 170, height: 100))
                                        if tileRect.contains(realLocation) {
                                            dragStartTile = tiles[currentDraggedTileID!-1]
                                            dragEndTile = tiles[tileID-1]
                                            print("Drag from " + dragStartTile!.name + " to " + dragEndTile!.name)
                                            
                                            self.showSheet = true
                                            
                                            
                                        
                                            break // Exit the loop once you find the tile
                                        }
                                    }
                                    
                                    
                                    //print(dragEndTile)
                                    lineEndPoint = nil
                                    lineStartPoint = nil
                                    currentDraggedTileID = nil
                                    
                                    //print(self.hitTest(value.location, with: nil))
                                    //print(findTile(at: value.location))
                                    
                                }
                            
                        )
                        .zIndex(tile.id == currentDraggedTileID ? 1 : 0)
                    
                    
                    
                }
                .padding(0)
                
                
                
                Button (action: {
                    if(tiles.count < 11){
                        // Add a new tile
                        tiles.append(Tile(id: tiles.count + 1, name: "Tile \(tiles.count + 1)"))
                        updateTilePositions()
                        printTilePoitions()
                        
                    }else{
                        addButtonHidden = true;
                        tiles.append(Tile(id: tiles.count + 1, name: "Tile \(tiles.count + 1)"))
                    }
                    
                }, label: {
                    Text("Station hinzufügen")
                        .frame(height: 100)
                        .frame(width: 170)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, style: StrokeStyle(
                                    lineWidth: 3, dash: [10, 8]
                                )
                                )
                        )
                })
                .opacity(addButtonHidden ? 0 : 1)
                .disabled(addButtonHidden)
                
            }
            .padding()
            
            
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("Background"))
        
        
        .sheet(isPresented: $showSheet, content: {
            ConnectionView(startTile: dragStartTile!,endTile: dragEndTile!)
        })
        
    }
    
}




/*@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}*/


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
