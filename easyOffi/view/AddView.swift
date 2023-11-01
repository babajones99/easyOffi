//
//  addView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 28.10.23.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tile.orderNr) private var tiles:[Tile]
    
    @Environment(\.dismiss) var dismiss
    
    @State var stationName = ""
    @State var loading = false
    @State var isError = false
    @State var errorMessage = ""
    
    @StateObject var viewModel = StationListViewModel()
    
    var body: some View {
        NavigationView {
            /*VStack {
             HStack {
             Image(systemName: "magnifyingglass")
             .padding(5)
             TextField("Bahnhof/Haltestelle Suchen", text: $stationName)
             }
             .background(.white)
             .cornerRadius(20)
             
             
             Button("Hinzufügen"){
             let newTile = Tile(name: stationName, orderNr: Int16(tiles.count), station_id: Int(stationId) ?? 0)
             
             modelContext.insert(newTile)
             
             dismiss()
             }
             }
             .padding(.horizontal)
             .navigationTitle("Station hinzufügen")*/
            
            Group {
                if viewModel.searchTerm.isEmpty {
                    Text("Test")
                    Text(viewModel.searchTerm)
                } else {
                
                    StationListView(viewModel: viewModel)
                }
            }
            .searchable(text: $viewModel.searchTerm)
            .navigationTitle("Station hinzufügen")
            
        }
    }
}



#Preview {
    AddView()
}
