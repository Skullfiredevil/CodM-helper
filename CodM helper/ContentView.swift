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
        HStack {
            NavigationView {
                VStack {
                    Text("Game Mode Calculator")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    GroupBox {
                        Picker("", selection: $selectedGameMode) {
                            ForEach(0..<gameModes.count, id: \.self) { index in
                                Text(gameModes[index].name)
                            }
                        }
                        .pickerStyle(PopUpButtonPickerStyle()) // Adjusted for macOS
                        .labelsHidden()
                    }

                    GroupBox(label: Text("Player Stats")) {
                        VStack(alignment: .leading) {
                            Text("Current Points")
                                .font(.caption)
                                .foregroundColor(.gray)

                            TextField("Enter Points", value: $currentPoints, formatter: NumberFormatter(), onCommit: {})
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }

                    GroupBox(label: Text("Total Kills Needed")) {
                        Text("\(killsNeeded)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                    }

                    List {
                        ForEach(gameModes) { mode in
                            HStack {
                                Text(mode.name)
                                    .font(.title3)
                                    .fontWeight(.bold)

                                Spacer()

                                Text("\(mode.pointsNeeded) points, \(mode.pointsPerKill) per kill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .onDelete(perform: deleteGameMode)
                    }
                    .listStyle(PlainListStyle())

                    HStack {
                        TextField("New Game Mode Name", text: $newGameModeName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        TextField("Points Needed", text: $newGameModePointsNeeded)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        TextField("Points Per Kill", text: $newGameModePointsPerKill)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button(action: {
                            addGameMode()
                        }) {
                            Text("Add Game Mode")
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .padding()
                    }
                        
                        Button(action: {
                            calculateKillsNeeded()
                        }) {
                            Text("Calculate") // Add the "Calculate" button
                                .padding()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(DefaultButtonStyle()) // Apply the DefaultButtonStyle
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(NSColor.windowBackgroundColor))
                        .shadow(radius: 10)
                )
                .padding()
            }
        }
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
           let pointsPerKill = Int(newGameModePointsPerKill),
           !newGameModeName.isEmpty {
            let newGameMode = GameMode(name: newGameModeName, pointsNeeded: pointsNeeded, pointsPerKill: pointsPerKill)
            gameModes.append(newGameMode)
            saveGameModes()

            newGameModeName = ""
            newGameModePointsNeeded = ""
            newGameModePointsPerKill = ""
        }
    }
}


