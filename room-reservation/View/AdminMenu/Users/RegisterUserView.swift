import SwiftUI

struct RegisterUserView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var usersViewModel: UsersViewModel
    
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var selectedRole: String = "user"
    @State private var password: String = ""
    let roles = ["admin", "user"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // MARK: - Modal Header
            HStack(alignment: .top) {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("Save", systemImage: "plus") {
                    // Register the user and only dismiss if successful
                    usersViewModel.registerUser(username: username, email: email, role: selectedRole, password: password) { success in
                        if success {
                            dismiss() // Dismiss if successful registration
                        } else {
                            usersViewModel.errorMessage = usersViewModel.errorMessage // Show error message if registration fails
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity)
            
            // MARK: - Title
            Text("Register Modal")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .font(.largeTitle.bold())
            
            List {
                // MARK: - Username Field
                TextField("Username", text: $username)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // MARK: - Email Field
                TextField("Email", text: $email)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // MARK: - Role Picker
                Picker("Role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role.capitalized).tag(role)
                    }
                }
                
                // MARK: - Password Field
                SecureField("Password", text: $password)
                    .cornerRadius(10)
            }
            Spacer()
        }
    }
}
