//
//  MainView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 06.11.2023.
//

import SceneKit
import SwiftUI

struct MainView: View {
    @ObservedObject private var viewModel = MainViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        ZStack {
            SceneView(scene: viewModel.mainScene,
                      pointOfView: viewModel.camera, options: [.allowsCameraControl])
                .background(.secondary)
                .edgesIgnoringSafeArea(.all)
            HStack {
                Button(action: {
                    showingSettings.toggle()
                }) {
                    Label("", systemImage: "gear")
                        .font(.system(size: 40))
                        .tint(.black)
                        .controlSize(.large)
                }
                .popover(isPresented: $showingSettings) {
                    SettingsView(viewModel: viewModel)
                        .frame(minWidth: 400, minHeight: 150)
                }
                Spacer()
                Menu {
                    ForEach(DiceType.allCases) { dice in
                        Button(action: {
                            viewModel.spawnDice(type: dice)
                        }, label: {
                            Text(dice.rawValue.uppercased())
                        })
                    }
                } label: {
                    Label("", systemImage: "dice.fill")
                        .font(.system(size: 40))
                        .tint(.black)
                        .controlSize(.large)

                }
            }
            .ignoresSafeArea(.all)
            .padding(.horizontal)
        }
    }
}

#Preview {
    MainView()
        .previewDevice(PreviewDevice(rawValue: "iPad Air 5th generation"))
}
