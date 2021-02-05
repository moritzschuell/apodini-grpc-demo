//
//  LoginScreen.swift
//  TicTacToe
//
//  Created by Moritz Schüll on 02.02.21.
//

import Foundation
import SwiftUI

final class LoginView: View {
    @Published var userName: String?

    var body: some View {
        if let userName = userName {
            BoardView()
                .environmentObject(Model(userName: userName))
        } else {

        }
    }
}
