//
//  SettingsView.swift
//  easyOffi
//
//  Created by Jonas Kunze on 24.11.23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("localization") var localization = true
    @AppStorage("nationalExpress") var nationalExpress = false


    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Funktionen")) {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.blue)
                                .frame(width: 28, height: 28)
                            Image(systemName: "location.fill")
                                .foregroundStyle(Color.white)
                        }
                        Toggle("Kachel aktueller Standort", isOn: $localization)
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.orange)
                                .frame(width: 28, height: 28)
                            Image(systemName: "train.side.front.car")
                                .foregroundStyle(Color.white)
                        }
                        Toggle("Fernverkehr?", isOn: $nationalExpress)
                    }
                }
            }
            .navigationBarTitle("Einstellungen")
        }
    }
}

#Preview {
    SettingsView()
}
