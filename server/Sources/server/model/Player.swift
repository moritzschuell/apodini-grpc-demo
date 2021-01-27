//
//  Player.swift
//  
//
//  Created by Nityananda.
//

import Foundation

enum Symbol: String {
    case circle = "O"
    case cross = "X"

    static prefix func ! (symbol: Symbol) -> Symbol {
        switch symbol {
        case .circle: return .cross
        case .cross: return .circle
        }
    }
}

struct Player {
    let symbol: Symbol
    let id: Int32
    let name: String

    public static var RegisteredPlayers: [Player] = []
}

extension Player: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
