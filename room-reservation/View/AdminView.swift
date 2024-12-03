import SwiftUI

struct AdminView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    var body: some View {
        TabView {
            
            RoomsMenuView()
                .tabItem {
                    Label("Rooms", systemImage: "house.fill")
                }
            
            UsersMenuView()
                .tabItem {
                    Label("User", systemImage: "person.fill")
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
