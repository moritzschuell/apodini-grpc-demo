//
//  FieldView.swift
//  TicTacToe
//
//  Created by Nityananda on 08.02.21.
//

import SwiftUI

struct FieldView: View {
    var symbol: Symbol?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color(.lightGray))
                .frame(width: 50, height: 50)
            RoundedRectangle(cornerRadius: 5)
                .stroke()
                .foregroundColor(.black)
                .frame(width: 50, height: 50)

            Text(symbol?.description ?? "")
        }
    }
}

