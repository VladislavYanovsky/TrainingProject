
import Foundation
import UIKit

class UserViewControllerModel {
    var currentUser: User?
    let closeEye = UIImage(named: "close-eye")
    let openEye = UIImage(named: "open-eye")
    
    func updateUser(_ completion: @escaping(Result<User,Error>) -> Void) {
        networkManager.userGetRequest(username: currentUser?.username ?? "") { result in
            switch result{
            case .success(let user):
                let user = User(
                    id: user.id ?? 0,
                    username: user.username ?? "No Username data from server received",
                    firstname: user.firstname ?? "No Firstname data from server received",
                    lastname: user.lastname ?? "No Lastname data from server received",
                    email: user.email ?? "No Email data from server received",
                    password: user.password ?? "No Password data from server received",
                    phone: user.phone ?? "No Phone data from server received",
                    userStatus: user.userStatus ?? 0)
                completion(.success(user))
            case .failure(let error):
                print("Error is: \(error)")
            }
        }
    }
}
