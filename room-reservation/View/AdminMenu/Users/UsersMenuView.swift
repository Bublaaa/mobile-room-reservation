import SwiftUI

struct UsersMenuView: View {
    @StateObject private var usersViewModel = UsersViewModel()
    @State private var selectedUser: User?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                        destination: UserDetailView(user: user),
                        label: {
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                                Text(user.role)
                                    .font(.subheadline)
                            }
                        })
                    
                }
            }
            Button("Register") {
                print("register clicked")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            Spacer()
        }
        .onAppear {
            usersViewModel.fetchUsers()  // Fetch users when the view appears
        }
    }
}
