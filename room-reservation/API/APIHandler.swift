import Foundation
import Alamofire
import SwiftyJSON

class APIHandler: ObservableObject {
    static let shared = APIHandler()
    
    @Published var user: User?
    @Published var token: String?
    @Published var errorMessage: String?
    
    let baseURL = "http://localhost:8000/api"
    
    //MARK: - [Auth] Login Request
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
    
    //MARK: - [Auth] Logout Request
    func logout() {
        let url = baseURL + "/auth/logout"
        
        guard let token = UserDefaults.standard.string(forKey: "tokenKey") else {
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
    
    //MARK: - [Admin] [User] Fetch All Users Detail
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = baseURL + "/users"
        
        guard let token = UserDefaults.standard.string(forKey: "tokenKey") else {
            self.errorMessage = "No token found"
            return
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    //print("Successfully fetched data: \(value)")
                    let json = JSON(value)
                    let usersArray = json["data"].arrayValue
                    let users = usersArray.map { User(from: $0) }
                    
                    //                    print("Parsed users: \(users)")
                    completion(.success(users))
                case .failure(let error):
                    print("Failed to fetch users: \(error.localizedDescription)")
                    self.errorMessage = "Failed to fetch users: \(error.localizedDescription)"
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - [Admin] [User] Create New User
    func addUser(username: String, email: String, role: String, password: String, completion: @escaping (Bool, String?) -> Void){
        let url = baseURL + "/users/register"
        guard let token = UserDefaults.standard.string(forKey: "tokenKey") else {
            self.errorMessage = "No token found"
            return
        }
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        let parameters: [String: String] = [
            "username": username,
            "email": email,
            "role": role,
            "password": password
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let userData = json["user"].dictionary {
                        self.user = User(from: JSON(userData))
                        self.errorMessage = nil
                        completion(true, nil)
                    } else {
                        let error = "Failed to parse user data."
                        self.errorMessage = error
                        completion(false, error)
                    }
                    
                case .failure(let error):
                    print("Add user failed: \(error.localizedDescription)")
                    
                    var serverError = error.localizedDescription
                    if let data = response.data, let serverErrorString = String(data: data, encoding: .utf8) {
                        serverError = serverErrorString
                    }
                    self.errorMessage = serverError
                    completion(false, serverError)
                }
            }
    }
    
    //MARK: - [Admin] [User] Update User Detail
    func updateUser(id: Int, username: String, email: String, role: String, password: String?, password_confirmation: String?, completion: @escaping (User?) -> Void) {
        let url = baseURL + "/users/\(id)"
        
        guard let token = UserDefaults.standard.string(forKey: "tokenKey") else {
            self.errorMessage = "No token found"
            completion(nil)
            return
        }
        
        // Build parameters dynamically to exclude empty password fields
        var parameters: [String: String] = [
            "username": username,
            "email": email,
            "role": role
        ]
        if let password = password, !password.isEmpty,
           let password_confirmation = password_confirmation, !password_confirmation.isEmpty {
            parameters["password"] = password
            parameters["password_confirmation"] = password_confirmation
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let userData = json["data"].dictionary {
                        let user = User(from: JSON(userData))
                        self.user = user
                        completion(user)
                    } else {
                        print("Invalid user data received: \(json)")
                        self.errorMessage = "Failed to parse user data."
                        completion(nil)
                    }
                case .failure(let error):
                    print("Failed to update user: \(error.localizedDescription)")
                    if let data = response.data, let serverError = String(data: data, encoding: .utf8) {
                        print("Server error: \(serverError)")
                    }
                    self.errorMessage = "Failed to update user: \(error.localizedDescription)"
                    completion(nil)
                }
            }
    }
    
    // MARK: - [Admin] [User] Delete User
    func deleteUser(id: Int, completion: @escaping (Bool, String?) -> Void) {
        let url = baseURL + "/users/\(id)"
        
        guard let token = UserDefaults.standard.string(forKey: "tokenKey") else {
            completion(false, "No token found")
            return
        }
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    print("Delete user failed: \(error.localizedDescription)")
                    var serverError = error.localizedDescription
                    if let data = response.data, let serverErrorString = String(data: data, encoding: .utf8) {
                        serverError = serverErrorString
                    }
                    completion(false, serverError)
                }
            }
    }
    
    //MARK: - [Public] Fetch Logged In User Detail
    func getUser(id: Int, completion: @escaping (User?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "tokenKey") else {
            self.errorMessage = "No token found"
            return
        }
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
