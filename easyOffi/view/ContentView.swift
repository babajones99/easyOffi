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
    @State public var dragStartTile = Tile(name: "Error", orderNr: -1, station_id: 0)
    @State public var dragEndTile =  Tile(name: "Error", orderNr: -1, station_id: 0)
    
    @State public var tileFrames = [CGRect](repeating: .zero, count: 0)
    
    var vGridLayout: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .trailing) {
                
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFill() // add if you need
                        .frame(width: 25.0, height: 25.0)
                        .padding()
                }
                /*Button(action: {
                    print("Settings")
                }) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFill() // add if you need
                        .frame(width: 25.0, height: 25.0)
                        .padding()
                }*/
                
                ZStack(alignment: .leading) {
                    LazyVGrid(columns: vGridLayout) {
                        
                        ForEach(tiles, id: \.self) { tile in
                            
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

                                }, label: {
                                    Text("Station hinzufügen")
                                        .frame(height: 100)
                                        .frame(width: 170)
                                        .foregroundColor(Color("Foreground"))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color("Foreground"), style: StrokeStyle(
                                                    lineWidth: 3, dash: [10, 8]
                                                )
                                                )
                                        )
                                })
                            }
                            .padding(10)
                        }
                        
                    }
                    
                }
                .padding(.top)

                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .background(Color("Background"))
                
                .sheet(isPresented: $showAddSheet, content: {
                    AddView()
                })
                .sheet(isPresented: $showConnectionSheet, content: {
                    ConnectionView(startTile: dragStartTile, endTile: dragEndTile)
                        .background(Color("Background4"))

            })
            }
        }
        
        
    }

}

#Preview{
    ContentView()
}
