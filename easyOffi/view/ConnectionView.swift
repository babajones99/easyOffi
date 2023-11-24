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
    
    @State private var mainJourneyNr = 0
    
    @State private var mainJourneyId = UUID()
    
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
        
        VStack() {

            
            if(!loading && !isError){
                Image(systemName: "chevron.compact.down")
                    .imageScale(.large)
                    .padding()
                
                HStack {
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
                
                ZStack {
                    

                        /*Rectangle()
                            .fill(Color("Background2"))
                            .frame(width: .infinity, height: 400)*/

                    
                    VStack(alignment: .leading, spacing: 10.0) {
                        /*ScrollViewReader{ scrollViewProxy in
                            ScrollView{
                                VStack {
                                    ForEach(hafasResult!.journeys, id: \.refreshToken) { tempJourney in
                                        if(tempJourney.refreshToken == firstJourney!.refreshToken)
                                        {
                                            mainJourney(varJourney: tempJourney)
                                                .padding(.top, 25)
                                                .padding(.bottom, 25)
                                                .padding(.leading, 20)
                                            //.background(Color("Background2"))
                                            
                                            
                                        } else {
                                            collapsedJourney(varJourney: tempJourney)
                                                .padding(.leading, 8)
                                                .padding(.trailing, 8)
                                                .frame(minHeight: 50)
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollTargetBehavior(.paging)
                        }*/
                        
                        
                        
                        /*--------------------------
                        ScrollView {
                             ScrollViewReader { scrollViewProxy in
                                 VStack(spacing: 10) {
                                     ForEach(hafasResult!.journeys.indices, id: \.self) { index in
                                         if index == mainJourneyNr {
                                             mainJourney(varJourney: hafasResult!.journeys[index])
                                                 .id(index)
                                                 .padding(.top, 25)
                                                 .padding(.bottom, 25)
                                                 .padding(.leading, 20)
                                                 //.frame(height: 100) // Adjust the height as needed
                                         } else {
                                             collapsedJourney(varJourney: hafasResult!.journeys[index])
                                                 .id(index)
                                                 .padding(.leading, 8)
                                                 .padding(.trailing, 8)
                                                 .frame(minHeight: 50)
                                                 //.frame(height: 50) // Adjust the height as needed
                                         }
                                     }
                                 }
                                 /*.onChange(of: mainJourneyNr) { newIndex in
                                     withAnimation {
                                         scrollViewProxy.scrollTo(newIndex, anchor: .top)
                                     }
                                 }*/
                             }
                         }
                         .scrollTargetBehavior(.viewAligned)
                         .gesture(DragGesture().onChanged { value in
                             let offset = value.translation.height
                             let currentIndex = mainJourneyNr
                             let newIndex = offset > 0 ? currentIndex - 1 : currentIndex + 1
                             mainJourneyNr = max(0, min(newIndex, hafasResult!.journeys.count - 1))})
                             

                        //--------------------------*/
                        Spacer()
                        
                        /*ScrollView {
                            ScrollViewReader { scrollView in
                                VStack {
                                    ForEach(0..<hafasResult!.journeys.count) { i in
                                        
                                        if(hafasResult!.journeys[i].collapsed){
                                            collapsedJourney(varJourney: hafasResult!.journeys[i], journeyNS: journeyNS)
                                                .matchedGeometryEffect(id: hafasResult!.journeys[i].refreshToken,
                                                                       in: journeyNS,
                                                                       properties: .position)
                                                .onTapGesture {
                                                    withAnimation{
                                                        hafasResult!.journeys[mainJourneyNr].collapsed.toggle()
                                                        hafasResult!.journeys[i].collapsed.toggle()
                                                        mainJourneyNr = i
                                                    }
                                                }
                                                .id(i)

                                        }else{
                                            mainJourney(varJourney: hafasResult!.journeys[i], journeyNS: journeyNS)
                                                .matchedGeometryEffect(id: transition ? hafasResult!.journeys[i].refreshToken : "",
                                                                       in: journeyNS,
                                                                       properties: .frame)
                                                .onTapGesture {
                                                    withAnimation{
                                                        hafasResult!.journeys[mainJourneyNr].collapsed.toggle()
                                                        hafasResult!.journeys[i].collapsed.toggle()
                                                        mainJourneyNr = i                                                    }
                                                }
                                                .id(i)
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                                .onChange(of: scrollID) { newValue in
                                    // Use newValue to determine the scroll position and update mainJourneyNr accordingly
                                    // Calculate the index of the mainJourney based on the scroll position
                                    print(scrollID)
                                    let newIndex = 0// You may need to handle nil here
                                    mainJourneyNr = newIndex
                                }
                                .onChange(of: mainJourneyNr) { _ in
                                    // Scroll to the corresponding position when mainJourneyNr is updated
                                    withAnimation {
                                        scrollView.scrollTo(mainJourneyNr)
                                    }
                                }
                            }
                        }
                        .scrollPosition(id: $scrollID)
                        .onChange(of: scrollID) { oldValue, newValue in
                            print(newValue ?? "")
                        }*/
                        
                        
                        ScrollView {
                            VStack {
                                ForEach(Array(hafasResult!.journeys.enumerated()), id: \.offset) { index, journey in
                                    JourneyView(collapsed: journey.collapsed, journey: journey)
                                        .matchedGeometryEffect(id: journey.id,
                                                               in: journeyNS,
                                                               properties: .position)
                                        .scrollTargetLayout()
                                        /*.scrollTransition { effect, phase in
                                            effect
                                                .scaleEffect(phase.isIdentity ? 1 : 0.2)
                                            
                                        }*/
                                        .onTapGesture {
                                            withAnimation {
                                                if(journey.collapsed){
                                                    hafasResult!.journeys[mainJourneyNr].collapsed = true
                                                    hafasResult!.journeys[index].collapsed = false
                                                    mainJourneyNr = index
                                                }
                                            }
                                            
                                        }
                                }
                            }
                            .scrollTargetLayout()
                            
                        }
                        //.contentMargins(.vertical, 50, for: .scrollContent)
                        .scrollTargetBehavior(.paging)
                      
                        
                        Spacer()
                        //Text(Date(timeIntervalSince1970: (update != nil) ? Double(update?.realtimeDataUpdatedAt ?? Int(NSDate().timeIntervalSince1970)) : Double(hafasResult!.realtimeDataUpdatedAt!)).formatted(date: .omitted, time: .standard))
                        Text("Letzte Aktualisierung: " + updatedAt.formatted(date: .omitted, time: .standard))
                            .font(.system(size: 14))
                            .foregroundStyle(Color("Weaker"))
                            .padding(.leading)
                        
                        
                    }
                    .padding(.top, 30)
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
        .task {
            do{
                hafasResult = try await JourneyCall(startTile: startTile, endTile: endTile).getHafas()
                
                hafasResult!.journeys.forEach(){journey in
                    if(journey.legs[0].departure < Date()){
                        mainJourneyNr += 1
                        mainJourneyId = journey.customId
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
    
    
    func reload() async {
        do{
            hafasResult = try await JourneyCall(startTile: startTile, endTile: endTile).getHafas()
            mainJourneyNr = 0
            hafasResult!.journeys.forEach(){journey in
            
                if(journey.legs[0].departure < Date()){
                    mainJourneyNr += 1
                    mainJourneyId = journey.customId
                }
            }
            firstJourney = hafasResult!.journeys[mainJourneyNr]
            hafasResult!.journeys[mainJourneyNr].collapsed = false

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


struct JourneyView: View {
    private var collapsed: Bool
    private var journey: Journey
    
    
    @Namespace private var journeyNS
    
    
    init(collapsed: Bool, journey: Journey){
        self.collapsed = collapsed
        self.journey = journey
    }
    
    var body: some View {
        if (collapsed){
            collapsedJourney(varJourney: journey, journeyNS: journeyNS)
        } else {
            mainJourney(varJourney: journey, journeyNS: journeyNS)
        }
    }
}


#Preview {
    ConnectionView(startTile: Tile(name: "Rheda", orderNr: 1, station_id: 8000315), endTile: Tile(name: "Gütersloh", orderNr: 2, station_id: 923249))
}
