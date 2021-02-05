//
//  LobbyOverview.swift
//  TicTacToe
//
//  Created by Nityananda on 05.02.21.
//

import SwiftUI

struct LobbyOverview: View {
    @State var isShowingLobbyCreation: Bool = false
    
    var body: some View {
        NavigationView {
            LobbyListView()
                .navigationBarTitle("Lobbies")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(trailing: navigationBarButton)
                .sheet(isPresented: $isShowingLobbyCreation) {
                    lobbyCreationSheet
                }
        }
    }
}

private extension LobbyOverview {
    var navigationBarButton: some View {
        Button("New Game") {
            isShowingLobbyCreation = true
        }
    }
    
    var lobbyCreationSheet: some View {
        NavigationView {
            LobbyCreationView()
        }
        .navigationBarItems(leading: cancelButton)
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            isShowingLobbyCreation = false
        }
    }
}
