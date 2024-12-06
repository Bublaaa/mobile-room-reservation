
import SwiftUI

struct ReservationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var reservationsViewModel = ReservationsViewModel()
    @State var reservation: Reservation
    
    @State private var booker: String
    @State private var room_name: String
    @State private var status : String
    @State private var start_time: String
    @State private var end_time: String
    @State private var purpose: String

    
    @State private var showDeleteModal = false

    let statuses = ["pending", "rejected", "approved"]

    init(reservation: Reservation) {
        _reservation = State(initialValue: reservation)
        _booker = State(initialValue: reservation.booker.username)
        _room_name = State(initialValue: reservation.room.room_name)
        _status = State(initialValue: reservation.status)
        _start_time = State(initialValue: reservation.start_time)
        _end_time = State(initialValue: reservation.end_time)
        _purpose = State(initialValue: reservation.purpose)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Error Message
                if let errorMessage = reservationsViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Form {
                    // User Information
                    Section(header: Text("Reservation Detail")) {
                        Text(booker)
                        Text(room_name)
                        Picker("Status", selection: $status) {
                            ForEach(statuses, id: \.self) { role in
                                Text(role.capitalized).tag(role)
                            }
                        }
                        Text(start_time)
                        Text(end_time)
                        Text(purpose)
                }
                    
                    // Actions
                    Section(header: Text("Action")) {
                        Button("Save") {
                            reservationsViewModel.updateReservationStatus(
                                id: reservation.id,
                                status: status
                            )
                        }

                        Button("Delete Account") {
                            showDeleteModal = true
                        }
                        .foregroundColor(.red)
                        .confirmationDialog("Are you sure you want to delete this room?", isPresented: $showDeleteModal) {
                            Button("Yes", role: .destructive) {
//                                roomsViewModel.deleteRoom(id: room.id) { success in
//                                    if success {
//                                        dismiss()
//                                        roomsViewModel.fetchRooms(selectedLocation: room.location)
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
