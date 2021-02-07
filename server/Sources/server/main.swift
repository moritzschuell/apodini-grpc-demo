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
        Group("session") {
            SessionComponent()
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
