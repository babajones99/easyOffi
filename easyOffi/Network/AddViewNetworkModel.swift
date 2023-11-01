//
//  AddViewNetworkModel.swift
//  easyOffi
//
//  Created by Jonas Kunze on 01.11.23.
//
import Foundation


class StationCall {
    let searchTerm: String
    
    init(searchTerm: String) {
        self.searchTerm = searchTerm
    }
    
    
    func getStations() async throws -> [Station] {
        
        let url = URL(string: "https://v6.db.transport.rest/locations?results=5&query=\(searchTerm)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        let request = URLRequest(url: url!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        
        let fetchedData = try JSONDecoder().decode([Station].self, from: try mapResponse(response: (data,response)))
        
        return fetchedData
    }
}
