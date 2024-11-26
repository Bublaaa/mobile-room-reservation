import SwiftUI

struct UserView: View {
    @ObservedObject var loginViewModel: LoginViewModel  // Use the same instance
    
    var body: some View {
        HStack {
            Text("User Dashboard")
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
