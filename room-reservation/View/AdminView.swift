import SwiftUI

struct AdminView: View {
    @ObservedObject var loginViewModel: LoginViewModel  
    
    var body: some View {
        HStack {
            Button("Logout") {
                loginViewModel.logout()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(8)
        }
        TabView {
            RoomsMenuView()
                .tabItem {
                    Label("Rooms", systemImage: "house.fill")
                }
                .navigationBarTitle("Rooms", displayMode: .inline)
            
            ReservationsMenuView()
                .tabItem {
                    Label("Reservation", systemImage: "calendar")
                }
                .navigationBarTitle("Reservations", displayMode: .inline)
            
            UsersMenuView()
                .tabItem {
                    Label("User", systemImage: "person.fill")
                }
                .navigationBarTitle("Users", displayMode: .inline)
        }
        .accentColor(.blue)
        
    }
}
