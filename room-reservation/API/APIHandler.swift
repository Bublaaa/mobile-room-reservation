import Foundation
import Alamofire
import SwiftyJSON

class APIHandler: ObservableObject {
    static let shared = APIHandler()
    
    @Published var user: User?
    @Published var token: String?
    @Published var errorMessage: String?
    
    let baseURL = "http://localhost:8000/api"
    
    //MARK: -- Login
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
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
                    completion(true, nil)
                case .failure(let error):
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    completion(false, self.errorMessage)
                }
            }
    }

    //MARK: -- Logout
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
                    self.token = nil
                    self.user = nil
                    self.errorMessage = nil
                case .failure(let error):
                    self.errorMessage = "Logout failed: \(error.localizedDescription)"
                }
            }
    }
    //MARK: -- Fetch All Users Detail
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
        
        print("Requesting all users from: \(url)")  // Dsebugging print
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
//                    print("Successfully fetched data: \(value)")
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
    //MARK: -- Fetch Logged In User Detail
    func getUser(id: Int, token: String, completion: @escaping (User?) -> Void) {
        let url = baseURL + "/users/\(id)"
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON Response: \(json)")
                    let userData = json["data"]
                    let user = User(from: userData)
                    self.user = user
                    completion(user)
                case .failure(let error):
                    self.errorMessage = "Failed to fetch user details: \(error.localizedDescription)"
//                    print(self.errorMessage ?? "Unknown error")
                    completion(nil)
                }
            }
    }
}
