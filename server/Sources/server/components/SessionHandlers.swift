//
//  SessionHandlers.swift
//  
//
//  Created by Moritz Schüll on 24.01.21.
//

import Foundation
import Apodini

struct RegisteredUser: ResponseTransformable, Codable {
    var userId: Int32
    var sessionId: Int32
    var symbol: String
}

struct FieldState: ResponseTransformable, Codable {
    var position: Int32
    var symbol: String
}

struct GameState: ResponseTransformable, Codable {
    var hasTwoPlayers: Bool
    var nextSymbol: String
    var lastMove: FieldState
}

/// Allows a user to join a session.
/// The user has to provide his/her name.
/// If no session is waiting for a new player, a new session will be opened.
/// The id of the session that the user joined will be returned.
struct JoinSession: Handler {
    @Parameter
    var userName: String

    func registerPlayer(symbol: Symbol) -> Player {
        let newPlayerId = Player.RegisteredPlayers
            .map { $0.id }
            .max() ?? 0
        let player = Player(symbol: symbol, id: newPlayerId + 1, name: userName)
        Player.RegisteredPlayers.append(player)
        return player
    }

    func handle() -> RegisteredUser {
        if let session = GameSession.OpenSessions
            .first(where: { $0.second == nil }) {
            // there is an open session
            let player = registerPlayer(symbol: !session.first.symbol)
            session.second = player
            return RegisteredUser(userId: player.id,
                                  sessionId: session.id,
                                  symbol: player.symbol.rawValue)
        } else {
            // there is no other session waiting
            let newSessionId = GameSession.OpenSessions
                .map { $0.id }
                .max() ?? 0

            let player = registerPlayer(symbol: .cross)
            let session = GameSession(id: newSessionId + 1, first: player)
            GameSession.OpenSessions.append(session)
            return RegisteredUser(userId: player.id,
                                  sessionId: session.id,
                                  symbol: player.symbol.rawValue)
        }
    }
}

/// Allows to poll whether the session with the given id has already two players.
struct PollSession: Handler {
    @Parameter
    var sessionId: Int32

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
                             nextSymbol: Symbol.cross.rawValue,
                             lastMove: fieldState)
        }

        // session is ready, if second player is present
        if session.second == nil {
            return GameState(hasTwoPlayers: false,
                             nextSymbol: Symbol.cross.rawValue,
                             lastMove: fieldState)
        } else {
            if let last = session.moves.last {
                fieldState = FieldState(position: last.position,
                                        symbol: last.player.symbol.rawValue)
            }
            return GameState(hasTwoPlayers: true,
                             nextSymbol: try session.next().symbol.rawValue,
                             lastMove: fieldState)
        }
    }
}
