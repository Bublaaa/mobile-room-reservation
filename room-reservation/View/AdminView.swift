import SwiftUI

struct AdminView: View {
    @ObservedObject var loginViewModel: LoginViewModel  // Use the same instance
    
    var body: some View {
        VStack {
            // Content of the Admin View
            Text("Welcome, Admin!")
                .font(.largeTitle)
                .padding()
            
            // Add other content that you'd like in your AdminView here
            Spacer()
            
            // Bottom Navigation Menu
            TabView {
                RoomsMenuView()
                    .tabItem {
                        Label("Rooms", systemImage: "house.fill")
                    }
                
                ReservationsMenuView()
                    .tabItem {
                        Label("Reservation", systemImage: "calendar")
                    }
                
                UsersMenuView() // Pass the loginViewModel to UserView
                    .tabItem {
                        Label("User", systemImage: "person.fill")
                    }
            }
            .accentColor(.blue)  // Customize the selected tab color (optional)
        }
        .padding()  // Add padding around the entire view (optional)
    }
}
