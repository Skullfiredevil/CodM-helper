//
//  ContentView.swift
//  CodM helper
//
//  Created by Tiago Pinto on 21/09/2023.
//

import SwiftUI
        struct ContentView: View {
            @State private var selectedGameMode = 0
            @State private var currentPoints = 0
            @State private var killsNeeded = 0

            let gameModes: [GameMode] = [
                GameMode(name: "Blackout War", pointsNeeded: 1469, pointsPerKill: 20),
                // Add more game modes here as needed
            ]

            var body: some View {
                VStack {
                    Text("Kills Needed to Reach 1st Place")
                        .font(.title)
                        .padding()

                    Picker("Game Mode", selection: $selectedGameMode) {
                        ForEach(0..<gameModes.count, id: \.self) { index in
                            Text(gameModes[index].name)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()

                    TextField("Current Points", value: $currentPoints, formatter: NumberFormatter())
                        .padding()

                    HStack {
                        Text("Total Kills Needed:")
                        Text("\(killsNeeded)")
                            .font(.headline)
                    }
                    .padding()

                    Button("Calculate") {
                        calculateKillsNeeded()
                    }
                    .padding()
                }
                .frame(width: 300, height: 300)
            }

            func calculateKillsNeeded() {
                let selectedMode = gameModes[selectedGameMode]
                let pointsDifference = max(selectedMode.pointsNeeded - currentPoints, 0)
                killsNeeded = (pointsDifference + selectedMode.pointsPerKill - 1) / selectedMode.pointsPerKill
            }
        }

struct GameMode {
    var name: String
    var pointsNeeded: Int
    var pointsPerKill: Int
}
