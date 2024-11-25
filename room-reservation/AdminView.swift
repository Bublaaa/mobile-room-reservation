//
//  AdminView.swift
//  room-reservation
//
//  Created by Krisna Yanuardi on 23/11/24.
//

import SwiftUI

struct AdminView: View {
    var body: some View {
        VStack {
            Text("Welcome, Admin!")
                .font(.largeTitle)
                .padding()
            
            Text("This is the admin panel.")
                .foregroundColor(.gray)
        }
        .navigationTitle("Admin Screen")
    }
}
#Preview {
    AdminView()
}
