//
//  mainJourney.swift
//  easyOffi
//
//  Created by Jonas Kunze on 02.11.23.
//

import SwiftUI

struct collapsedJourney: View {
    private let varJourney: Journey
    @State private var totalTime = 0.0
    
    init(varJourney: Journey) {
        self.varJourney = varJourney
    }
    
    var body: some View {
        let legs = varJourney.legs
        
        VStack{
            HStack{
                TimeView(plannedTime: legs[0].plannedDeparture, realTime: legs[0].departure, prognosisType: legs[0].departurePrognosisType)
                .padding(.leading)
                GeometryReader { geometry in

                        HStack(spacing: 4) {
                            ForEach(legs, id: \.customId) { tempLeg in
                                let walking = tempLeg.line == nil
                                
                                
                                if(walking){
                                    Image(systemName: "figure.walk")
                                        //.frame(width: geometry.size.width * getTimeShare(leg: tempLeg), height: 30)
                                        .frame(minWidth: 18, maxWidth: 40)
                                        .frame(height: 30)
                                        .background(Color("Background2"))
                                } else {
                                    Text(tempLeg.line!.name)
                                        //.frame(width: geometry.size.width * getTimeShare(leg: tempLeg), height: 30)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 30)
                                        .background(Color("Background2"))
                                        //.layoutPriority(isFirst ? 1 : 0)

                                }
                            }
                    }
                }
                .frame(height: 30)
                .padding(.leading, 0)
                .padding(.trailing, 0)
                
                TimeView(plannedTime: legs[legs.count - 1].plannedArrival, realTime: legs[legs.count - 1].arrival, prognosisType: legs[legs.count - 1].arrivalPrognosisType)
                .padding(.trailing)
                .onAppear(){
                    totalTime = getTotalTime(journey: varJourney)
                }
                
                

            }
        }
        .frame(maxHeight: 60)
        .background(Color("Background3"))
        .clipShape(RoundedRectangle(cornerRadius: 8))

        
    }
    func getTotalTime(journey: Journey) -> TimeInterval{
        var tempTime = 0.0
        journey.legs.forEach(){ leg in
            tempTime += (leg.arrival.timeIntervalSince1970 - leg.departure.timeIntervalSince1970)
        }
        return tempTime
    }
    
    func getTimeShare(leg: Leg) -> Double{
        if(totalTime != 0.0){
            let legTime = leg.arrival.timeIntervalSince1970 - leg.departure.timeIntervalSince1970
            let timeShare = legTime / totalTime
            return timeShare
        }
        return 0.0
    }
    
}

#Preview {
    collapsedJourney(varJourney: testHafas!.journeys[0])
}
