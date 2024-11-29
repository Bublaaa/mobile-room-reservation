import SwiftUI

struct UsersMenuView: View {
    @StateObject private var usersViewModel = UsersViewModel()
    @State private var selectedUser: User?
    @State private var isShowModal : Bool = false
    
    var body: some View {
        VStack {
            if let errorMessage = usersViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if usersViewModel.users.isEmpty {
                ProgressView("Loading users...")
                    .padding()
            } else {
                List(usersViewModel.users) { user in
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                        Text(user.role)
                            .font(.subheadline)
                    }
                    .onTapGesture {
                        self.selectedUser = user
                        self.isShowModal = true
                    }
                }
                .sheet(isPresented: Binding(
                    get: { selectedUser != nil && isShowModal },
                    set: { if !$0 { isShowModal = false; selectedUser = nil } }
                )) {
                    if let user = selectedUser {
                        UserDetailView(user: user)
                    }
                }
            }
        }
        .onAppear {
            usersViewModel.fetchUsers()
        }
    }
}
