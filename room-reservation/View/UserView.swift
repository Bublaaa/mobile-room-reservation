import SwiftUI

struct UserView: View {
    @ObservedObject var loginViewModel: LoginViewModel  // Use the same instance
    
    var body: some View {
        VStack {
            Text("Welcome, User!")
                .font(.largeTitle)
                .padding()

            Button("Logout") {
                loginViewModel.logout()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(8)
        }
    }
}
