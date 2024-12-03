import Foundation
import SwiftyJSON

struct Room: Identifiable {
    var id: Int
    var room_name: String
    var location: String
    var capacity: Int
    var description: String
    
    init(from json: JSON) {
        self.id = json["id"].intValue
        self.room_name = json["room_name"].stringValue
        self.location = json["location"].stringValue
        self.capacity = json["capacity"].intValue
        self.description = json["description"].stringValue
    }
}
