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
                    print(selectedLocation)
                    self.rooms = fetchedRooms.filter{
                        
                        $0.location.contains(selectedLocation.lowercased())
                    }
                    print(self.rooms)
                case .failure(let error):
                    self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                }
            }
        }
    }
}
