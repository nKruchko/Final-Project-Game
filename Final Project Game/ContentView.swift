//
//  ContentView.swift
//  Final Project Game
//
//  Created by Kruchko, Nathan (512490) on 4/17/25.
//

import SwiftUI
import SpriteKit

let clickIn = SKAction.playSoundFileNamed("clickIn", waitForCompletion: false)
let clickOut = SKAction.playSoundFileNamed("clickOut", waitForCompletion: false)
struct ContentView: View {
    //game screen
    @State private var gameScene = GameScene(size: CGSize(width: 300, height: 600))
    @State private var  musicVolume = 2 //0:off, 1:50%, 2:100%
    @State private var effectsVolume = 2
    @State private var showMenu = false

    
    //screen elements
    var body: some View {
        
        ZStack{
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
                .offset(x:53)
                
                //stack of controls and buttons
                ZStack {
                    Image("Button_Backround")
                        .resizable()
                        .frame(width: 400,height: 200)
                        .offset(y:10)
                        .ignoresSafeArea()
                    //left, jump, right buttons
                    HStack(spacing: 0) {
                        Color.gray
                            .ignoresSafeArea()
                        MoveButton(
                            gameScene: gameScene, action: { gameScene.moveLeft()
                            },
                            onRelease: { gameScene.stopMoving() })
                        .scaleEffect(x:-1)
                        
                        
                        
                        JumpButton(
                            gameScene: gameScene,
                            action: {
                                gameScene.jump()
                            }
                        )
                        UseButton(
                            gameScene: gameScene,
                            action: {
                                gameScene.use()
                            }
                        )

                        
                        
                        MoveButton(
                            gameScene: gameScene, action: { gameScene.moveRight() },
                            onRelease: { gameScene.stopMoving() }
                        )
                    }//end hstack
                    .frame(width: 100, height: 100)
                    
                    Button(action: {
                        gameScene.run(clickIn)
                        showMenu = true
                    }){
                        Image("B_Menu")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    .offset(x: 175, y: -60)
                    
                }//end zstack
                .frame(width: 500, height: 150)
            }//end vstack
            
            if showMenu{
                
                gameMenuView(
                    gameScene: gameScene,
                    showMenu: $showMenu,
                    musicVolume: $musicVolume,
                    soundVolume: $effectsVolume,
                    onClose: { showMenu = false }
                )
                .frame(width: 400, height: 600)
                .shadow(radius: 10)
                .transition(.scale)
                .zIndex(1)
                .modifier(SwayingEffect())
                .background(StaticBackgroundView())
                .offset(y:-50)
            }
        }//end zstack
        
    }
}
struct MoveButton: View {
    let gameScene: GameScene
    @State private var isPressed = false
    
    //allows to hold to walk
    @State private var timer: Timer? = nil
    
    let action: () -> Void
    let onRelease: () -> Void

    var body: some View {
        Image(isPressed ? "B_Arrow_1" : "B_Arrow_0")
            .resizable()
            .frame(width: 80, height: 80)
            .offset(x:-22)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            gameScene.run(clickIn)
                            timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                                action()
                            }
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        timer?.invalidate()
                        timer = nil
                        gameScene.run(clickOut)
                        onRelease()
                    }
            )
    }
}
struct JumpButton: View {
    let gameScene: GameScene
    @State private var isPressed = false
    let action: () -> Void

    var body: some View {
        Image(isPressed ? "B_Jump_1" : "B_Jump_0")
            .resizable()
            .frame(width: 120, height: 120)
            .offset(x:10)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            gameScene.run(clickIn)
                            action()
                        }
                        if !isPressed {
                            isPressed = true
                            // calls jump once when pressed
                            action()
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        gameScene.run(clickOut)
                    }
            )
            .offset(y:-16) //fixes it being slightly off center
        
    }
}

struct UseButton: View {
    let gameScene: GameScene
    @State private var isPressed = false
    let action: () -> Void

    var body: some View {
        Image(isPressed ? "B_Use_0" : "B_Use_1")
            .resizable()
            .frame(width: 120, height: 120)
            .offset(x:-10)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                            gameScene.run(clickIn)
                            action()
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        gameScene.run(clickOut)
                    }
            )
            .offset(y:-16)
    }
}
struct volumeButton: View{
    @Binding var level: Int
    let onChange: (Int) -> Void
    let volumeNodes = ["Menu_0","Menu_1","Menu_2"]
    
    var body: some View{
        ZStack{
            HStack{
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40)
            
            Image(volumeNodes[level])
                .resizable()
                .frame(width: 60,height: 20)
                .offset(x: CGFloat(level - 1) * 20)
                .animation(.easeInOut(duration: 0.2), value: level)
                .onTapGesture {
                    level = (level + 1) % 3
                }
        }
        
    }
}
struct closeMenuButton: View{
    let gameScene: GameScene
    @Binding var showMenu: Bool
    var body: some View{
        Image("Menu_Close")
            .onTapGesture {
                gameScene.run(clickOut)
                showMenu = false
            }
    }
}
struct gameMenuView: View{
    let gameScene: GameScene
    @Binding var showMenu: Bool
    @Binding var musicVolume: Int
    @Binding var soundVolume: Int
    let onClose: () -> Void

    
    var body: some View{
        ZStack{
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .frame(width: 800, height: 2000)
                .onTapGesture {
                    gameScene.run(clickOut)
                    showMenu = false
                }
            Image("Menu_Background")
                .resizable()
                .frame(width: 300, height: 450)
            VStack{
                volumeButton(level: $soundVolume) { newLevel in
                }
                .scaleEffect(1.20)
                .offset(x:60,y:14)
                volumeButton(level: $musicVolume) {
                    newLevel in
                }
                .scaleEffect(1.2)
                .offset(x:60,y:22)
                closeMenuButton(gameScene: gameScene, showMenu: $showMenu)
                    .offset(y:125)
                    .scaleEffect(0.5)
            }
        }
    }
}
struct SwayingEffect: ViewModifier {
    @State private var sway = false
    
    func body(content: Content) -> some View {
        content
        //ai used for effect syntax up to ->
            .rotationEffect(.degrees(sway ? 1 : -1), anchor: .center)
            .offset(x: sway ? 1.5 : -1.5, y: sway ? 1 : -1)
            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: sway)
            .onAppear {
                sway = true
            }
    }
}//here<-
struct StaticBackgroundView: View {
    @State private var noiseOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { geometry in
            Image("Static")                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width*3, height: geometry.size.height*3)
                .opacity(0.7)
                //ai use up to ->
                .offset(noiseOffset)
                .onAppear {
                    withAnimation(Animation.linear(duration: 4).repeatForever(autoreverses: true)) {
                        noiseOffset = CGSize(width: .random(in: -300...300), height: .random(in: -300...300))
                    }
                }
                
                .offset(y:-300)
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
        //here <-
    }
}




//USE OPTION+COMMAND+RETURN to bring preview back
#Preview {
    ContentView()
}
