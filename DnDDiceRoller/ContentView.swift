//
//  ContentView.swift
//  DnDDiceRoller
//
//  Created by Volodymyr Parunakian on 06.11.2023.
//

import SceneKit
import SwiftUI

struct ContentView: View {
    private let mainScene = makeScene()
    
    var body: some View {
        ZStack {
            SceneView(scene: mainScene,
                      pointOfView: setUpCamera(), options: [.allowsCameraControl])
                .background(.secondary)
                .edgesIgnoringSafeArea(.all)
            Group {
                Button(action: {}, label: {
                    Text("Roll it!")
                        
                })
                .font(.system(size: 30))
                .tint(.red)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        
    }
    
    static func makeScene() -> SCNScene? {
        let scene = SCNScene(named: "MainScene.scn")
        applyTextures(to: scene)
        return scene
    }
    
    func setUpCamera() -> SCNNode? {
        let cameraNode = mainScene?.rootNode
            .childNode(withName: "camera", recursively: false)
        return cameraNode
    }
    
    static func applyTextures(to scene: SCNScene?) {
        let table = scene?.rootNode
            .childNode(withName: "table", recursively: false)
        
        Material.wood.apply(to: table)
        
        let d4 = scene?.rootNode.childNode(withName: "d4", recursively: false)
        
        Material.plastic.apply(to: d4)
        Decal.d4.apply(to: d4)
        
        let d6 = scene?.rootNode.childNode(withName: "d6", recursively: false)
        
        Material.metalRough.apply(to: d6)
        Decal.dN.apply(to: d6)
        
        let d6Action = SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(-Double.pi * 2), around: SCNVector3(x: 0, y: 1, z: 0), duration: TimeInterval(10)))
        let d6Action2 = SCNAction.repeatForever(SCNAction.rotate(by: CGFloat(2*Double.pi), around: SCNVector3(x: 0, y: 0, z: 1), duration: TimeInterval(10)))
        
        d6?.runAction(d6Action)
        d6?.runAction(d6Action2)
    
//        let skyboxImages = UIImage(named: "Wall")
//        scene?.background.contents = skyboxImages
    }
}

#Preview {
    ContentView()
}
