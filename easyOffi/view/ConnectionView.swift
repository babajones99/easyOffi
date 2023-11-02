//
//  ConnectionView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 10.10.23.
//

import SwiftUI

struct ConnectionView: View {
    private var startTile: Tile
    private var endTile: Tile
    
    @State private var hafasResult: Hafas?
    
    @State private var linie: String?
    
    @State private var loading = true
    
    @State private var isError = false
    
    @State private var refreshing = false
    
    @State private var errorMessage: String?
    
    @State private var firstJourney: Journey?
    
    @State private var update: Update?
    
    @State private var updatedAt = Date()
    
    @State private var rotationAngle: Angle = .degrees(0)
    
    
    init(startTile: Tile, endTile: Tile, hafasResult: Hafas? = nil, linie: String? = nil, loading: Bool = true, isError: Bool = false, refreshing: Bool = false, errorMessage: String? = nil, firstJourney: Journey? = nil, update: Update? = nil, updatedAt: Date = Date()) {
        self.startTile = startTile
        self.endTile = endTile
        self.hafasResult = hafasResult
        self.linie = linie
        self.loading = loading
        self.isError = isError
        self.refreshing = refreshing
        self.errorMessage = errorMessage
        self.firstJourney = firstJourney
        self.update = update
        self.updatedAt = updatedAt
    }
    
    
    
    
    var body: some View {
        
        VStack() {
            
            if(!loading && !isError){
                HStack {
                    
                        Spacer()
                    Spacer()
                    Button(action: {
                        refreshing = true
                        Task{
                            await reload()
                        }
                        
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .imageScale(.large)
                            .rotationEffect(refreshing ? rotationAngle : .zero)
                            .onAppear {
                                withAnimation(.bouncy(duration: 1.0)){
                                    rotationAngle = .degrees(360)
                                }
                            }
                        
                        
                    }
                    .cornerRadius(30)
                    .offset(x: -20, y: 20)
                }
                
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
                    Spacer()
                    //Text(Date(timeIntervalSince1970: (update != nil) ? Double(update?.realtimeDataUpdatedAt ?? Int(NSDate().timeIntervalSince1970)) : Double(hafasResult!.realtimeDataUpdatedAt!)).formatted(date: .omitted, time: .standard))
                    Text("Letzte Aktualisierung: " + updatedAt.formatted(date: .omitted, time: .standard))
                        .font(.system(size: 14))
                        .foregroundStyle(Color("Weak"))
                    
                    
                }
                .padding(.top, 20.0)
                
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
    
    func reload() async {
        do{
            hafasResult = try await JourneyCall(startTile: startTile, endTile: endTile).getHafas()
            firstJourney = hafasResult!.journeys[0]
            updatedAt = Date()
            refreshing = false
        }
        catch NetworkError.notFound{
            errorMessage = "Keine Verbindung gefunden"
            isError = true
            refreshing = false
        }
        catch {
            print(error)
            errorMessage = "Unbekannter Fehler"
            isError = true
            refreshing = false
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
    ConnectionView(startTile: Tile(name: "Rheda", orderNr: 1, station_id: 8000315), endTile: Tile(name: "Gütersloh", orderNr: 2, station_id: 923249))
}
