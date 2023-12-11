//
//  MainView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 06.11.2023.
//

import SceneKit
import SwiftUI

struct MainView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                SceneView(scene: viewModel.mainScene,
                          pointOfView: viewModel.camera, 
                          options: [],
                          delegate: viewModel)
                .background(.secondary)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { location in
                    viewModel.throwDice()
                }
                ZStack {
                    if viewModel.isDebugMode {
                        DebugModeView(nodeStats: viewModel.nodeStats)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
                    DiceTypeMenuView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding()
                }
            }
            .toolbar {
                Button(action: {
                    showingSettings.toggle()
                }) {
                    Label("", systemImage: "gearshape.fill")
                }
                .popover(isPresented: $showingSettings) {
                    SettingsView()
                        .frame(minWidth: 400, minHeight: 150)
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
