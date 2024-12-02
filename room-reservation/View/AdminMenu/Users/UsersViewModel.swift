import SwiftUI

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var errorMessage: String? = nil
    
    private let apiHandler = APIHandler.shared
    
    // MARK: - Register New User
    func registerUser(username: String, email: String, role: String, password: String, completion: @escaping (Bool) -> Void) {
        print("Registering username \(username), email \(email), role \(role)")
        
        errorMessage = nil
        
        apiHandler.addUser(username: username, email: email, role: role, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if success {
                    self.fetchUsers() // Refresh users after a successful registration
                    completion(true)
                } else {
                    self.errorMessage = error
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Get All Users
    func fetchUsers() {
        print("Fetching users...")
        
        errorMessage = nil
        
        apiHandler.getUsers { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedUsers):
                    self.users = fetchedUsers
                case .failure(let error):
                    self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Update User Detail
    func updateUser(
        id: Int,
        username: String,
        email: String,
        role: String,
        password: String? = nil,
        password_confirmation: String? = nil
    ) {
        errorMessage = nil
        
        apiHandler.updateUser(
            id: id,
            username: username,
            email: email,
            role: role,
            password: password,
            password_confirmation: password_confirmation
        ) { [weak self] updatedUser in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let updatedUser = updatedUser {
                    if let index = self.users.firstIndex(where: { $0.id == id }) {
                        self.users[index] = updatedUser
                    }
                } else {
                    self.errorMessage = "Failed to update user."
                }
            }
        }
    }
    
    // MARK: - Delete User
    func deleteUser(id: Int, completion: @escaping (Bool) -> Void) {
        errorMessage = nil
        
        apiHandler.deleteUser(id: id) { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if success {
                    self.users.removeAll { $0.id == id }
                    completion(true)
                } else {
                    self.errorMessage = error
                    completion(false)
                }
            }
        }
    }
}
