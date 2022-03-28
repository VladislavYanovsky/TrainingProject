
import Foundation

class UserResponseData: Decodable {
    var id: Int?
    var username: String?
    var firstname: String?
    var lastname: String?
    var email: String?
    var password: String?
    var phone: String?
    var userStatus: Int?
}
