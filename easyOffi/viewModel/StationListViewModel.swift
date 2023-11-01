//
//  StationListViewModel.swift
//  easyOffi
//
//  Created by Jonas Kunze on 01.11.23.
//

import Foundation

import Combine

class StationListViewModel: ObservableObject {
    
    enum State: Comparable {
        case good
        case isLoading
        case loadedAll
        case error(String)
    }
    
    @Published var searchTerm: String = ""
    @Published var stations: [Station] = [Station]()
    
    @Published var state: State = .good {
        didSet {
            print("state changed to: \(state)")
        }
    }
    
    let limit: Int = 5
    var page: Int = 0
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        
        $searchTerm
            .dropFirst()
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .sink { [weak self] term in
                self?.state = .good
                self?.stations = []
                self?.fetchStations(for: term)
            }.store(in: &subscriptions)
        
    }
    
    func loadMore() {
        fetchStations(for: searchTerm)
    }
    
    func fetchStations(for searchTerm: String) {
        
        guard !searchTerm.isEmpty else {
            return
        }
        
        guard state == State.good else {
            return
        }
        
        let offset = page * limit
        guard let url = URL(string: "https://v6.db.transport.rest/locations?results=\(limit)&query=\(searchTerm)&addresses=false&poi=false") else {
            return
        }
        
        
        print("start fetching data for \(searchTerm)")
        state = .isLoading
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if let error = error {
                print("urlsession error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.state = .error("Could not load: \(error.localizedDescription)")
                }
            } else if let data = data {
                
                do {
                    print(url)
                    let result = try JSONDecoder().decode(Stations.self, from: data)
                    DispatchQueue.main.async {
                        self!.stations = result
                        print("fetched \(self!.stations.count)")
                        
                    }
                    
                } catch {
                    print("decoding error \(error)")
                    DispatchQueue.main.async {
                        self?.state = .error("Could not get data: \(error.localizedDescription)")
                    }
                }
            }
            
            
            
        }.resume()
        
        
    }
    
}
