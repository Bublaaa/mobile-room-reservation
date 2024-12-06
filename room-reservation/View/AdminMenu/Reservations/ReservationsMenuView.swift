import SwiftUI

struct ReservationsMenuView: View {
    @StateObject private var reservationsViewModel = ReservationsViewModel()
    @State private var selectedLocation: String = "gedung 1"
    @State private var isAddNewRoom: Bool = false
    let locations = ["gedung 1","gedung 2","gedung 3"]
    
    var body: some View {
        VStack(spacing: 30){
            VStack(spacing: 40){
                Button("New Room", systemImage: "plus") {
                    isAddNewRoom.toggle()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .sheet(isPresented: $isAddNewRoom) {
//                    AddRoomView(roomsViewModel: roomsViewModel)
                    EmptyView()
                }
                Picker("Picker Name", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location.capitalized).tag(location)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedLocation) { newValue in
                    reservationsViewModel.fetchReservations(selectedLocation: newValue)
                }
            }
            .padding(.horizontal, 20)
            
            if let errorMessage = reservationsViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(reservationsViewModel.reservations) { reservation in
                    NavigationLink(
                        destination: ReservationDetailView(reservation: reservation),
                        label: {
                            VStack(alignment: .leading) {
                                Text(reservation.room.room_name)
                                    .font(.headline)
                                Text(reservation.status)
                                    .font(.subheadline)
                            }
                        })
                }
            }
        }
        .onAppear {
            reservationsViewModel.fetchReservations(selectedLocation: selectedLocation)
        }
    }
}
