//
//  Session.swift
//  TicTacToe
//
//  Created by Moritz Schüll on 27.01.21.
//

import Foundation
import NIO
import GRPC

class Session: ObservableObject {
    enum State: Equatable {
        case idle
        case connected(id: Int32, userId: Int32)
    }
    
    private static let address = "localhost"
    private static let port = 8080

    private let group: MultiThreadedEventLoopGroup
    private let channel: ClientConnection
    private let clients: [ObjectIdentifier: GRPCClient]

    var state: State = .idle

    init() {
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.channel = ClientConnection
            .secure(group: group)
            .withTLS(certificateVerification: .none)
            .connect(host: Self.address, port: Self.port)
        
        self.clients = [
            .init(V1SessionjoinServiceClient.self): V1SessionjoinServiceClient(channel: channel),
            .init(V1SessionpollServiceClient.self): V1SessionpollServiceClient(channel: channel),
            .init(V1PlayServiceClient.self): V1PlayServiceClient(channel: channel)
        ]
    }

    subscript<C>(key: C.Type) -> C {
        clients[ObjectIdentifier(key.self)] as! C
    }
    
    func join(userName: String, _ callback: @escaping (RegisteredUserMessage) -> Void) {
        guard state == .idle else {
            preconditionFailure("Session already initialized")
        }

        var joinMessage = JoinSessionMessage()
        joinMessage.userName = userName

        self[V1SessionjoinServiceClient.self]
            .join(joinMessage).response
            .whenComplete { (result) in
                switch result {
                case let .success(message):
                    self.state = .connected(
                        id: message.sessionID,
                        userId: message.userID)
                    callback(message)
                case let .failure(error):
                    print("Could not join the game: \(error)")
                }
            }
    }

    func poll(_ callback: @escaping (GameStateMessage) -> Void) {
        guard case let .connected(id, userId) = state else {
            preconditionFailure("Session not initialized")
        }

        var pollMessage = PollSessionMessage()
        pollMessage.sessionID = id
        pollMessage.userID = userId

        self[V1SessionpollServiceClient.self]
            .poll(pollMessage).response
            .whenComplete { (result) in
                switch result {
                case let .success(message):
                    callback(message)
                case let .failure(error):
                    print("Could not poll the state of the game: \(error)")
                }
            }
    }

    func play(move: Move,
              _ callback: @escaping (Bool) -> Void) {
        guard case let .connected(id, userId) = state else {
            preconditionFailure("Session not initialized")
        }

        var moveMessage = PlayMoveMessage()
        moveMessage.userID = userId
        moveMessage.sessionID = id
        var voluntary = VoluntaryOfInt32Message()
        voluntary.isNone = false
        voluntary.volunteer = Int32(move.position + 1)
        moveMessage.position = voluntary

        self[V1PlayServiceClient.self]
            .playmove(moveMessage).response
            .whenComplete { (result) in
                switch result {
                case let .success(message):
                    callback(message.value)
                case let .failure(_):
                    callback(false)
                }
            }
    }
}
