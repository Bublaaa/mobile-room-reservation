//
//  UserView.swift
//  room-reservation
//
//  Created by Krisna Yanuardi on 23/11/24.
//

import SwiftUI

struct UserView: View {
    var body: some View {
            VStack {
                Text("Welcome, User!")
                    .font(.largeTitle)
                    .padding()
                
                Text("This is the user dashboard.")
                    .foregroundColor(.gray)
            }
            .navigationTitle("User Screen")
    }
}

#Preview {
    UserView()
}
