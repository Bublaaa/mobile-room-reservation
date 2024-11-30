import SwiftUI

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let apiHandler = APIHandler.shared
    
    func fetchUsers() {
        print("Fetching users...")
        apiHandler.getUsers { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedUsers):
                    //                    print("Successfully fetched users: \(fetchedUsers)")
                    self.users = fetchedUsers
                    self.errorMessage = nil
                case .failure(let error):
                    print("Failed to fetch users: \(error.localizedDescription)")
                    self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func updateUser(
        id: Int,
        username: String,
        email: String,
        role: String,
        password: String? = nil,
        password_confirmation: String? = nil
    ) {
        print("Updating user with username: \(username)")
        
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
}
