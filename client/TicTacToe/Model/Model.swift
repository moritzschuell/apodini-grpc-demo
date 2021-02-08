//
//  Model.swift
//  TicTacToe
//
//  Created by Nityananda on 03.02.21.
//

import Foundation

class Model: ObservableObject {
    @Published var game = Game(moves: [])

    @Published var player: Player?
    @Published var ready: Bool = false
    @Published var contraryName: String?

    private let session: Session = .init()
    private let userName: String

    init(userName: String) {
        self.userName = userName
    }

    func joinGame() {
        session.join(userName: userName) { joinResponse in
            if let symbol = Symbol(rawValue: joinResponse.symbol) {
                DispatchQueue.main.async() {
                    self.player = Player(symbol: symbol,
                                         name: self.userName)
                }
            }
        }
    }

    func pollGameState() {
        session.poll { state in
            DispatchQueue.main.async() {
                if let symbol = Symbol(rawValue: state.lastMove.symbol) {
                    let lastMove = Move(player: symbol, position: Int(state.lastMove.position))
                    self.game.moves.append(lastMove)
                }

                self.ready = state.hasTwoPlayers_p && state.nextSymbol == self.player?.symbol.rawValue
                self.contraryName = state.contraryName
            }
        }
    }
}

extension Model {
    func reset() {
        game = Game(moves: [])
        joinGame()
    }
}

enum GameError: String, Error {
    case positionNotAvailable
}

extension Model {
    func set(position: Int) throws {
        guard game.availablePositions.contains(position) else {
            throw GameError.positionNotAvailable
        }

        let move = Move(player: game.next, position: position)
        session.play(move: move) { success in
            if success {
                DispatchQueue.main.async() {
                    self.game = Game(moves: self.game.moves + [move])
                }
            }
        }
    }
}
