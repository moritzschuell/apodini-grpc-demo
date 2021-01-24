//
//  ContentView.swift
//  TicTacToe
//
//  Created by Moritz Schüll on 22.01.21.
//

import SwiftUI
import NIO
import GRPC

enum Player: String {
    case circle = "O"
    case cross = "X"

    static prefix func ! (player: Player) -> Player {
        switch player {
        case .circle: return .cross
        case .cross: return .circle
        }
    }
}

extension Player: CustomStringConvertible {
    var description: String { rawValue }
}

struct Move {
    let player: Player
    let position: Int
}

struct Game {
    let first: Player = .cross
    let moves: [Move]
}

extension Game {
    var next: Player {
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

    var winner: Player? {
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
    var board: [Player?] {
        let board = [Player?](repeating: nil, count: 9)

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

class Model: ObservableObject {
    @Published var game = Game(moves: [])
}

extension Model {
    func reset() {
        game = Game(moves: [])
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
        game = Game(moves: game.moves + [move])
    }
}

struct Board: View {
    @EnvironmentObject var model: Model

    @State var gameError: GameError?

    var presentError: Binding<Bool> {
        .init { () -> Bool in
            gameError != nil
        } set: { (newValue) in
            let dismissError = !newValue
            guard dismissError else {
                return
            }
            gameError = nil
        }
    }

    var body: some View {
        VStack {
            infoText

            gameBoard
                .disabled(model.game.winner != nil)
                .alert(isPresented: presentError) {
                    let message = gameError.map { Text($0.rawValue) }

                    return Alert(
                        title: Text("Error"),
                        message: message
                    )
                }

            Button {
                model.reset()
            } label: {
                Text("New Game")
            }

        }
    }
}

private extension Board {
    @ViewBuilder
    var infoText: some View {
        if model.game.draw {
            Text("It is a draw")
                .foregroundColor(.orange)
        } else {
            switch model.game.winner {
            case .none:
                Text(String(describing: model.game.next) + " is next")
            case let .some(winner):
                Text("\(winner.rawValue) won")
                    .foregroundColor(.green)
            }
        }
    }
}

private extension Board {
    var gameBoard: some View {
        HStack {
            ForEach(0..<3) { row in
                VStack {
                    ForEach(0..<3) { column in
                        Field(player: model.game.board[row * 3 + column])
                            .onTapGesture(count: 1) {
                                set(position: row * 3 + column)
                            }
                    }
                }
            }
        }
    }

    func set(position: Int) {
        do {
            try model.set(position: position)
        } catch {
            gameError = error as? GameError
        }
    }
}

struct Field: View {
    @EnvironmentObject var model: Model

    let player: Player?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color(.lightGray))
                .frame(width: 50, height: 50)
            RoundedRectangle(cornerRadius: 5)
                .stroke()
                .foregroundColor(.black)
                .frame(width: 50, height: 50)

            Text(player?.description ?? "")
        }
    }
}

struct ContentView: View {
    func startUp() {
        let address = "localhost"
        let port = 8080

        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer {
            try! group.syncShutdownGracefully()
        }

        let channel = ClientConnection
            .secure(group: group)
            .withTLS(certificateVerification: .none)
            .connect(host: address, port: port)

        let sessionClient = V1SessionServiceClient(channel: channel)

        var joinMessage = JoinMessage()
        joinMessage.userID = 15
        joinMessage.userName = "Moritz"

        let request = sessionClient.join(joinMessage)
        request.response.whenComplete() { result in
            switch result {
            case let .success(response):
                print("Received response: \(response)")
            case let .failure(error):
                print("Error during request: \(error)")
            }
        }

        do {
            try request.status.wait()
        } catch {

        }
    }

    var body: some View {
        Board()
            .environmentObject(Model())
            .onAppear(perform: startUp)
    }
}
