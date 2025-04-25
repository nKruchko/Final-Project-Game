//
//  ContentView.swift
//  Final Project Game
//
//  Created by Kruchko, Nathan (512490) on 4/17/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var gameScene = GameScene(size: CGSize(width: 300, height: 600))
    var body: some View {
        VStack{
            GeometryReader(content: {
                geometry in
                SpriteView(scene: gameScene)
                    .onAppear {
                        gameScene.size = geometry.size
                        gameScene.scaleMode = .resizeFill
                    }
                    .background(Color.black)
            })
            ZStack {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(height: 100)
                HStack(spacing: 20) {
                    Button(action:{gameScene.moveLeft()}){Image("arrow")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .rotationEffect(Angle(degrees: 180))
                    }
                    .buttonRepeatBehavior(.enabled)
                    Button(action: {
                        gameScene.jump()
                    }) {
                        Image("")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    .buttonRepeatBehavior(.enabled)

                    
                    Button(action: {
                        gameScene.moveRight()
                    }) {
                        Image("arrow")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .buttonRepeatBehavior(.enabled)

                }
                .foregroundColor(.white)
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
