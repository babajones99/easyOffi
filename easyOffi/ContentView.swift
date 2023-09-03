//
//  ContentView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 30.08.23.
//

import SwiftUI
import UIKit

struct Tile: Identifiable {
    let id: Int
    let name: String
    
    
    @State public var isDragging = false
    @State public var tileCenter: CGPoint? = nil

    
}

class LineView: UIView {
    
    var startPoint: CGPoint = CGPoint.zero
    var endPoint: CGPoint = CGPoint.zero
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            // Set line color and width
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2.0)
            
            // Move to the starting point
            context.move(to: startPoint)
            
            // Add a line to the ending point
            context.addLine(to: endPoint)
            
            // Draw the line
            context.strokePath()
        }
    }
}

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


struct LineViewWrapper: UIViewRepresentable {
    var startPoint: CGPoint
    var endPoint: CGPoint
    
    func makeUIView(context: Context) -> LineView {
        let lineView = LineView()
        lineView.backgroundColor = .clear // Make the background clear
        return lineView
    }
    
    func updateUIView(_ uiView: LineView, context: Context) {
        // Update the start and end points of the line
        uiView.startPoint = startPoint
        uiView.endPoint = endPoint
        uiView.setNeedsDisplay() // Trigger a redraw of the line
    }
}
struct ContentView: View {
    @State private var addButtonHidden = false;
    @State private var tiles: [Tile] = [
        Tile(id: 1, name: "Tile 1"),
        Tile(id: 2, name: "Tile 2"),
        Tile(id: 3, name: "Tile 3"),
        // Add more tiles as needed
    ]
    @State private var lineStartPoint: CGPoint?
    @State private var lineEndPoint: CGPoint?
    @State private var currentDraggedTile: Tile?
    @State private var currentDraggedTileID: Int?
    
    
    var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // Create a LineView instance
    let lineView = LineView()
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(tiles) { tile in
                    let isDragging = tile.id == currentDraggedTile?.id
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 100)
                        .frame(width: 170)
                    //.foregroundColor(Color.blue)
                        .foregroundColor(tile.isDragging ? Color.red : Color.black)
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
                                        .stroke(Color.red, lineWidth: 3)
                                        //.frame(width: 200, height: 200)
                                        //.zIndex(99)
                                }
                            }
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    print(tile)
                                    self.currentDraggedTile = tile
                                    //lineStartPoint = CGPoint(x: 170 / 2, y: 100 / 2)
                                    lineEndPoint = value.location
                                    self.currentDraggedTileID = tile.id
                                }
                                .onEnded { _ in
                                    self.currentDraggedTile = nil
                                    lineEndPoint = nil
                                    lineStartPoint = nil
                                    self.currentDraggedTileID = nil
                                    
                                }
                        )
                        /*.onAppear {
                               let tileCenter = CGPoint(x: 170 / 2, y: 100 / 2) // Calculate the center of the tile
                               tile.tileCenter = tileCenter // Update the tile's center point
                            //lineStartPoint = tile.tileCenter // Set the line start point initially
                        }*/
                        .zIndex(tile.id == currentDraggedTileID ? 1 : 0)
                    
                    
                
                    
                    
                    
                    
                    
                }
                .padding(0)
                
                
 
                Button (action: {
                    if(tiles.count < 11){
                        // Add a new tile
                        tiles.append(Tile(id: tiles.count + 1, name: "Tile \(tiles.count + 1)"))
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
