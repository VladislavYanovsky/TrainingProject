
import Foundation

struct PetsResponseData: Decodable {
    let id: Int
    let category: Category?
    let name: String?
    let photoUrls: [String]?
    let tags: [Tag]?
    let status: String?
}

struct Category: Decodable {
    let id: Int?
    let name: String?
}

struct Tag : Decodable {
        let id: Int?
        let name: String?
    }

