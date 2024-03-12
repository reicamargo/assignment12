//
//  Assignment12App.swift
//  Assignment12
//
//  Created by Reinaldo Camargo on 12/03/24.
//

import SwiftUI

@main
struct Assignment12App: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            MemoryGameView(viewModel: game)
        }
    }
}
