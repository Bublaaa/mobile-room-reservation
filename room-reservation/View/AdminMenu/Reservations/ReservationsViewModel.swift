import Foundation
import SwiftUI

class ReservationsViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var pendingReservations: [Reservation] = []
    @Published var errorMessage: String? = nil
    
    private let apiHandler = APIHandler.shared
    
    // MARK: - Get All Reservations
    func updateReservationStatus(id: Int, status: String) {
        print("Updating reservation...")
        errorMessage = nil
        apiHandler.updateReservationStatus(id: id, status: status){ [weak self] updatedReservation in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let updatedReservation = updatedReservation {
                    if let index = self.reservations.firstIndex(where: { $0.id == id }) {
                    }
                } else {
                    self.errorMessage = "Failed to update reservation."
                }
            }
        }
    }
    
    // MARK: - Get All Reservations
    func fetchReservations(selectedLocation: String) {
        print("Fetching Reservations...")
        errorMessage = nil
        apiHandler.getReservations { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedReservations):
                    self.reservations = fetchedReservations.filter{
                        
                        $0.room.location.contains(selectedLocation.lowercased())
                    }
                case .failure(let error):
                    self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    func fetchReservations() {
        print("Fetching users...")
        
        errorMessage = nil
        
        apiHandler.getReservations { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedReservations):
                    self.pendingReservations = fetchedReservations.filter{
                        
                        $0.status.contains("approved")
                    }
                    print(self.pendingReservations)
                    self.reservations = fetchedReservations
                case .failure(let error):
                    self.errorMessage = "Failed to load users: \(error.localizedDescription)"
                }
            }
        }
    }
}
