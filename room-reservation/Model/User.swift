import Foundation
import SwiftyJSON

struct User: Identifiable {
    var id: Int
    var username: String
    var email: String
    var role: String
    
    init(from json: JSON) {
        self.id = json["id"].intValue
        self.username = json["username"].stringValue
        self.email = json["email"].stringValue
        self.role = json["role"].stringValue
    }
}
