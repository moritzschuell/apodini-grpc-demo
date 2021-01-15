//
//  GRPCDemoService
//
//
//  Created by Moritz Schüll 15.01.21.
//

import Apodini

struct GRPCDemoService: Apodini.WebService {
    struct TraditionalGreeter: Handler {
        @Parameter var gender: String
        @Parameter var surname: String = ""
        @Parameter var name: String?

        @Environment(\.connection) var connection: Connection

        func handle() -> Response<String> {
            print(connection.state)
            if connection.state == .end {
                return .final("This is the end")
            }

            if let firstName = name {
                return .send("Hi, \(firstName)!")
            } else {
                return .send("Hello, \(gender == "male" ? "Mr." : "Mrs.") \(surname)")
            }
        }
    }

    var content: some Component {
        Group("swift") {
            Text("Hello World! 👋")
                .serviceName("GreetService")
                .rpcName("greetMe")
        }
    }
}

try GRPCDemoService.main()
