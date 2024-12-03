import SwiftUI

struct AddRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var roomsViewModel: RoomsViewModel
    
    @State private var room_name: String = ""
    @State private var location: String = ""
    @State private var capacity: Int = 0
    @State private var selectedLocation: String = "gedung 1"
    @State private var description: String = ""
    
    let locations = ["gedung 1", "gedung 2", "gedung 3"]
    
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
                    roomsViewModel.addRoom(room_name: room_name, location: selectedLocation, capacity: capacity, description: description) { success in
                        if success {
                            dismiss() // Dismiss if successful registration
                        } else {
                            roomsViewModel.errorMessage = roomsViewModel.errorMessage // Show error message if registration fails
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
                // MARK: - Room Name Field
                TextField("Room Name", text: $room_name)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                
                // MARK: - Location Picker
                Picker("Location", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location.capitalized).tag(location)
                    }
                }
                
                // MARK: - Location Field
                TextField("Capacity", value: $capacity, format: .number)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // MARK: - Description Field
                TextField("Description", text: $description)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            Spacer()
        }
    }
}
