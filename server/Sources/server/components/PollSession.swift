//
//  PollSession.swift
//  
//
//  Created by Moritz Schüll on 24.01.21.
//

import Foundation
import Apodini

struct FieldState: ResponseTransformable, Codable {
    var position: Int32
    var symbol: String
}

struct GameState: ResponseTransformable, Codable {
    var hasTwoPlayers: Bool
    var contraryName: String
    var nextSymbol: String
    var lastMove: FieldState
}

/// Allows to poll whether the session with the given id has already two players.
struct PollSession: Handler {
    @Parameter
    var sessionId: Int32
    @Parameter
    var userId: Int32

    func buildFieldState(from moves: [Move]) -> [FieldState] {
        moves.map { move in
            FieldState(position: move.position,
                       symbol: move.player.symbol.rawValue)
        }
    }

    func handle() throws -> GameState {
        var fieldState = FieldState(position: 0, symbol: "")

        guard let session = GameSession.OpenSessions
                .first(where: { $0.id == sessionId }) else {
            // no session with given id exists
            return GameState(hasTwoPlayers: false,
                             contraryName: "",
                             nextSymbol: Symbol.cross.rawValue,
                             lastMove: fieldState)
        }

        // session is ready, if second player is present
        guard let second = session.second else {
            return GameState(hasTwoPlayers: false,
                             contraryName: "",
                             nextSymbol: Symbol.cross.rawValue,
                             lastMove: fieldState)
        }

        // there is a second player
        if let last = session.moves.last {
            fieldState = FieldState(position: last.position,
                                    symbol: last.player.symbol.rawValue)
        }
        // find out who is the contrary of the player with the given userId
        var contraryName = session.first.name
        if session.first.id == userId {
            contraryName = second.name
        }

        return GameState(hasTwoPlayers: true,
                         contraryName: contraryName,
                         nextSymbol: try session.next().symbol.rawValue,
                         lastMove: fieldState)
    }
}
