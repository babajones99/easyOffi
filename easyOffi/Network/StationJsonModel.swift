// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stations = try? JSONDecoder().decode(Stations.self, from: jsonData)

import Foundation

// MARK: - StationResult
struct StationResult: Codable {
    let resultCount: Int
}

// MARK: - Station
struct Station: Codable, Identifiable {
    let type, id, name: String
    let location: Location
    let products: Products
    let isMeta: Bool?
}

typealias Stations = [Station]
