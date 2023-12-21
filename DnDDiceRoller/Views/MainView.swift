//
//  MainView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 06.11.2023.
//

import SceneKit
import SwiftUI

struct MainView: View {
    private enum Constants {
        static let settingsWidth = 400.0
        static let settingsHeight = 150.0
    }

    @EnvironmentObject private var viewModel: MainViewModel
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                SceneView(
                    scene: viewModel.mainScene,
                    pointOfView: viewModel.sceneManager.camera,
                    options: [],
                    delegate: viewModel
                )
                .background(.secondary)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { _ in
                    viewModel.throwDice()
                }
                .accessibilityAddTraits(.isButton)
                .accessibilityIdentifier("MainScene")

                DebugView()
                DiceTypeMenuView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding()
            }
            .toolbar {
                Button(action: {
                    showingSettings.toggle()
                }, label: {
                    Label("", systemImage: "gearshape.fill")
                })
                .popover(isPresented: $showingSettings) {
                    SettingsView()
                        .frame(minWidth: Constants.settingsWidth, minHeight: Constants.settingsHeight)
                }
            }
        }
        .accentColor(.primary)
    }
}

#Preview {
    MainView()
        .environmentObject(MainViewModel())
}
