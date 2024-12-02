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
    
    // MARK: - Login Function
    func login(username: String, password: String) {
        print("Login attempt for username: \(username)")
        isLoading = true
        errorMessage = nil
        
        apiHandler.login(username: username, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if success, let user = self?.apiHandler.user, let token = self?.apiHandler.token {
                    self?.isLoggedIn = true
                    self?.user = user
                    self?.saveToken(token)
                    self?.saveUserId(user.id)
                } else if let error = error {
                    self?.errorMessage = error
                }
            }
        }
    }

    // MARK: - Logout Function
    func logout() {
        print("Logging out...")
        apiHandler.logout { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.clearSession()
                } else if let error = error {
                    self?.errorMessage = error
                }
            }
        }
    }

    // MARK: - Helpers
    private func saveToken(_ token: String) {
        print("Saving token: \(token)")
        UserDefaults.standard.set(token, forKey: "tokenKey")
    }
    
    private func saveUserId(_ id: Int) {
        print("Saving User ID: \(id)")
        UserDefaults.standard.set(id, forKey: "userId")
    }
    
    private func loadToken() -> String? {
        return UserDefaults.standard.string(forKey: "tokenKey")
    }
    
    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: "tokenKey")
        UserDefaults.standard.removeObject(forKey: "userId")
        self.user = nil
        self.isLoggedIn = false
    }
    
    private func checkLoginStatus() {
        guard let token = loadToken(), !token.isEmpty else {
            isLoggedIn = false
            return
        }
        
        let userId = UserDefaults.standard.integer(forKey: "userId")
        guard userId != 0 else {
            isLoggedIn = false
            return
        }
        
        print("Token found: \(token). Checking user status...")
        apiHandler.getUser(id: userId) { [weak self] user in
            DispatchQueue.main.async {
                if let user = user {
                    self?.user = user
                    self?.isLoggedIn = true
                } else {
                    self?.clearSession()
                }
            }
        }
    }
}
