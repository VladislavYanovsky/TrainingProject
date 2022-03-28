
import Foundation

enum  AppError: LocalizedError {
    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "Response could not be decoded"
        case .unknownError:
            return "Oops something went wrong"
        case .invalidUrl:
            return "Error: Invalid error"
        case .serverError(_):
            return "Oops server error"
        }
    }
}

