//
//  File.swift
//  
//
//  Created by Moritz Schüll on 02.02.21.
//

import Foundation
import Apodini

struct RegisteredUser: ResponseTransformable, Codable {
    var userId: Int32
    var sessionId: Int32
    var symbol: String
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
