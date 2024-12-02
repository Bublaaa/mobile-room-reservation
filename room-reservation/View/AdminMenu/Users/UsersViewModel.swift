import SwiftUI

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let apiHandler = APIHandler.shared
    
    //MARK: - Register New User
    func registerUser(username: String, email: String, role: String, password: String, completion: @escaping (Bool) -> Void){
        print("Registering username \(username) email \(email), role \(role), password \(password)")
        apiHandler.addUser(username: username, email: email, role: role, password: password) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                // Optionally refresh the user list
                self.fetchUsers()
                completion(true)
            } else {
                self.errorMessage = error
                completion(false)
            }
        }
        self.fetchUsers()
    }
    
    //MARK: - Get All Users
    func fetchUsers() {
        print("Fetching users...")
        apiHandler.getUsers { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedUsers):
                    self.users = fetchedUsers
                    self.errorMessage = nil
                case .failure(let error):
                    print("Failed to fetch users: \(error.localizedDescription)")
                    self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                }
            }
        }
    }
    
    //MARK: - Update User Detail
    func updateUser(
        id: Int,
        username: String,
        email: String,
        role: String,
        password: String? = nil,
        password_confirmation: String? = nil
    ) {
        
        apiHandler.updateUser(
            id: id,
            username: username,
            email: email,
            role: role,
            password: password,
            password_confirmation: password_confirmation
        ) { [weak self] updatedUser in
            DispatchQueue.main.async {
                if let updatedUser = updatedUser {
                    if let index = self?.users.firstIndex(where: { $0.id == id }) {
                        self?.users[index] = updatedUser
                    }
                } else {
                    self?.errorMessage = "Failed to update user."
                }
            }
        }
    }
    //MARK: - Delete User
    func deleteUser(id: Int, completion: @escaping (Bool) -> Void){
        apiHandler.deleteUser(id: id) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                // Optionally refresh the user list
                self.fetchUsers()
                completion(true)
            } else {
                self.errorMessage = error
                completion(false)
            }
        }
        self.fetchUsers()
    }
}
