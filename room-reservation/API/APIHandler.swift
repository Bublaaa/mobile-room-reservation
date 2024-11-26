import Foundation
import Alamofire
import SwiftyJSON

class APIHandler: ObservableObject {
    static let shared = APIHandler()
    
    @Published var user: User?
    @Published var token: String?
    @Published var errorMessage: String?
    
    let baseURL = "http://localhost:8000/api"
    
    // Login function
    func login(username: String, password: String) {
        let url = baseURL + "/auth/login"
        let parameters: [String: String] = [
            "username": username,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.token = json["token"].string
                    self.user = User(from: json["user"])
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            }
    }
    // Logout function
    func logout() {
        let url = baseURL + "/auth/logout"
        
        guard let token = self.token else {
            self.errorMessage = "No token found"
            return
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    // Clear token and user data after successful logout
                    self.token = nil
                    self.user = nil
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = "Logout failed: \(error.localizedDescription)"
                }
            }
    }
    // Get all users function with a completion handler
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = baseURL + "/users"
        
        guard let token = self.token else {
            self.errorMessage = "No token found"
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No token found"])))
            return
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        print("Requesting all users from: \(url)")  // Debugging print
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Successfully fetched data: \(value)")  // Debugging print
                    
                    // Access the 'data' key and parse the users array
                    let json = JSON(value)
                    let usersArray = json["data"].arrayValue  // Access the 'data' field
                    let users = usersArray.map { User(from: $0) }
                    
                    print("Parsed users: \(users)")  // Debugging print
                    completion(.success(users))
                case .failure(let error):
                    print("Failed to fetch users: \(error.localizedDescription)")  // Debugging print
                    self.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
    }
}
