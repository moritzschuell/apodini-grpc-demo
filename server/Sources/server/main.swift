//
//  GRPCDemoService
//
//
//  Created by Moritz Schüll 15.01.21.
//

import Apodini
import Foundation

struct GRPCDemoService: Apodini.WebService {
    var content: some Component {
        Group("session") {
            JoinSession()
                .operation(.create)
                .rpcName("join")
            PollSession()
                .operation(.read)
                .rpcName("poll")
        }
        Group("play") {
            PlayMove()
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
