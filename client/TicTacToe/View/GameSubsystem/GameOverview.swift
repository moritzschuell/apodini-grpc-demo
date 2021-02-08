//
//  GameOverview.swift
//  TicTacToe
//
//  Created by Nityananda on 05.02.21.
//

import SwiftUI

struct GameOverview: View {
    @State var isShowingNewGame: Bool = false
    
    var body: some View {
        NavigationView {
            GameListView()
                .navigationBarTitle("Games")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(
                    trailing: Button("New Game") {
                        isShowingNewGame = true
                    }
                )
                .sheet(isPresented: $isShowingNewGame) {
                    newGameSheet
                }
        }
    }
}

private extension GameOverview {
    var newGameSheet: some View {
        NavigationView {
            NewGameView()
                .navigationBarTitle(Text("New Game"), displayMode: .inline)
                .navigationBarItems(
                    leading: Button("Cancel") {
                        isShowingNewGame = false
                    }
                )
        }
    }
}
