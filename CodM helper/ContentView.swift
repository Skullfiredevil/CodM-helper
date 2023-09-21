//
//  ContentView.swift
//  CodM helper
//
//  Created by Tiago Pinto on 21/09/2023.
//

import SwiftUI

struct GameMode: Codable, Identifiable {
    var id = UUID()
    var name: String
    var pointsNeeded: Int
    var pointsPerKill: Int
}

struct ContentView: View {
    @State private var gameModes: [GameMode] = []
    @State private var selectedGameMode = 0
    @State private var currentPoints = 0
    @State private var killsNeeded = 0
    @State private var newGameModeName = ""
    @State private var newGameModePointsNeeded = ""
    @State private var newGameModePointsPerKill = ""

    init() {
        if let savedGameModes = UserDefaults.standard.data(forKey: "gameModes") {
            let decoder = JSONDecoder()
            if let decodedGameModes = try? decoder.decode([GameMode].self, from: savedGameModes) {
                self._gameModes = State(initialValue: decodedGameModes)
            }
        }
    }

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

            List {
                ForEach(gameModes) { mode in
                    Text("\(mode.name): \(mode.pointsNeeded) points, \(mode.pointsPerKill) per kill")
                }
                .onDelete(perform: deleteGameMode)
            }

            HStack {
                TextField("New Game Mode Name", text: $newGameModeName)
                    .padding()
                TextField("Points Needed", text: $newGameModePointsNeeded)
                    .padding()
                TextField("Points Per Kill", text: $newGameModePointsPerKill)
                    .padding()
                Button("Add Game Mode") {
                    addGameMode()
                }
                .padding()
            }

            Button("Calculate") {
                calculateKillsNeeded()
            }
            .padding()
        }
        .frame(width: 400, height: 600)
    }

    func calculateKillsNeeded() {
        let selectedMode = gameModes[selectedGameMode]
        let pointsDifference = max(selectedMode.pointsNeeded - currentPoints, 0)
        killsNeeded = (pointsDifference + selectedMode.pointsPerKill - 1) / selectedMode.pointsPerKill
    }

    func deleteGameMode(at offsets: IndexSet) {
        gameModes.remove(atOffsets: offsets)
        saveGameModes()
    }

    func saveGameModes() {
        let encoder = JSONEncoder()
        if let encodedGameModes = try? encoder.encode(gameModes) {
            UserDefaults.standard.set(encodedGameModes, forKey: "gameModes")
        }
    }

    func addGameMode() {
        if let pointsNeeded = Int(newGameModePointsNeeded),
           let pointsPerKill = Int(newGameModePointsPerKill) {
            let newGameMode = GameMode(name: newGameModeName, pointsNeeded: pointsNeeded, pointsPerKill: pointsPerKill)
            gameModes.append(newGameMode)
            saveGameModes()

            newGameModeName = ""
            newGameModePointsNeeded = ""
            newGameModePointsPerKill = ""
        }
    }
}





