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
                    MoveButton(
                        action: { gameScene.moveLeft() },
                        onRelease: { gameScene.stopMoving() }
                    )

                    .rotationEffect(Angle(degrees: 180))
                    Button(action: {
                        gameScene.jump()
                    }) {
                        Image("")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    .buttonRepeatBehavior(.enabled)

                    
                    MoveButton(
                        action: { gameScene.moveRight() },
                        onRelease: { gameScene.stopMoving() }
                    )
                }
                .foregroundColor(.white)
                .padding()
            }
        }
    }
}
struct MoveButton: View {
    @State private var isPressed = false
    @State private var timer: Timer? = nil
    let action: () -> Void
    let onRelease: () -> Void

    var body: some View {
        Image(isPressed ? "arrowPressed" : "arrow")
            .resizable()
            .frame(width: 50, height: 50)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                                action()
                            }
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        timer?.invalidate()
                        timer = nil
                        onRelease()
                    }
            )
    }
}

#Preview {
    ContentView()
}
