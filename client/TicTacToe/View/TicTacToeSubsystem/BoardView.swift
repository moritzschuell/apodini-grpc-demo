//
//  BoardView.swift
//  TicTacToe
//
//  Created by Nityananda on 05.02.21.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject
    private var model: Model

    @State
    private var gameError: GameError?

    var presentError: Binding<Bool> {
        .init { () -> Bool in
            gameError != nil
        } set: { (newValue) in
            let dismissError = !newValue
            guard dismissError else {
                return
            }
            gameError = nil
        }
    }

    var body: some View {
        HStack {
            ForEach(0..<3) { row in
                VStack {
                    ForEach(0..<3) { column in
                        FieldView(symbol: model.game.board[row * 3 + column])
                            .onTapGesture(count: 1) {
                                set(position: row * 3 + column)
                            }
                    }
                }
            }
        }
        .alert(isPresented: presentError) {
            let message = gameError.map { Text($0.rawValue) }

            return Alert(
                title: Text("Error"),
                message: message
            )
        }
    }
}

private extension BoardView {
    func set(position: Int) {
        do {
            try model.set(position: position)
        } catch {
            gameError = error as? GameError
        }
    }
}
