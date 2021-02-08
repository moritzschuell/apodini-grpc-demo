//
//  GameListView.swift
//  TicTacToe
//
//  Created by Nityananda on 06.02.21.
//

import SwiftUI

struct GameListView: View {
    var body: some View {
        List(1..<3) { index in
            cell(index)
        }
    }
}

private extension GameListView {
    func cell(_ index: Int) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Tic Tac Toe")
                    .font(.headline)
                Text("1 of 2 online")
            }
            
            Spacer()
            
            Button("Join") {
                print("Joined game")
            }
        }
    }
}

