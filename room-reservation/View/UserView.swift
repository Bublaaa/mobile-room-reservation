import SwiftUI

struct UserView: View {
    @ObservedObject var loginViewModel: LoginViewModel  // Use the same instance
    
    var body: some View {
        HStack {
            Text("User Dashboard")
        
        }
    }
}
