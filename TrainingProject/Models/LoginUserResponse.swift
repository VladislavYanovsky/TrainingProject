
import Foundation

struct LoginUserResponse: Decodable {
    let code: Int?
    let type: String?
    let message: String?
}
