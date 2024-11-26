import SwiftUI

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let apiHandler = APIHandler.shared
    
    func fetchUsers() {
        print("Fetching users...")  // Debugging print
        
        isLoading = true
        apiHandler.getUsers { result in
            switch result {
            case .success(let fetchedUsers):
                print("Successfully fetched users: \(fetchedUsers)")  // Debugging print
                self.users = fetchedUsers
                self.isLoading = false
            case .failure(let error):
                print("Failed to fetch users: \(error)")  // Debugging print
                self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
