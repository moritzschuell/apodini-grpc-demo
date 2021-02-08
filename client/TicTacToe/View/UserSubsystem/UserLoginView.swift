//
//  LoginScreen.swift
//  TicTacToe
//
//  Created by Moritz Schüll on 02.02.21.
//

import Foundation
import SwiftUI

struct UserLoginView: View {
    @State
    private var userName: String = ""
    
    @State
    private var didConfirmUserName: Bool = false

    var body: some View {
        if !userName.isEmpty, didConfirmUserName {
            GameView()
                .environmentObject(Model(userName: userName))
        } else {
            VStack(alignment: .center, spacing: 30) {
                Text("Welcome")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("Choose a name:")
                TextField("Your name", text: $userName)
                    .multilineTextAlignment(.center)
                
                Button("Let's go") {
                    didConfirmUserName = true
                }
                .disabled(userName.isEmpty)
            }
            .frame(height: 640)
        }
    }
}
