//
//  LobbyCreationView.swift
//  TicTacToe
//
//  Created by Nityananda on 05.02.21.
//

import SwiftUI

struct LobbyCreationView: View {
    var body: some View {
        List {
            Button {
                print("Create lobby")
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
