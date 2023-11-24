//
//  TimeView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 03.11.23.
//

import SwiftUI

struct TimeView: View {
    private let plannedTime: Date
    private let realTime: Date
    private let prognosisType: String?
    
    init(plannedTime: Date, realTime: Date, prognosisType: String?) {
        self.plannedTime = plannedTime
        self.realTime = realTime
        self.prognosisType = prognosisType
    }
    
    var body: some View {
        if(prognosisType == "prognosed"){
            if(plannedTime == realTime){
                VStack {
                    Text(realTime, style: .time)
                        .font(.system(size: 18).bold())
                        .foregroundStyle(Color.green)
                }
            } else {
                VStack {
                    Text(plannedTime, style: .time)
                        .strikethrough()
                        .font(.system(size: 14))
                    Text(realTime, style: .time)
                        .font(.system(size: 16).bold())
                        .foregroundStyle(Color.red)
                }
            }
        } else {
            VStack {
                Text(realTime, style: .time)
                    .font(.system(size: 18).bold())
            }
        }
    }
}

#Preview {
    TimeView(plannedTime: Date(), realTime: Date().advanced(by: 300), prognosisType: "prognosed")
}
