//
//  File.swift
//  
//
//  Created by Nityananda on 07.02.21.
//

import Apodini

struct SessionComponent: Component {
    var content: some Component {
        Group("join") {
            JoinSession()
                .rpcName("join")
        }
        
        Group("poll") {
            PollSession()
                .rpcName("poll")
        }
    }
}
