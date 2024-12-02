import SwiftUI

struct UsersMenuView: View {
    @StateObject private var usersViewModel = UsersViewModel()
    @State private var selectedUser: User?
    @State private var isRegisterModal: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30 ){
            HStack(alignment: .top, spacing: 30){
                Button("Register", systemImage: "plus") {
                    isRegisterModal.toggle()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .sheet(isPresented: $isRegisterModal) {
                    RegisterUserView(usersViewModel: usersViewModel)
                }
            }
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 30) {
                if let errorMessage = usersViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(usersViewModel.users) { user in
                        NavigationLink(
                            destination: UserDetailView(user: user),
                            label: {
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .font(.headline)
                                    Text(user.role)
                                        .font(.subheadline)
                                }
                            })
                        
                    }
                }
            }
        }
        .onAppear {
            usersViewModel.fetchUsers()
        }
    }
}
