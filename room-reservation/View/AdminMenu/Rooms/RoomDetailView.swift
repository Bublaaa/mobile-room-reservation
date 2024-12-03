import SwiftUI

struct RoomDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var roomsViewModel = RoomsViewModel()
    @State var room: Room
    @State private var room_name: String
    @State private var location: String
    @State private var capacity: Int
    @State private var description: String

    @State private var showDeleteModal = false

    let roles = ["gedung 1", "gedung 2", "gedung 3"]

    init(room: Room) {
        _room = State(initialValue: room)
        _room_name = State(initialValue: room.room_name)
        _location = State(initialValue: room.location)
        _capacity = State(initialValue: room.capacity)
        _description = State(initialValue: room.description)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Error Message
                if let errorMessage = roomsViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Form {
                    // User Information
                    Section(header: Text("Room Information")) {
                        TextField("Room Name", text: $room_name)
                            .autocapitalization(.none)
                        Picker("Location", selection: $location) {
                            ForEach(roles, id: \.self) { role in
                                Text(role.capitalized).tag(role)
                            }
                        }
                        TextField("Capacity", value: $capacity, format: .number)
                            .autocapitalization(.none)
                        
                        TextField("Description", text: $description)
                            .autocapitalization(.none)
                        
                    }


                    // Actions
                    Section(header: Text("Action")) {
                        Button("Save") {
//                            usersViewModel.updateUser(
//                                id: user.id,
//                                username: username,
//                                email: email,
//                                role: selectedRole,
//                                password: isChangePassword ? password : nil,
//                                password_confirmation: isChangePassword ? password_confirmation : nil
//                            )
                        }

                        Button("Delete Account") {
                            showDeleteModal = true
                        }
                        .foregroundColor(.red)
                        .confirmationDialog("Are you sure you want to delete this room?", isPresented: $showDeleteModal) {
                            Button("Yes", role: .destructive) {
//                                usersViewModel.deleteUser(id: user.id) { success in
//                                    if success {
//                                        dismiss()
//                                    }
//                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                }
            }
            .navigationTitle("Edit Room Detail")
        }
    }
}

