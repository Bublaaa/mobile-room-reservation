import SwiftUI

struct AdminView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    var body: some View {
        TabView {
            UsersMenuView()
                .tabItem {
                    Label("User", systemImage: "person.fill")
                }
            RoomsMenuView()
                .tabItem {
                    Label("Rooms", systemImage: "house.fill")
                }
            
            ReservationsMenuView()
                .tabItem {
                    Label("Reservation", systemImage: "calendar")
                }
        }
        .navigationTitle("Admin Menu")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Log out") {
                    loginViewModel.logout()
                }
                .foregroundColor(.red)
            }
        }
    }
        
}
