//
//  StationListView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 01.11.23.
//

import SwiftUI
import SwiftData

struct StationListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tile.orderNr) private var tiles:[Tile]
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: StationListViewModel
    
    var body: some View {
        
        List {
            ForEach(viewModel.stations) { station in
                Button(station.name){
                    let newTile = Tile(name: station.name, orderNr: Int16(tiles.count), station_id: Int(station.id) ?? 0)
                    
                    modelContext.insert(newTile)
                    
                    dismiss()
                }
            }
            
            switch viewModel.state {
                case .good:
                    Color.clear
                        .onAppear {
                            viewModel.loadMore()
                        }
                case .isLoading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity)
                case .loadedAll:
                    EmptyView()
                case .error(let message):
                    Text(message)
                        .foregroundColor(.pink)
            }
        }
        .listStyle(.plain)
        
        
    }
}

struct AlbumListView_Previews: PreviewProvider {
    static var previews: some View {
        StationListView(viewModel: StationListViewModel())
    }
}
