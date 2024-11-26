import SwiftUI

struct ContentView: View {
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if loginViewModel.isLoggedIn {
                    // Navigating based on role
                    if loginViewModel.user?.role == "admin" {
                        AdminView(loginViewModel: loginViewModel)
                    } else {
                        UserView(loginViewModel: loginViewModel)
                    }
                } else {
                    LoginView(loginViewModel: loginViewModel)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
