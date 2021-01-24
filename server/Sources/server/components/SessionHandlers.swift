//
//  SessionHandlers.swift
//  
//
//  Created by Moritz Schüll on 24.01.21.
//

import Foundation
import Apodini

/// Allows a user to join a session.
/// The user has to provide his/her user id.
/// If no session is waiting for a new player, a new session will be opened.
/// The id of the session that the user joined will be returned.
struct JoinSession: Handler {
    @Parameter
    var userId: Int32
    @Parameter
    var userName: String

    func handle() -> Int32 {
        let session = GameSession.OpenSessions
            .filter { $0.second != nil }
            .first

        if var session = session {
            // there is an open session
            let player = Player(symbol: !session.first.symbol, id: userId, name: userName)
            session.second = player
            return session.id
        } else {
            // there is no other session waiting
            let player = Player(symbol: .cross, id: userId, name: userName)
            let session = GameSession(id: GameSession.SessionCounter, first: player)
            GameSession.SessionCounter += 1
            return session.id
        }
    }
}

/// Allows to poll whether the session with the given id has already two players.
struct PollSession: Handler {
    @Parameter
    var sessionId: Int32

    func handle() -> Bool {
        guard let session = GameSession.OpenSessions
                .first(where: { $0.id == sessionId }) else {
            // no session with given id exists
            return false
        }
        // session is ready, if second player is present
        return session.second != nil
    }
}
