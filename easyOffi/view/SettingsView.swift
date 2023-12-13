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
    @AppStorage("walkingSpeed") var walkingSpeed = "normal"
    @AppStorage("platformOnChange") var platformOnChange = false


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
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.green)
                                .frame(width: 28, height: 28)
                            Image(systemName: "figure.walk")
                                .foregroundStyle(Color.white)
                        }
                        Picker("Gehgeschwindigkeit", selection: $walkingSpeed){
                            Text("Langsam").tag("slow")
                            Text("Normal").tag("normal")
                            Text("Schnell").tag("fast")
                        }
                    }
                }
                Section(header: Text("Ansicht")) {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.blue)
                                .frame(width: 28, height: 28)
                            Image(systemName: "number")
                                .foregroundStyle(Color.white)
                        }
                        Toggle("Gleis nur bei Gleisänderung anzeigen", isOn: $platformOnChange)
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
