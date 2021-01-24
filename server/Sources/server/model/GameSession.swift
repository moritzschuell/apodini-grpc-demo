//
//  GameSession.swift
//  
//
//  Created by Moritz Schüll on 24.01.21.
//

import Foundation

enum SessionError: Error {
    case noPartner
}

enum Field {
    case unset
    case cross
    case circle
}

struct GameSession {
    let id: Int
    var field: [Field]
    let first: Player
    var second: Player? = nil
    var moves: [Move]

    static var OpenSessions: [GameSession] = []
    static var SessionCounter: Int = 0

    init(id: Int, first: Player) {
        field = [
            .unset, .unset, .unset,
            .unset, .unset, .unset,
            .unset, .unset, .unset
        ]
        moves = []
        self.first = first
        self.id = id
    }

    func next() throws -> Player {
        guard let second = second else {
            throw SessionError.noPartner
        }

        if moves.last?.player == first {
            return second
        }
        return first
    }

    /// Playes the given move in the current session
    /// - returns: FALSE if the move is not valid, TRUE if it has been played successfully.
    mutating func play(move: Move) throws -> Bool {
        // validate move
        if move.position >= field.count || move.position < 0 {
            // field does not exist
            return false
        } else if field[move.position] != .unset {
            // field already blocked
            return false
        } else if try next() != move.player {
            // it's not the player's turn
            return false
        }
        // move is valid
        moves.append(move)
        return true
    }
}
