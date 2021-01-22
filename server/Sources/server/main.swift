//
//  GRPCDemoService
//
//
//  Created by Moritz Schüll 15.01.21.
//

import Apodini
import Foundation

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
            TraditionalGreeter()
                .serviceName("GreetService")
                .rpcName("greetMe")
        }
    }

    var configuration: Configuration {
        if let cert = Bundle.module.path(forResource: "cert", ofType: "pem"),
           let key = Bundle.module.path(forResource: "key", ofType: "pem") {
            HTTP2Configuration()
                .certificate(cert)
                .key(key)
        }
    }
}

try GRPCDemoService.main()
