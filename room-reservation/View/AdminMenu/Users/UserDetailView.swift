import SwiftUI

struct UserDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var usersViewModel = UsersViewModel()
    @State var user: User
    @State private var username: String
    @State private var email: String
    @State private var selectedRole: String
    @State private var isEditing = false
    @State private var isChangePassword: Bool = false
    @State private var password: String = ""
    @State private var password_confirmation: String = ""
    @State private var showDeleteModal = false

    let roles = ["admin", "user"]

    init(user: User) {
        _user = State(initialValue: user)
        _username = State(initialValue: user.username)
        _email = State(initialValue: user.email)
        _selectedRole = State(initialValue: user.role)
    }

    var body: some View {
        NavigationView {
            VStack {
                // Error Message
                if let errorMessage = usersViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Form {
                    // User Information
                    Section(header: Text("User Information")) {
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                        Picker("Role", selection: $selectedRole) {
                            ForEach(roles, id: \.self) { role in
                                Text(role.capitalized).tag(role)
                            }
                        }
                        Toggle(isOn: $isChangePassword) {
                            Text("Change Password")
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }

                    // Change Password
                    if isChangePassword {
                        Section(header: Text("Change Password")) {
                            SecureField("New Password", text: $password)
                            SecureField("Confirm New Password", text: $password_confirmation)
                        }
                    }

                    // Actions
                    Section(header: Text("Action")) {
                        Button("Save") {
                            usersViewModel.updateUser(
                                id: user.id,
                                username: username,
                                email: email,
                                role: selectedRole,
                                password: isChangePassword ? password : nil,
                                password_confirmation: isChangePassword ? password_confirmation : nil
                            )
                        }

                        Button("Delete Account") {
                            showDeleteModal = true
                        }
                        .foregroundColor(.red)
                        .confirmationDialog("Are you sure you want to delete this account?", isPresented: $showDeleteModal) {
                            Button("Yes", role: .destructive) {
                                usersViewModel.deleteUser(id: user.id) { success in
                                    if success {
                                        dismiss()
                                    }
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                }
            }
            .navigationTitle("Edit User Detail")
        }
    }
}
