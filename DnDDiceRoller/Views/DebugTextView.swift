//
//  DebugTextView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 08.12.2023.
//

import SwiftUI

struct DebugTextView: View {
    @ObservedObject var nodeStats: NodeStats

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Camera Position: \(nodeStats.cameraPosition)")
                Text("Camera Euler Angles: \(nodeStats.cameraEulerAngles)")
                Text("Camera Rotation: \(nodeStats.cameraRotation)")
                Text("Dice Position: \(nodeStats.dicePosition)")
                Text("Dice Euler Angles: \(nodeStats.diceEulerAngles)")
                Text("Dice Rotation: \(nodeStats.diceRotation)")
            }
            .padding(.horizontal)
            .font(.caption2)
            Spacer()
        }
    }
}

#Preview {
    DebugTextView(nodeStats: NodeStats())
}
