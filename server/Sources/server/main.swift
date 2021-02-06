//
//  GRPCDemoService
//
//
//  Created by Moritz Schüll 15.01.21.
//

import Foundation
import Apodini
import ApodiniGRPC
import ApodiniProtobuffer

struct GRPCDemoService: Apodini.WebService {
    var content: some Component {
//        Group("user") {
//            UserComponent()
//        }
//        Group("lobby") {
//            LobbyComponent()
//        }
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
        ExporterConfiguration()
            .exporter(GRPCInterfaceExporter.self)
            .exporter(ProtobufferInterfaceExporter.self)
        
        if let cert = Bundle.module.path(forResource: "cert", ofType: "pem"),
           let key = Bundle.module.path(forResource: "key", ofType: "pem") {
            HTTP2Configuration()
                .certificate(cert)
                .key(key)
        }
    }
}

try GRPCDemoService.main()
