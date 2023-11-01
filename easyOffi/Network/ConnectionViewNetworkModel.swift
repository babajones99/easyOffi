//
//  ConnectionViewModel.swift
//  easyOffi
//
//  Created by Jonas Kunze on 01.11.23.
//

import Foundation

class JourneyCall {
    let startTile: Tile
    let endTile: Tile
    
    init(startTile: Tile, endTile: Tile) {
        self.startTile = startTile
        self.endTile = endTile
    }
    
    
    func getHafas() async throws -> Hafas {
        
        let url = URL(string: "https://v6.db.transport.rest/journeys?from=\(startTile.station_id)&to=\(endTile.station_id)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        let request = URLRequest(url: url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .iso8601
        
        let fetchedData = try decoder.decode(Hafas.self, from: try mapResponse(response: (data,response)))
        
        return fetchedData
    }
    
    
    
}
