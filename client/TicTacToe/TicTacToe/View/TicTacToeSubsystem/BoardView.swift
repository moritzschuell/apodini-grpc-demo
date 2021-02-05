//
//  BoardView.swift
//  TicTacToe
//
//  Created by Nityananda on 05.02.21.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var model: Model

    @State var gameError: GameError?

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
        VStack(alignment: .center, spacing: 50) {
            infoText

            if model.ready {
                gameBoard
                    .disabled(model.game.winner != nil)
                    .alert(isPresented: presentError) {
                        let message = gameError.map { Text($0.rawValue) }

                        return Alert(
                            title: Text("Error"),
                            message: message
                        )
                    }
            } else if model.game.winner == .none {
                ProgressView()
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { t in
                            model.pollGameState()
                        }
                    }
            }

            Button {
                model.reset()
            } label: {
                Text("New Game")
            }

        }
        .onAppear(perform: model.joinGame)
    }
}

private extension BoardView {
    @ViewBuilder
    var infoText: some View {
        if model.game.draw {
            Text("It is a draw")
                .foregroundColor(.orange)
        } else {
            switch model.game.winner {
            case .none:
                if model.game.next == model.player?.symbol {
                    Text("You are next")
                } else {
                    Text(String(describing: model.game.next) +
                            " is next\nWaiting for \(model.contraryName ?? "other player")")
                        .multilineTextAlignment(.center)
                }
            case let .some(winner):
                if winner.rawValue == model.player?.symbol.rawValue {
                    Text("You won")
                        .foregroundColor(.green)
                } else {
                    Text("\(model.contraryName ?? "The other player") won")
                        .foregroundColor(.green)
                }
            }
        }
    }
}

private extension BoardView {
    var gameBoard: some View {
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
    }

    func set(position: Int) {
        do {
            try model.set(position: position)
        } catch {
            gameError = error as? GameError
        }
    }
}

struct FieldView: View {
    @EnvironmentObject var model: Model

    var symbol: Symbol?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color(.lightGray))
                .frame(width: 50, height: 50)
            RoundedRectangle(cornerRadius: 5)
                .stroke()
                .foregroundColor(.black)
                .frame(width: 50, height: 50)

            Text(symbol?.description ?? "")
        }
    }
}

