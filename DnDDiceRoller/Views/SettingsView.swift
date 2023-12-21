//
//  SettingsView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 22.11.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    var body: some View {
        Form {
            Picker("Dice Material", selection: $viewModel.material) {
                ForEach(Material.allCases) { material in
                    Text(material.displayName).tag(material)
                }
            }
            Picker("Dice Font", selection: $viewModel.decal) {
                ForEach(Decal.allCases) { decal in
                    Text(decal.displayName).tag(decal)
                }
            }
            Toggle(isOn: $viewModel.isDebugMode) {
                Text("Debug Mode")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(MainViewModel())
}
