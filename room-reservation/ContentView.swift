import SwiftUI

struct ContentView: View {
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if loginViewModel.isLoggedIn {
                    if loginViewModel.user?.role == "admin" {
                        AdminView(loginViewModel: loginViewModel)
                    } else {
                        UserView(loginViewModel: loginViewModel)
                            .navigationTitle("Booker Menu")
                            .toolbar {
                                ToolbarItemGroup(placement: .topBarTrailing) {
                                    Button("Log out") {
                                        loginViewModel.logout()
                                    }
                                    .foregroundColor(.red)
                                }
                            }
                    }
                } else {
                    LoginView(loginViewModel: loginViewModel)
                        .navigationTitle("Login")
                }
            }
        }
    }
}
