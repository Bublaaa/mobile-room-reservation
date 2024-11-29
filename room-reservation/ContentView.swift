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
                            .navigationTitle("Admin Menu")
                    } else {
                        UserView(loginViewModel: loginViewModel)
                            .navigationTitle("Booker Menu")
                    }
                } else {
                    LoginView(loginViewModel: loginViewModel)
                        .navigationTitle("Login")
                }
            }
        }
    }
}
