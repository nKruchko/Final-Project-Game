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
        GeometryReader(content: {
            geometry in
            SpriteView(scene: GameScene(size: geometry.size))
                .background(Color.black)
        })
    }
}

#Preview {
    ContentView()
}
