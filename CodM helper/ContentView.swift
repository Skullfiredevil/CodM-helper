//
//  ContentView.swift
//  CodM helper
//
//  Created by Tiago Pinto on 21/09/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var pointsNeeded = 0
    @State private var pointsPerKill = 20
    @State private var currentPoints = 0
    @State private var killsNeeded = 0

    var body: some View {
        VStack {
            Text("Kills Needed to Reach 1st Place")
                .font(.title)
                .padding()

            TextField("Points Needed for 1st Place", value: $pointsNeeded, formatter: NumberFormatter())
                .padding()

            TextField("Points per Kill", value: $pointsPerKill, formatter: NumberFormatter())
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
        let pointsDifference = pointsNeeded - currentPoints
        killsNeeded = pointsDifference / pointsPerKill
    }
}

