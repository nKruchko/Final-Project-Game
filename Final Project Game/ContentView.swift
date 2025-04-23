//
//  ContentView.swift
//  Final Project Game
//
//  Created by Kruchko, Nathan (512490) on 4/17/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        VStack{
            GeometryReader(content: {
                geometry in
                SpriteView(scene: GameScene(size: geometry.size))
                    .background(Color.black)
            })
            ZStack{
                Rectangle()
                    .frame(width: .infinity, height: 250)
            }
        }
    }
}

#Preview {
    ContentView()
}
