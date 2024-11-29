import SwiftUI

struct UserDetailView: View {
    @State var user: User
    @State private var username: String
    @State private var email: String
    @State private var selectedRole: String
    @State private var isEditing = false
    @State private var isChangePassword : Bool = false
    @State private var newPassword : String = ""
    @State private var confrimNewPassword : String = ""
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
                Form {
                    Section(header: Text("User Information")) {
                        TextField("Username", text: $username)
                        TextField("Email", text: $email)
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
                            SecureField("New Password", text: $newPassword)
                            SecureField("Confirm New Password", text: $confrimNewPassword)
                        }
                    }
                    Section(header: Text("Aciton")){
                        Button("Save"){
                            print("Save Clicked")
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
//            .navigationBarItems(leading: Button(action: {
//                saveUserDetails()
//            }) {
//                Text("Save")
//            }
//                .foregroundColor(.blue))
//            .padding()
        }
    }
    
    private func saveUserDetails() {
        print("User details saved: \(username), \(email), \(selectedRole)")
        user.username = username
        user.email = email
        user.role = selectedRole
    }
}
