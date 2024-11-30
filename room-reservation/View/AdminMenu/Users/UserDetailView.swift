import SwiftUI

struct UserDetailView: View {
    @StateObject var usersViewModel = UsersViewModel()
    @State var user: User
    @State private var username: String
    @State private var email: String
    @State private var selectedRole: String
    @State private var isEditing = false
    @State private var isChangePassword : Bool = false
    @State private var password : String = ""
    @State private var password_confirmation : String = ""
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
                if let errorMessage = usersViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                Form {
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
                    if isChangePassword {
                        Section(header: Text("Change Password")) {
                            SecureField("New Password", text: $password)
                            SecureField("Confirm New Password", text: $password_confirmation)
                        }
                    }
                    Section(header: Text("Aciton")){
                        Button("Save"){
                            usersViewModel.updateUser(
                                id: user.id,
                                username: username,
                                email: email,
                                role: selectedRole,
                                password: isChangePassword ? password : nil,
                                password_confirmation: isChangePassword ? password_confirmation : nil
                            )
                        }
                        Button("Delete Account"){
                            print("Delete Clicked")
                            showDeleteModal = true
                        }
                        .foregroundStyle(.red)
                        .confirmationDialog("Change background", isPresented: $showDeleteModal) {
                            Button("Yes") {
                                print("Confirmation Cliked")
                            }
                            .foregroundStyle(.red)
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Are you sure to delete this account?")
                        }
                    }
                }
            }
            .navigationBarTitle("Edit User Detail")
        }
    }
}
