//
//  ContentView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 26.10.23.
//

import SwiftUI
import SwiftData

@Model
class Tile {
    var id: UUID
    var name: String
    var orderNr: Int16
    var station_id: Int
    var isDragging: Bool
    var x: CGFloat
    var y: CGFloat
    
    init(name: String, orderNr: Int16, station_id: Int) {
        self.id = UUID()
        self.name = name
        self.orderNr = orderNr
        self.station_id = station_id
        self.x = 0
        self.y = 0
        self.isDragging = false
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

struct ContentView: View {
    
    @Environment(\.modelContext) public var modelContext
    @Query(sort: \Tile.orderNr) public var tiles:[Tile]
    
    @State var tile = ""
    @State var name = ""
    
    @State private var showAddSheet: Bool = false
    @State public var showConnectionSheet: Bool = false

    
    @State private var tilePositions: [Int: CGPoint] = [:]
    @State private var currentDraggedTile: Tile?
    @State public var lineStartPoint: CGPoint?
    @State public var lineEndPoint: CGPoint?
    @State public var dragStartTile = Tile(name: "Error", orderNr: 0, station_id: 0)
    @State public var dragEndTile =  Tile(name: "Error", orderNr: 0, station_id: 0)
    
    @State public var tileFrames = [CGRect](repeating: .zero, count: 0)
    
    var vGridLayout: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    
    var body: some View {
        ZStack(alignment: .leading) {
            LazyVGrid(columns: vGridLayout) {
                
                ForEach(tiles, id: \.self) { tile in
                    //var isDragging = false
                    /*if(tile.id == currentDraggedTile.id){
                     var isDragging = true
                     }*/
                    //let isDragging = tile.id == currentDraggedTile.id
                    
                    Rect(tile: tile, lineStartPoint: $lineStartPoint, lineEndPoint: $lineEndPoint, dragStartTile: $dragStartTile, dragEndTile: $dragEndTile, showConnectionSheet: $showConnectionSheet)
                        .overlay(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        tile.x = geo.frame(in: .global).origin.x
                                        tile.y = geo.frame(in: .global).origin.y

                                    }
                            }
                            
                        )
                    
                    
                }
                
                //Button to add a new Station
                if(tiles.count < 12){
                    
                    HStack {
                        Button (action: {
                            
                            showAddSheet = true
                            
                            //tileFrames.append(CGRect(x: 0, y: 0, width: 0, height: 0))
                            //let newTile = Tile(name: name, position: 1, station_id: 3565)
                            
                            //modelContext.insert(newTile)
                            //updateTilePositions()
                            //printTilePoitions()
                            
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
                    }
                }
                
            }
            
        }
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .background(Color("Background"))
        
        .sheet(isPresented: $showAddSheet, content: {
            AddView()
        })
        .sheet(isPresented: $showConnectionSheet, content: {
            ConnectionView(startTile: dragStartTile, endTile: dragEndTile)
        })
        
        
    }

}

#Preview{
    ContentView()
}
