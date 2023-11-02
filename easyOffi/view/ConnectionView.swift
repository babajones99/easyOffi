//
//  ConnectionView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 10.10.23.
//

import SwiftUI

struct ConnectionView: View {
    var startTile: Tile
    var endTile: Tile
    
    @State var hafasResult: Hafas?
    
    @State var linie: String?
    
    @State var loading = true
    
    @State var isError = false
    
    @State var errorMessage: String?
    
    @State var firstJourney: Journey?
    
    
    
    var body: some View {
        
        VStack() {
            if(!loading && !isError){
                let tempFirstJourneyLegs = firstJourney!.legs
                VStack(alignment: .leading, spacing: 10.0) {
                    ForEach(tempFirstJourneyLegs, id: \.customId) { leg in
                        let isFirst = leg.customId == tempFirstJourneyLegs[0].customId
                        let isLast = leg.customId == tempFirstJourneyLegs[tempFirstJourneyLegs.count - 1].customId
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.blue)
                            
                            VStack {
                                Text(leg.plannedDeparture, style: .time)
                                    .strikethrough()
                                    .font(.system(size: 14))
                                Text(leg.departure, style: .time)
                                    .font(.system(size: 16))
                            }
                            
                            Text(leg.origin.name)
                                .font(isFirst ? Font.title.weight(.bold) : Font.body)
                        }
                        
                        
                        
                        HStack {
                            VerticalLine()
                                .stroke(Color.blue, lineWidth: 4)
                                .frame(width: 10, height: 80)
                            Text(leg.line?.name ?? "Gehen")
                        }
                        
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.blue)
                            
                            VStack {
                                Text(leg.plannedArrival, style: .time)
                                    .strikethrough()
                                    .font(.system(size: 14))
                                Text(leg.arrival, style: .time)
                                    .font(.system(size: 16))
                            }
                            Text(leg.destination.name)
                                .font(isLast ? Font.title.weight(.bold) : Font.body)
                            
                        }
                        
                        
                    }
                    
                }
                .padding(.top, 40.0)
                
                Spacer()
            }
            if(!loading && isError){
                Text(errorMessage ?? "Unbekannter Fehler")
            }
            
        }
        .overlay(
            Group{
                if loading{
                    ProgressView().controlSize(.large)
                }
            }
        )
        .padding(.leading)
        .task {
            do{
                hafasResult = try await JourneyCall(startTile: startTile, endTile: endTile).getHafas()
                firstJourney = hafasResult!.journeys[0]
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
    
    struct VerticalLine: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.minY - 10))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY + 10))
            return path
        }
    }
    
}

#Preview {
    ConnectionView(startTile: Tile(name: "Rheda", orderNr: 1, station_id: 8000315), endTile: Tile(name: "Gütersloh", orderNr: 2, station_id: 8002461))
}
