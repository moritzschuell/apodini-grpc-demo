//
//  LoginScreen.swift
//  TicTacToe
//
//  Created by Moritz Schüll on 02.02.21.
//

import Foundation
import SwiftUI

struct UserLoginView: View {
    @State var userName: String = ""
    @State var okPressed: Bool = false

    var body: some View {
        if userName != "", okPressed {
            BoardView()
                .environmentObject(Model(userName: userName))
        } else {
            VStack {
                Text("Welcome")
                    .font(.system(size: 40))
                    .bold()
            }
            VStack(alignment: .center, spacing: 30) {
                Text("User name:")
                TextField("Your name", text: $userName)
                    .multilineTextAlignment(.center)
                Button("Let's play") {
                    okPressed = true
                }
                .disabled(userName == "")
            }
            .frame(width: 150, height: 500)
        }
    }
}
