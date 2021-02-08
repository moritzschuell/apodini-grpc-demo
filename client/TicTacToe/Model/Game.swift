//
//  Game.swift
//  TicTacToe
//
//  Created by Nityananda on 08.02.21.
//

struct Player {
    var symbol: Symbol
    var name: String
}

enum Symbol: String {
    case circle = "O"
    case cross = "X"

    static prefix func ! (player: Symbol) -> Symbol {
        switch player {
        case .circle: return .cross
        case .cross: return .circle
        }
    }
}

extension Symbol: CustomStringConvertible {
    var description: String { rawValue }
}

extension Player: CustomStringConvertible {
    var description: String {
        "\(name), playing \(symbol)"
    }
}

struct Move {
    let player: Symbol
    let position: Int
}

struct Game {
    var first: Symbol = .cross
    var moves: [Move]
}

extension Game {
    var next: Symbol {
        guard let lastPlayer = moves.last?.player else {
            return first
        }

        return !lastPlayer
    }

    var availablePositions: Set<Int> {
        Set(0...8).subtracting(
            moves.map(\.position)
        )
    }

    var winner: Symbol? {
        let length = (0...2)

        let rows = (0...2).map { row in
            length.map { index in row * 3 + index }
        }

        let columns = (0...2).map { column in
            length.map { index in column + index * 3 }
        }

        let crissCross = [[0, 4, 8], [2, 4, 6]]

        let chances = Set(
            (rows + columns + crissCross).map(Set.init)
        )

        precondition(chances.count == 8)

        let circle = Set(
            moves
                .filter { $0.player == .circle }
                .map(\.position)
        )

        let cross = Set(
            moves
                .filter { $0.player == .cross }
                .map(\.position)
        )

        if chances.contains(where: { $0.isSubset(of: circle) }) {
            return .circle
        }

        if chances.contains(where: { $0.isSubset(of: cross) }) {
            return .cross
        }

        return nil
    }

    var draw: Bool {
        winner == nil && moves.count == 9
    }
}

extension Game {
    var board: [Symbol?] {
        let board = [Symbol?](repeating: nil, count: 9)

        return moves.reduce(into: board) { (result, move) in
            result[move.position] = move.player
        }
    }
}

extension Game: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        let ranges = [
            0...2,
            3...5,
            6...8
        ]

        return ranges
            .map { range in
                board.map { player in
                    player?.description ?? "_"
                }[range]
            }
            .map { $0.joined() }
            .joined(separator: "\n")
    }
}
