//
//  PlayMove.swift
//  
//
//  Created by Moritz Schüll on 24.01.21.
//

import Foundation
import Apodini

/// Allows the user to play a move.
/// Returns TRUE if the move was played successfully, false otherwise
struct PlayMove: Handler {
    @Parameter
    var userId: Int32
    @Parameter
    var sessionId: Int32
    @Parameter
    var position: Int32

    func handle() throws -> Bool {
        guard let session = GameSession.OpenSessions.first(where: { $0.id == sessionId }) else {
            // specified session does not exist
            return false
        }

        let player = try session.next()
        if player.id == userId {
            // it's the players turn
            let move = Move(player: player, position: position - 1)
            return try session.play(move: move)
        }
        return false
    }
}
