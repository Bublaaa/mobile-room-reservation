import SwiftUI

struct AdminView: View {
    @ObservedObject var loginViewModel: LoginViewModel  // Use the same instance
    
    var body: some View {
        HStack {
            Text("Admin Dashboard")
            Button("Logout") {
                loginViewModel.logout()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(8)
        }
        NavigationView {  // Wrap TabView in a NavigationView to handle titles properly
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
            .accentColor(.blue)  // Customize the selected tab color (optional)
        }
        .padding()  // Add padding around the entire view (optional)
    }
}
