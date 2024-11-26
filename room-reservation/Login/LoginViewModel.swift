import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    private let apiHandler = APIHandler.shared
    private let tokenKey = "authToken"
    
    init() {
        checkLoginStatus()
    }
    
    func login(username: String, password: String) {
        print("Login attempt for username: \(username)")  // Debugging print
        
        isLoading = true
        errorMessage = nil
        
        apiHandler.login(username: username, password: password)
        
        // Check the result after login attempt
        if let token = apiHandler.token, let user = apiHandler.user {
            print("Login successful. Token: \(token)")  // Debugging print
            self.isLoggedIn = true
            self.user = user
            self.saveToken(token)
        } else if let error = apiHandler.errorMessage {
            print("Login failed. Error: \(error)")  // Debugging print
            self.errorMessage = error
        }
        
        isLoading = false
    }
    
    private func saveToken(_ token: String) {
        print("Saving token: \(token)")  // Debugging print
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    private func loadToken() -> String? {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        print("Loaded token: \(String(describing: token))")  // Debugging print
        return token
    }
    
    private func checkLoginStatus() {
        if let token = loadToken() {
            print("Token found: \(token). User is logged in.")  // Debugging print
            self.isLoggedIn = true
        } else {
            print("No token found. User is not logged in.")  // Debugging print
        }
    }
    
    // Logout function
    func logout() {
        print("Logging out...")  // Debugging print
        UserDefaults.standard.removeObject(forKey: tokenKey)
        
        self.user = nil
        self.isLoggedIn = false
        
        print("User logged out. Token removed.")  // Debugging print
        apiHandler.logout()
    }
}
