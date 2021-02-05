//
//  LobbyListView.swift
//  TicTacToe
//
//  Created by Nityananda on 05.02.21.
//

import SwiftUI

struct LobbyListView: View {
    var body: some View {
        List(1..<3) { index in
            cell(index)
        }
    }
}

private extension LobbyListView {
    func cell(_ index: Int) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Tic Tac Toe")
                    .font(.headline)
                Text("1 of 2 online")
            }
            
            Spacer()
            
            Button("Join") {
                print("Joined lobby")
            }
        }
    }
}
