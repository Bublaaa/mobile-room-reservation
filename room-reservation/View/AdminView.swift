import SwiftUI

struct AdminView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    var body: some View {
        TabView {
            UsersMenuView()
                .tabItem {
                    Label("User", systemImage: "person.fill")
                }
                .navigationTitle("Users")
            RoomsMenuView()
                .tabItem {
                    Label("Rooms", systemImage: "house.fill")
                }
                .navigationTitle("Rooms")
            
            ReservationsMenuView()
                .tabItem {
                    Label("Reservation", systemImage: "calendar")
                }
                .navigationTitle("Reservations")
        }
    }
}
