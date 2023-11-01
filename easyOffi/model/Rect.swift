//
//  Rect.swift
//  easyOffi
//
//  Created by Jonas Kunze on 29.10.23.
//

import SwiftUI
import SwiftData

struct Rect: View {
    var tile: Tile
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tile.orderNr) private var tiles:[Tile]
    
    @Binding public var lineStartPoint: CGPoint?
    @Binding public var lineEndPoint: CGPoint?
    @Binding public var dragStartTile: Tile
    @Binding public var dragEndTile: Tile
    @Binding public var showConnectionSheet: Bool

    var body: some View{
        
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 100)
            .frame(width: 170)
            .foregroundColor(Color.black)
        //.foregroundColor(tile.isDragging ? Color.red : Color.black)
            .overlay(
                
                Text(tile.name + " " + String(tile.orderNr))
                    .foregroundColor(.white)
                    .font(.headline)
            )
            .contextMenu {
                Button(role: .destructive, action: {
                    modelContext.delete(tile)
                    for i in 0...tiles.count-1{
                        tiles[i].orderNr = Int16(i)
                    }
                })
                {
                    Text("Station entfernen")
                    Image(systemName: "trash")
                }
            }
            .overlay(
                Group {
                    if tile.isDragging {
                        Line(from: CGPoint(x: 170/2, y: 100/2), to: lineEndPoint ?? CGPoint(x: 0, y: 0))
                            .stroke(Color.red, lineWidth: 5)
                        //.frame(width: 200, height: 200)
                        //.zIndex(99)
                    }
                }
            )
            .gesture(
                DragGesture(minimumDistance: 0.1, coordinateSpace: CoordinateSpace.local)
                    .onChanged { value in
                        
                        
                        lineEndPoint = value.location
                        //Line(from: CGPoint(x: 0, y: 0), to: lineEndPoint ?? CGPoint(x: 0, y: 0))
                        //   .stroke(Color.red, lineWidth: 5)
                        //currentDraggedTile = tile
                        
                        tile.isDragging = true
                        
                        if lineStartPoint == nil {
                            lineStartPoint = value.location
                        }
                        
                        
                    }
                    
                    
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0.0, coordinateSpace: CoordinateSpace.global)
                .onEnded { value in
                    tile.isDragging = false
                    
                    dragStartTile = tile
                    
                    lineEndPoint = value.location
                                    
                    tiles.forEach { tile in
                        let frame = CGRect(x: tile.x, y: tile.y, width: 170, height: 100)
                        
                        if frame.contains(lineEndPoint ?? CGPoint(x: -1, y: -1)){
                            dragEndTile = tile
                        }
                    }
                    
                    //print("Connected \(dragStartTile.name) and \(dragEndTile.name)")
                    showConnectionSheet = true
                    

                    lineStartPoint = nil
                    lineEndPoint = nil
                    
                    //dragStartTile = Tile(name: "Error", orderNr: 0, station_id: 0)
                    //dragEndTile = Tile(name: "Error", orderNr: 0, station_id: 0)
                }
            )

            .zIndex(tile.isDragging ? 1 : 0)
    }
    
    
}


