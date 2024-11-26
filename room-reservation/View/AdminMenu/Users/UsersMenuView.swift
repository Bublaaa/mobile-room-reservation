import SwiftUI

struct UsersMenuView: View {
    @StateObject private var usersViewModel = UsersViewModel()
    @State private var selectedUser: User? // Track the selected user
    
    var body: some View {
        VStack {
            Text("Users Section")
                .font(.title)
                .padding()
            
            if usersViewModel.isLoading {
                ProgressView("Loading users...")
                    .padding()
            } else if let errorMessage = usersViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(usersViewModel.users) { user in
                    NavigationLink(
                        destination: UserDetailView(user: user), // Navigation link to the detail view
                        label: {
                            VStack(alignment: .leading) {
                                Text(user.username)  // Displaying the username
                                    .font(.headline)
                                Text(user.email)     // Displaying the email
                                    .font(.subheadline)
                                Text(user.role)      // Displaying the role
                                    .font(.subheadline)
                            }
                            .padding()
                        }).navigationTitle("User Detail")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            usersViewModel.fetchUsers()  // Fetch users when the view appears
        }
    }
}
