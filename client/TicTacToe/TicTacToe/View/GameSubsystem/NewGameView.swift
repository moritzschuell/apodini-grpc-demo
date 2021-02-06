//
//  NewGameView.swift
//  TicTacToe
//
//  Created by Nityananda on 05.02.21.
//

import SwiftUI

struct NewGameView: View {
    var body: some View {
        List {
            Button {
                print("New game")
            } label: {
                HStack {
                    Spacer()
                    Text("Tic Tac Toe")
                        .bold()
                    Spacer()
                }
            }
            
            Button {
                //
            } label: {
                Text("More games coming soon...")
                    .foregroundColor(.gray)
            }
        }
    }
}
