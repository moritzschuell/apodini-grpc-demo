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
    private let clients: [ObjectIdentifier: GRPCClient]

    var id: Int32?
    var userId: Int32?

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
        precondition(id == nil, "Session already initialized")

        var joinMessage = JoinSessionMessage()
        joinMessage.userName = userName

        let request = self[V1SessionjoinServiceClient.self].join(joinMessage)
        request.response.whenSuccess { joinResponse in
            self.id = joinResponse.sessionID
            self.userId = joinResponse.userID
            callback(joinResponse)
        }
        request.response.whenFailure { error in
            print("Could not join the game: \(error)")
        }
    }

    func poll(_ callback: @escaping (GameStateMessage) -> Void) {
        precondition(id != nil && userId != nil, "Session not initialized")

        var pollMessage = PollSessionMessage()
        pollMessage.sessionID = id!
        pollMessage.userID = userId!

        let request = self[V1SessionpollServiceClient.self].poll(pollMessage)
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

        var moveMessage = PlayMoveMessage()
        moveMessage.userID = userId!
        moveMessage.sessionID = id!
        var voluntary = VoluntaryOfInt32Message()
        voluntary.isNone = false
        voluntary.volunteer = Int32(move.position + 1)
        moveMessage.position = voluntary

        let request = self[V1PlayServiceClient.self].playmove(moveMessage)
        request.response.whenSuccess { moveResponse in
            callback(moveResponse.value)
        }
        request.response.whenFailure { error in
            callback(false)
        }
    }
}
