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
                    .ignoresSafeArea()
            })
            
            //stack of controls and buttons
            ZStack {
                Color.gray
                .ignoresSafeArea()
                
                //left, jump, right buttons
                HStack(spacing: 0) {
                        Color.gray
                        .ignoresSafeArea()
                        MoveButton(
                            action: { gameScene.moveLeft() },
                            onRelease: { gameScene.stopMoving() })
                        .scaleEffect(x:-1)
                        
                        
                    
                    JumpButton {
                        gameScene.jump()
                    }                    
                    UseButton{
                        gameScene.use()
                    }
                    
                        
                        
                    MoveButton(
                        action: { gameScene.moveRight() },
                        onRelease: { gameScene.stopMoving() }
                    )
                }//end hstack
                .frame(width: 100, height: 100)
                
            }//end zstack
            .frame(width: 500, height: 150)
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
            .frame(width: 120, height: 120)
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

struct UseButton: View {
    @State private var isPressed = false
    let action: () -> Void

    var body: some View {
        Image(isPressed ? "B_Use_0" : "B_Use_1")
            .resizable()
            .frame(width: 120, height: 120)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            // calls use once when pressed
                            action()
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
            .offset(y:-16)
    }
}




//USE OPTION+COMMAND+RETURN to bring preview back
#Preview {
    ContentView()
}
