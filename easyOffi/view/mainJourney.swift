//
//  mainJourney.swift
//  easyOffi
//
//  Created by Jonas Kunze on 02.11.23.
//

import SwiftUI

struct mainJourney: View {
    private let varJourney: Journey
    let journeyNS: Namespace.ID
    
    
    init(varJourney: Journey, journeyNS: Namespace.ID) {
        self.varJourney = varJourney
        self.journeyNS = journeyNS
    }
    
    @AppStorage("platformOnChange") var platformOnChange = false
    
    var body: some View {
        let tempFirstJourneyLegs = varJourney.legs
        
        VStack (alignment: .leading){
            ForEach(tempFirstJourneyLegs, id: \.customId) { leg in
                let isFirst = leg.customId == tempFirstJourneyLegs[0].customId
                let isLast = leg.customId == tempFirstJourneyLegs[tempFirstJourneyLegs.count - 1].customId
                let walking = leg.line == nil
                
                if walking{
                    
                    HStack {
                        VerticalLine()
                            .stroke(Color("Accent"), style: StrokeStyle(lineWidth: 4, dash: [8,6]))
                            .frame(width: 10, height: 30)
                        Label("\(String(leg.distance!)) Meter", systemImage: "figure.walk")
                            .matchedGeometryEffect(id: "walk\(leg.customId)", in: journeyNS)
                            .font(.system(size: 14))
                            .foregroundStyle(Color("Weak"))
                            .padding(.leading)
                        
                    }
                    
                } else {
                    VStack (alignment: .leading){
                        HStack (alignment: .top){
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(Color("Accent"))
                                .padding(.top, 8)
                            
                            if(isFirst){
                                TimeView(plannedTime: leg.plannedDeparture, realTime: leg.departure, prognosisType: leg.departurePrognosisType)
                                    .matchedGeometryEffect(id: "departureTime\(varJourney.refreshToken)", in: journeyNS)
                                    .padding(.top, 3)
                            }
                            else{
                                TimeView(plannedTime: leg.plannedDeparture, realTime: leg.departure, prognosisType: leg.departurePrognosisType)
                                
                            }
                            
                            VStack (alignment: .leading){
                                Text(leg.origin.name)
                                    .font(isFirst ? Font.title.weight(.bold) : Font.body)
                                    .padding(.trailing)
                                    .matchedGeometryEffect(id: "station\(leg.origin.name)", in: journeyNS, isSource: false)
                                
                                if(leg.departurePlatform != nil){
                                    if(platformOnChange){
                                        if(leg.departurePlatform != leg.plannedDeparturePlatform){
                                            Text("Gleis \(leg.departurePlatform!)")
                                                .font(isFirst ? Font.title3.weight(.bold) : Font.body)
                                                .foregroundStyle(Color.red)
                                        }
                                        
                                    }else{
                                        Text("Gleis \(leg.departurePlatform!)")
                                            .font(isFirst ? Font.title3.weight(.bold) : Font.body)
                                            .foregroundStyle(leg.departurePlatform == leg.plannedDeparturePlatform ? Color("Weak") : Color.red)
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                        
                        
                        
                        HStack {
                            /*VerticalLine()
                             .stroke(Color("Accent"), style: StrokeStyle(lineWidth: 4))
                             .frame(width: 10, height: 80)
                             .padding(.top, -15)*/
                            HStack(alignment: .center) {
                                Label(leg.line!.name, systemImage: transportIcon(productName: leg.line!.productName))
                                Image(systemName: "arrow.right")
                                Text(leg.direction!)
                            }
                            .frame(maxWidth: 300, maxHeight: 50)
                            .background(Color("Background3"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.leading)
                            .matchedGeometryEffect(id: "lineName\(leg.customId)", in: journeyNS)
                            
                        }
                        
                        
                        HStack (alignment: .bottom){
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(Color("Accent"))
                                .padding(.bottom, 8)
                            
                            if(isLast){
                                TimeView(plannedTime: leg.plannedArrival, realTime: leg.arrival, prognosisType: leg.arrivalPrognosisType)
                                    .matchedGeometryEffect(id: "arrivalTime\(varJourney.refreshToken)", in: journeyNS)
                                    .padding(.bottom, 3)
                            } else {
                                TimeView(plannedTime: leg.plannedArrival, realTime: leg.arrival, prognosisType: leg.arrivalPrognosisType)
                            }
                            
                            VStack (alignment: .leading){
                                Text(leg.destination.name)
                                    .font(isLast ? Font.title.weight(.bold) : Font.body)
                                    .padding(.trailing)
                                    .matchedGeometryEffect(id: "station\(leg.destination.name)", in: journeyNS, isSource: false)
                                
                                if(leg.arrivalPlatform != nil){
                                    if(platformOnChange){
                                        if(leg.arrivalPlatform != leg.plannedArrivalPlatform){
                                            Text("Gleis \(leg.arrivalPlatform!)")
                                                .font(isFirst ? Font.title3.weight(.bold) : Font.body)
                                                .foregroundStyle(Color.red)
                                        }
                                        
                                    }else{
                                        Text("Gleis \(leg.arrivalPlatform!)")
                                            .font(isFirst ? Font.title3.weight(.bold) : Font.body)
                                            .foregroundStyle(leg.arrivalPlatform == leg.plannedArrivalPlatform ? Color("Weak") : Color.red)
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                    }
                    .overlay (alignment: .leading){
                        VerticalLine()
                            .stroke(Color("Accent"), style: StrokeStyle(lineWidth: 4))
                            .frame(width: 10)
                            .padding(.top, 33)
                            .padding(.bottom, 33)
                    }
                    
                }
                
                
            }
        }
        
        
        
    }
    
    func transportIcon(productName: String) -> String{
        switch(productName){
        case "RB", "RE", "IR", "S", "U", "ME", "FLX":
            return "tram.fill"
        case "AST", "Bus":
            return "bus.fill"
        case "ICE":
            return "train.side.front.car"
        case "IC":
            return "train.side.rear.car"
        default:
            return "questionmark.diamond"
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

struct mainJourney_Previews: PreviewProvider{
    @Namespace static var journeyNS
    static var previews: some View {
        mainJourney(varJourney: testHafas!.journeys[0], journeyNS: journeyNS)
    }
}
