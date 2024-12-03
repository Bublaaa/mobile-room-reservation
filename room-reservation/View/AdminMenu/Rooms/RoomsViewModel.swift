import Foundation

class RoomsViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var errorMessage: String? = nil
    
    private let apiHandler = APIHandler.shared
    
    //MARK: - Get All Rooms
    func fetchRooms(selectedLocation: String) {
        print("Fetching Rooms...")
        errorMessage = nil
        apiHandler.getRooms { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedRooms):
                    self.rooms = fetchedRooms.filter{
                        
                        $0.location.contains(selectedLocation.lowercased())
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func updateRoom(id: Int, room_name: String, location: String, capacity: Int, description: String){
        print("Updating Rooms...")
        errorMessage = nil
        apiHandler.updateRoom(id: id, room_name: room_name, location: location, capacity: capacity, description: description){ [weak self] updatedRoom in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let updatedRoom = updatedRoom {
                    if let index = self.rooms.firstIndex(where: { $0.id == id }) {
                        self.rooms[index] = updatedRoom
                    }
                } else {
                    self.errorMessage = "Failed to update user."
                }
            }
        }
    }
}
