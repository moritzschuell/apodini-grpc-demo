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

enum Field: String {
    case unset
    case cross
    case circle
}

class GameSession {
    let id: Int32
    var field: [Field]
    let first: Player
    var second: Player? = nil
    var moves: [Move]

    static var EmptyField: [Field] = [
        .unset, .unset, .unset,
        .unset, .unset, .unset,
        .unset, .unset, .unset
    ]
    static var OpenSessions: [GameSession] = []
    static var SessionCounter: Int32 = 0

    init(id: Int32, first: Player) {
        field = Self.EmptyField
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
    func play(move: Move) throws -> Bool {
        // validate move
        if move.position >= field.count || move.position < 0 {
            // field does not exist
            return false
        } else if field[Int(move.position)] != .unset {
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
