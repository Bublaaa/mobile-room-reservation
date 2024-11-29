import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            // Username TextField
            TextField("Username", text: $username)
                .padding()
                .cornerRadius(10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            // Login Button or Loading Spinner
            Button("Login") {
                loginViewModel.login(username: username, password: password)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            
            // Error Message
            if let errorMessage = loginViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}
