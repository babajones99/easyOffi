//
//  sampleModel.swift
//  easyOffi
//
//  Created by Jonas Kunze on 02.11.23.
//

import Foundation
import SwiftUI


let testData = TestData()
var testHafas = testData.ReadJSON()


class TestData: ObservableObject{
    
    public func ReadJSON() -> Hafas? {
        let fileName = "mediumJourney"
        let fileType = "json"
        
            do {
                let path = Bundle.main.path(forResource: fileName, ofType: fileType)
                let data = try Data(contentsOf: URL(filePath: path!), options: .mappedIfSafe)
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                let decoder = JSONDecoder()
                
                decoder.dateDecodingStrategy = .iso8601
                
                let fetchedData = try decoder.decode(Hafas.self, from: data)
                
                return fetchedData
            }catch{
                return nil
            }

    }
}
