
import Foundation

enum Route {
    
    static let baseUrl = "https://petstore.swagger.io/v2"
    static let user = "/user/"
    static let pet = "/pet/findByStatus?status="
    static let petPhoto = "/pet/"
    static let login = "/user/"
    
    case getUser(String)
    case createUser
    case loginUser(String, String)
    case deleteUser(String)
    case getPets(String)
    case uploadPhoto(String)
    
    var path: String {
        switch self {
        case .loginUser(let username, let password):
            return "/user/login?username=" + username  + "&password=" + password
        case .getUser(let username):
            return "/user/" + username
        case .createUser:
            return "/user"
        case .deleteUser(let username):
            return "/user/" + username
        case .getPets(let status):
            return "/pet/findByStatus?status=" + status
        case .uploadPhoto(let id):
            return "/pet/" + id + "/uploadImage"
        default:
            return ""
        }
    }  
}
