import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoading = false
    
    private let apiHandler = APIHandler.shared
    
    init() {
        checkLoginStatus()
    }
    
    func login(username: String, password: String) {
        print("Login attempt for username: \(username)")
        
        errorMessage = nil
        
        apiHandler.login(username: username, password: password) { [weak self] success, error in
            guard let self = self else { return }
            if success, let user = self.apiHandler.user, let token = self.apiHandler.token {
//                print("Login successful. Token: \(token)")
                self.isLoggedIn = true
                self.user = user
//                print(user)
                self.saveToken(token)
                self.saveUserId(user.id)
            } else if let error = error {
//                print("Login failed. Error: \(error)")
                self.errorMessage = error
            }
        }
    }

    private func saveToken(_ token: String) {
        print("Saving token: \(token)")
        UserDefaults.standard.set(token, forKey: "tokenKey")
    }
    private func saveUserId(_ id: Int){
        print("Saving User Id : \(id)")
        UserDefaults.standard.set(id, forKey: "userId")
    }
    
    private func loadToken() -> String? {
        let token = UserDefaults.standard.string(forKey: "tokenKey")
//        print("Loaded token: \(String(describing: token))")
        return token
    }
    
    private func checkLoginStatus() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        if let token = loadToken() {
            print("Token found: \(token). Checking user status...")
            apiHandler.getUser(id: userId) { [weak self] user in
                guard let self = self else { return }
                if let user = user {
                    print("User fetched successfully: \(user)")
                    DispatchQueue.main.async {
                        self.user = user
                        self.isLoggedIn = true
                    }
                } else {
                    print("Failed to fetch user or invalid token.")
                    DispatchQueue.main.async {
                        self.isLoggedIn = false
                        self.logout()
                    }
                }
            }
        } else {
//            print("No token found. User is not logged in.")
            self.isLoggedIn = false
        }
    }

    
    // Logout function
    func logout() {
        print("Logging out...")  // Debugging print
        UserDefaults.standard.removeObject(forKey: "tokenKey")
        UserDefaults.standard.removeObject(forKey: "userId")
        self.user = nil
        self.isLoggedIn = false
        
//        print(UserDefaults.standard.value(forKey: "userId"))
//        print("User logged out. Token removed.")
        apiHandler.logout()
    }
}
