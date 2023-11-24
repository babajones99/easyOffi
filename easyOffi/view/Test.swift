//
//  Test.swift
//  easyOffi
//
//  Created by Jonas Kunze on 06.11.23.
//

import SwiftUI

struct ListItem: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    
    
    static let preview: [ListItem] = [
        ListItem(title: "Row 1", color: Color.red),
        ListItem(title: "Row 2", color: Color.blue),
        ListItem(title: "Row 3", color: Color.green),
        ListItem(title: "Row 4", color: Color.orange),
        ListItem(title: "Row 5", color: Color.pink)
    ]
}

struct ContentViewTest: View {
    private var startTile: Tile
    private var endTile: Tile
    
    @State private var hafasResult: Hafas?
    
    @State private var linie: String?
    
    @State private var loading = true
    
    @State private var isError = false
    
    @State private var refreshing = false
    
    @State private var errorMessage: String?
    
    @State private var firstJourney: Journey?
    
    @State private var mainJourneyNr = 0
    
    @State private var update: Update?
    
    @State private var updatedAt = Date()
    
    @State private var rotationAngle: Angle = .degrees(0)
    
    @State private var transition = false
    
    @State private var scrollID: Int?
    
    
    
    @Namespace private var journeyNS
    
    
    
    init(startTile: Tile, endTile: Tile, hafasResult: Hafas? = nil, linie: String? = nil, loading: Bool = true, isError: Bool = false, refreshing: Bool = false, errorMessage: String? = nil, firstJourney: Journey? = nil, mainJourneyNr: Int = 0, update: Update? = nil, updatedAt: Date = Date()) {
        self.startTile = startTile
        self.endTile = endTile
        self.hafasResult = hafasResult
        self.linie = linie
        self.loading = loading
        self.isError = isError
        self.refreshing = refreshing
        self.errorMessage = errorMessage
        self.firstJourney = firstJourney
        self.mainJourneyNr = mainJourneyNr
        self.update = update
        self.updatedAt = updatedAt
    }
    
    
    var body: some View {
        
        
        /*ScrollView{
         ForEach(ListItem.preview) { item in
         item.color
         .frame(height: 300)
         .overlay {
         Text(item.title)
         }
         .cornerRadius(16)
         .padding(.horizontal)
         .scrollTransition { effect, phase in
         effect
         .scaleEffect(phase.isIdentity ? 1 : 0.8)
         }
         }
         }*/
        
        VStack {
            if(!loading && !isError){
                ScrollView {
                    
                    ForEach(hafasResult!.journeys) { journey in
                        var collapsed = journey.collapsed
                        JourneyView(collapsed: collapsed, journey: journey)
                            .matchedGeometryEffect(id: journey.id,
                                                   in: journeyNS,
                                                   properties: .position)
                            .scrollTargetLayout()
                            .scrollTransition { effect, phase in
                                effect
                                    .scaleEffect(phase.isIdentity ? 1 : 0.6)
                                
                            }
                            .onAppear {
                                collapsed = false
                            }
                            .onDisappear {
                                collapsed = true
                            }
                    }
                }
                //.contentMargins(.vertical, 50, for: .scrollContent)
                .scrollTargetBehavior(.paging)
                .simultaneousGesture(
                    DragGesture().onChanged({
                        
                        
                        
                        withAnimation{
                            hafasResult!.journeys[mainJourneyNr].collapsed = true
                        }
                        if($0.translation.height < 0){
                            if(mainJourneyNr < hafasResult!.journeys.count - 1) { mainJourneyNr += 1 }
                            
                        } else {
                            if(mainJourneyNr > 0) { mainJourneyNr -= 1 }
                        }
                        withAnimation{
                            hafasResult!.journeys[mainJourneyNr].collapsed = false
                        }
                        
                        let isScrollDown = 0 < $0.translation.height
                    }))
            }
        }
        .task {
            do{
                hafasResult = try await JourneyCall(startTile: startTile, endTile: endTile).getHafas()
                
                hafasResult!.journeys.forEach(){journey in
                    if(journey.legs[0].departure < Date()){
                        mainJourneyNr += 1
                    }
                }
                firstJourney = hafasResult!.journeys[mainJourneyNr]
                hafasResult!.journeys[mainJourneyNr].collapsed = false
                loading = false
                
            }
            catch NetworkError.notFound{
                errorMessage = "Keine Verbindung gefunden"
                isError = true
                loading = false
            }
            catch {
                print(error)
                errorMessage = "Unbekannter Fehler"
                isError = true
                loading = false
            }
        }
        
    }
    
    
}


#Preview {
    ContentViewTest(startTile: Tile(name: "Rheda", orderNr: 1, station_id: 8000315), endTile: Tile(name: "Gütersloh", orderNr: 2, station_id: 923249))
}
