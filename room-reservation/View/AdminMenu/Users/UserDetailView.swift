import SwiftUI

struct UserDetailView: View {
    @State var user: User
    @State private var username: String
    @State private var email: String
    @State private var selectedRole: String
    @State private var isEditing = false
    
    let roles = ["admin", "user"] // Example roles

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
                            .padding()

                        TextField("Email", text: $email)
                            .padding()

                        Picker("Role", selection: $selectedRole) {
                            ForEach(roles, id: \.self) { role in
                                Text(role.capitalized).tag(role)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle()) // You can change the style of the Picker here
                        .padding()
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("User Details", displayMode: .inline) // Set the title for the navigation bar
            .navigationBarItems(trailing: Button(action: {
                // Action for saving changes
                saveUserDetails()
            }) {
                Text("Save")
                    .font(.title2)
                    .padding()
            }
            .foregroundColor(.blue))
            .padding()
        }
    }
    
    private func saveUserDetails() {
        print("User details saved: \(username), \(email), \(selectedRole)")
        user.username = username
        user.email = email
        user.role = selectedRole
    }
}
