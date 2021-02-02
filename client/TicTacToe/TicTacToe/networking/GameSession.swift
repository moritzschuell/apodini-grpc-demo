//
//  GameSession.swift
//  TicTacToe
//
//  Created by Moritz Schüll on 27.01.21.
//

import Foundation
import NIO
import GRPC

class GameSession: ObservableObject {
    private static let address = "localhost"
    private static let port = 8080

    private let group: MultiThreadedEventLoopGroup
    private let channel: ClientConnection
    private let sessionClient: V1SessionServiceClient
    private let playClient: V1PlayServiceClient

    var id: Int32?
    var userId: Int32?

    init() {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.channel = ClientConnection
            .secure(group: group)
            .withTLS(certificateVerification: .none)
            .connect(host: Self.address, port: Self.port)
        self.sessionClient = V1SessionServiceClient(channel: channel)
        self.playClient = V1PlayServiceClient(channel: channel)
    }

    func join(userName: String, _ callback: @escaping (JoinResponse) -> Void) {
        precondition(id == nil, "Session already initialized")

        var joinMessage = JoinMessage()
        joinMessage.userName = userName

        let request = sessionClient.join(joinMessage)
        request.response.whenSuccess { joinResponse in
            self.id = joinResponse.sessionID
            self.userId = joinResponse.userID
            callback(joinResponse)
        }
        request.response.whenFailure { error in
            print("Could not join the game: \(error)")
        }
    }

    func poll(_ callback: @escaping (PollResponse) -> Void) {
        precondition(id != nil && userId != nil, "Session not initialized")

        var pollMessage = PollMessage()
        pollMessage.sessionID = id!
        pollMessage.userID = userId!

        let request = sessionClient.poll(pollMessage)
        request.response.whenSuccess { pollResponse in
            callback(pollResponse)
        }
        request.response.whenFailure { error in
            print("Could not poll the state of the game: \(error)")
        }
    }

    func play(move: Move,
              _ callback: @escaping (Bool) -> Void) {
        precondition(id != nil && userId != nil, "Session not initialized")

        var moveMessage = MoveMessage()
        moveMessage.userID = userId!
        moveMessage.sessionID = id!
        moveMessage.position = Int32(move.position)

        let request = playClient.playmove(moveMessage)
        request.response.whenSuccess { moveResponse in
            callback(moveResponse.success)
        }
        request.response.whenFailure { error in
            callback(false)
        }
    }
}
