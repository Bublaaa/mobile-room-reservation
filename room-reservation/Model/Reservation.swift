import Foundation
import SwiftyJSON

struct Reservation: Identifiable, Codable {
    var id: Int
    var user_id: String
    var room_id: String
    var start_time: String
    var end_time: String
    var purpose: String
    var status: String
    var book_date: String
    var booker: User
    var room : Room
    init(from json: JSON) {
        self.id = json["id"].intValue
        self.user_id = json["user_id"].stringValue
        self.room_id = json["room_id"].stringValue
        self.start_time = Reservation.splitDateString(dateString: json["start_time"].stringValue, format: "time")
        self.end_time = Reservation.splitDateString(dateString: json["end_time"].stringValue, format: "time")
        self.purpose = json["purpose"].stringValue
        self.status = json["status"].stringValue
        self.book_date = Reservation.splitDateString(dateString: json["end_time"].stringValue, format: "date")
        
        self.booker = User(from: json["user"])
        self.room = Room(from: json["room"])
    }
    
    private static func splitDateString(dateString: String, format: String) -> String {
        let dateStringArray = dateString.split(separator: " ")
        if (format == "time" ){
            return String(dateStringArray[1])
        }
        else {
            return String(dateStringArray[0])
        }
    }
}
