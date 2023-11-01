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
    
        VStack {
            if(!loading && !isError){
                let tempFirstJourney = firstJourney!
                
                HStack {
                    VStack {
                        Text(tempFirstJourney.legs[0].plannedDeparture, style: .time)
                            .strikethrough()
                        Text(tempFirstJourney.legs[0].departure, style: .time)
                    }
                    
                    Text(startTile.name)
                        .bold()
                        .font(.title)
                }
                Spacer()
                
                Text(tempFirstJourney.legs[0].line.name)
                
                Spacer()
                
                HStack {
                    VStack {
                        Text(tempFirstJourney.legs[tempFirstJourney.legs.count - 1].plannedArrival, style: .time)
                            .strikethrough()
                        Text(tempFirstJourney.legs[tempFirstJourney.legs.count - 1].arrival, style: .time)
                        
                    }
                    
                    Text(endTile.name)
                        .bold()
                        .font(.title)
                }
                
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
        .padding()
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
    
}

#Preview {
    ConnectionView(startTile: Tile(name: "Rheda", orderNr: 1, station_id: 8000315), endTile: Tile(name: "Gütersloh", orderNr: 2, station_id: 8002461))
}
