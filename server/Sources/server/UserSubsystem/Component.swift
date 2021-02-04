//
//  Created by Nityananda on 04.02.21.
//

import Apodini

// MARK: Model

var users: Set<User> = []

struct User: Content, Equatable, Hashable {
    let name: String
}

// MARK: Component

struct UserComponent: Component {
    var content: some Component {
        Group("register") {
            RegisterUser()
        }
    }
}

// MARK: Handler

struct RegisterUser: Handler {
    @Parameter
    var name: String
    
    func handle() throws -> User {
        let user = User(name: name)
        users.insert(user)
        return user
    }
}
