//
//  Created by Nityananda on 04.02.21.
//

import Apodini

// MARK: Model

var lobbies: Set<Lobby> = []

struct Lobby: Content, Equatable, Hashable {
    let id: Int32
}

extension Lobby: Volunteer {
    static var refuse: Lobby {
        .init(id: .max)
    }
}

// MARK: Component

struct LobbyComponent: Component {
    var content: some Component {
        Group("index") {
            LobbyIndex()
        }
        Group("create") {
            LobbyCreate()
        }
        Group("join") {
            LobbyJoin()
        }
    }
}

// MARK: Handlers

struct LobbyIndex: Handler {
    func handle() throws -> [Lobby] {
        Array(lobbies)
    }
}

struct LobbyCreate: Handler {
    func handle() throws -> Lobby {
        let nextId = lobbies
            .map(\.id)
            .sorted()
            .last ?? 0
        
        return .init(id: nextId)
    }
}

struct LobbyJoin: Handler {
    @Parameter
    var id: Int32
    
    func handle() throws -> Voluntary<Lobby> {
        guard let lobby = lobbies.first(where: { lobby in
            lobby.id == id
        }) else {
            return .nothing
        }
        
        return .just(lobby)
    }
}

extension Voluntary: ResponseTransformable where V == Lobby {}
