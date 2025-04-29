//
//  ContentView.swift
//  Final Project Game
//
//  Created by Kruchko, Nathan (512490) on 4/17/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    //game screen
    @State private var gameScene = GameScene(size: CGSize(width: 300, height: 600))
    
    //screen elements
    var body: some View {
        VStack{
            //game scene renderer
            GeometryReader(content: {
                geometry in
                SpriteView(scene: gameScene)
                    .onAppear {
                        gameScene.size = geometry.size
                        gameScene.scaleMode = .resizeFill
                    }
                    .background(Color.black)
            })
            
            //stack of controls and buttons
            ZStack {
                Rectangle()
                    .foregroundColor(Color(.lightGray))
                    .frame(height: 128)
                
                //left, jump, right buttons
                HStack(spacing: 16) {
                    Color.gray
                        .ignoresSafeArea()
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(height: 100)
                    HStack(spacing: 20) {
                        
                        MoveButton(
                            action: { gameScene.moveLeft() },
                            onRelease: { gameScene.stopMoving() })
                        .scaleEffect(x:-1)
                        
                        JumpButton {
                            gameScene.jump()
                        }
                        
                        MoveButton(
                            action: { gameScene.moveRight() },
                            onRelease: { gameScene.stopMoving() }
                        )
                    }

                    Button(action: {
                        gameScene.use()
                    }) {
                        Image("Button")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    .buttonRepeatBehavior(.enabled)
                    
                    MoveButton(
                        action: { gameScene.moveRight() },
                        onRelease: { gameScene.stopMoving() }
                    )
                }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
            }
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
        }
    }
}
struct MoveButton: View {
    @State private var isPressed = false
    
    //allows to hold to walk
    @State private var timer: Timer? = nil
    
    let action: () -> Void
    let onRelease: () -> Void

    var body: some View {
        Image(isPressed ? "B_Arrow_1" : "B_Arrow_0")
            .resizable()
            .frame(width: 80, height: 80)
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
struct JumpButton: View {
    @State private var isPressed = false
    let action: () -> Void

    var body: some View {
        Image(isPressed ? "B_Jump_1" : "B_Jump_0")
            .resizable()
            .frame(width: 160, height: 160)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            // calls jump once when pressed
                            action()
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
            .offset(y:-16) //fixes it being slightly off center
        
    }
}


#Preview {
    ContentView()
}
