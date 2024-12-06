import Foundation
import Alamofire
import SwiftyJSON

class APIHandler: ObservableObject {
    static let shared = APIHandler()
    
    @Published var user: User?
    @Published var room: Room?
    @Published var reservation: Reservation?
    @Published var token: String?
    @Published var errorMessage: String?
    
    let baseURL = "http://localhost:8000/api"
    
    private func getAuthHeaders() -> HTTPHeaders? {
        guard let token = UserDefaults.standard.string(forKey: "tokenKey") else {
            self.errorMessage = "No token found. Please log in again."
            return nil
        }
        return [
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    private func handleServerError(_ response: AFDataResponse<Any>, error: AFError) -> String {
        if let data = response.data, let serverError = String(data: data, encoding: .utf8) {
            return serverError
        }
        return error.localizedDescription
    }
    
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
                    completion(true, nil)
                case .failure(let error):
                    let message = "Login failed: \(error.localizedDescription)"
                    self.errorMessage = message
                    completion(false, message)
                }
            }
    }
    
    // MARK: - [Auth] Logout Request
    func logout(completion: @escaping (Bool, String?) -> Void) {
        let url = baseURL + "/auth/logout"
        guard let headers = getAuthHeaders() else {
            completion(false, "No valid token.")
            return
        }
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    self.token = nil
                    self.user = nil
                    completion(true, nil)
                case .failure(let error):
                    let message = "Logout failed: \(error.localizedDescription)"
                    self.errorMessage = message
                    completion(false, message)
                }
            }
    }
    
    //MARK: - [Admin] [User] Fetch All Users Detail
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = baseURL + "/users"
        
        guard let headers = getAuthHeaders() else { return }
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let usersArray = json["data"].arrayValue
                    let users = usersArray.map { User(from: $0) }
                    completion(.success(users))
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to fetch users: \(serverError)"
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - [Admin] [User] Create New User
    func addUser(username: String, email: String, role: String, password: String, completion: @escaping (Bool, String?) -> Void){
        let url = baseURL + "/users/register"
        guard let headers = getAuthHeaders() else { return }
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
                    self.user = User(from: json["user"])
                    completion(true, nil)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = serverError
                    completion(false, serverError)
                }
            }
    }
    
    //MARK: - [Admin] [User] Update User Detail
    func updateUser(id: Int, username: String, email: String, role: String, password: String?, password_confirmation: String?, completion: @escaping (User?) -> Void) {
        let url = baseURL + "/users/\(id)"
        
        guard let headers = getAuthHeaders() else {
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
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let updatedUser = User(from: json["data"])
                    self.user = updatedUser
                    completion(updatedUser)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to update user: \(serverError)"
                    completion(nil)
                }
            }
    }
    
    // MARK: - [Admin] [User] Delete User
    func deleteUser(id: Int, completion: @escaping (Bool, String?) -> Void) {
        let url = baseURL + "/users/\(id)"
        
        guard let headers = getAuthHeaders() else {
            completion(false, self.errorMessage)
            return
        }
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to delete user: \(serverError)"
                    completion(false, serverError)
                }
            }
    }
    
    //MARK: - [Public] Fetch Logged In User Detail
    func getUser(id: Int, completion: @escaping (User?) -> Void) {
        guard let headers = getAuthHeaders() else { return }
        let url = baseURL + "/users/\(id)"
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let userData = json["data"]
                    let user = User(from: userData)
                    self.user = user
                    completion(user)
                case .failure(let error):
                    self.errorMessage = "Failed to fetch user details: \(error.localizedDescription)"
                    completion(nil)
                }
            }
    }
    
    
    //MARK: - [Public] [Room] Fetch All Rooms Detail
    func getRooms(completion: @escaping (Result<[Room], Error>) -> Void) {
        let url = baseURL + "/rooms"
        
        guard let headers = getAuthHeaders() else { return }
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let roomsArray = json["data"].arrayValue
                    let rooms = roomsArray.map { Room(from: $0) }
                    completion(.success(rooms))
//                    print(rooms)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to fetch users: \(serverError)"
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: - [Admin] [Room] Create New Room
    func addRoom(room_name: String, location: String, capacity: Int, description: String, completion: @escaping (Bool, String?) -> Void){
        let url = baseURL + "/rooms"
        guard let headers = getAuthHeaders() else { return }
        let parameters: [String: Any] = [
            "room_name": room_name,
            "location": location,
            "capacity": capacity,
            "description": description
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.room = Room(from: json["user"])
                    completion(true, nil)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = serverError
                    completion(false, serverError)
                }
            }
    }
    
    //MARK: - [Admin] [Room] Update Room Detail
    func updateRoom(id: Int, room_name: String, location: String, capacity: Int, description: String, completion: @escaping (Room?) -> Void) {
        let url = baseURL + "/rooms/\(id)"
        
        guard let headers = getAuthHeaders() else {
            completion(nil)
            return
        }
        
        var parameters: [String: Any] = [
            "room_name": room_name,
            "location": location,
            "capacity": capacity,
            "description": description
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let updatedRoom = Room(from: json["data"])
                    self.room = updatedRoom
                    completion(updatedRoom)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to update user: \(serverError)"
                    completion(nil)
                }
            }
    }
    
    // MARK: - [Admin] [Room] Delete Room
    func deleteRoom(id: Int, completion: @escaping (Bool, String?) -> Void) {
        let url = baseURL + "/rooms/\(id)"
        
        guard let headers = getAuthHeaders() else {
            completion(false, self.errorMessage)
            return
        }
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to delete user: \(serverError)"
                    completion(false, serverError)
                }
            }
    }
    
    //MARK: - [Admin] [Reservation] Update Reservation Status
    func updateReservationStatus(id: Int, status: String, completion: @escaping (Reservation?) -> Void) {
        let url = baseURL + "/reservations/status/\(id)"
        
        guard let headers = getAuthHeaders() else {
            completion(nil)
            return
        }
        
        let parameters: [String: String] = [
            "status": status,
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                   
                    let updatedReservation = Reservation(from: json["data"])
                    self.reservation = updatedReservation
                    completion(updatedReservation)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to update reservation: \(serverError)"
                    completion(nil)
                }
            }
    }
    
    // MARK: - [Admin] [Reservation] Delete Reservation
    func deleteReservation(id: Int, completion: @escaping (Bool, String?) -> Void) {
        let url = baseURL + "/reservations/\(id)"
        
        guard let headers = getAuthHeaders() else {
            completion(false, self.errorMessage)
            return
        }
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to delete user: \(serverError)"
                    completion(false, serverError)
                }
            }
    }
    
    //MARK: - [Public] [Reservation] Fetch All Reservations
    func getReservations(completion: @escaping (Result<[Reservation], Error>) -> Void) {
        let url = baseURL + "/reservations"
        
        guard let headers = getAuthHeaders() else { return }
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let reservationsArray = json["data"].arrayValue
                    let reservations = reservationsArray.map { Reservation(from: $0) }
                    completion(.success(reservations))
//                    print(reservations)
                case .failure(let error):
                    let serverError = self.handleServerError(response, error: response.error ?? error)
                    self.errorMessage = "Failed to fetch users: \(serverError)"
                    completion(.failure(error))
                }
            }
    }
}
