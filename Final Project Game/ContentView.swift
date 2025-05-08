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
    @State private var musicVolume = 2 //0:off, 1:50%, 2:100%
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
                    
                    Button(action: {
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
                    showMenu: $showMenu, musicVolume: $musicVolume, soundVolume: $effectsVolume, onClose: {showMenu = false})
                .frame(width: 400, height: 600)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .transition(.scale)
                .zIndex(1)
                
            }
        }//end zstack
        
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
            .offset(x:-22)
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
            .offset(x:10)
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
            .offset(x:-10)
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
                .frame(width: 20,height: 20)
                .offset(x: CGFloat(level - 1) * 20)
                .animation(.easeInOut(duration: 0.2), value: level)
                .onTapGesture {
                    level = (level + 1) % 3
                }
        }
        
    }
}
struct closeMenuButton: View{
    @Binding var showMenu: Bool
    var body: some View{
        Image("Menu_Close")
            .onTapGesture {
                showMenu = false
            }
    }
}
struct gameMenuView: View{
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
                    showMenu = false }
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
                closeMenuButton(showMenu: $showMenu)
                    .offset(y:125)
                    .scaleEffect(0.5)
            }
        }
    }
}




//USE OPTION+COMMAND+RETURN to bring preview back
#Preview {
    ContentView()
}
