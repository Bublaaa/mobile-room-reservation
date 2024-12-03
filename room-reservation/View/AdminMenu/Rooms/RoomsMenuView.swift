import SwiftUI

struct RoomsMenuView: View {
    @StateObject private var roomsViewModel = RoomsViewModel()
    @State private var selectedLocation: String = "gedung 3"
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
                    AddRoomView(roomsViewModel: roomsViewModel)
                }
                Picker("Picker Name", selection: $selectedLocation) {
                    ForEach(locations, id: \.self) { location in
                        Text(location.capitalized).tag(location)
                        
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedLocation) { newValue in
                    roomsViewModel.fetchRooms(selectedLocation: newValue)
                }
            }
            .padding(.horizontal,30)
            
            if let errorMessage = roomsViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(roomsViewModel.rooms) { room in
                    NavigationLink(
                        destination: RoomDetailView(room: room),
                        label: {
                            VStack(alignment: .leading) {
                                Text(room.room_name)
                                    .font(.headline)
                                Text(room.location)
                                    .font(.subheadline)
                            }
                        })
                }
            }
        }
        .onAppear {
            roomsViewModel.fetchRooms(selectedLocation: selectedLocation)
        }
    }
}
