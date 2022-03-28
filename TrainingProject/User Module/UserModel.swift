
import Foundation


struct User {
    var id: Int
    var username: String
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var phone: String
    var userStatus: Int
}

//class RealmUserModel: Object {
//    @Persisted var id = Int()
//    @Persisted var username = String()
//    @Persisted var firstname = String()
//    @Persisted var lastname = String()
//    @Persisted  var email = String()
//    @Persisted  var password = String()
//    @Persisted  var phone = String()
//    @Persisted  var userStatus = Int()
//
//    convenience init (from userModel: User) {
//        self.init()
//        self.id =  userModel.id
//        self.username = userModel.username
//        self.firstname = userModel.firstname
//        self.lastname = userModel.lastname
//        self.email =  userModel.email
//        self.password = userModel.password
//        self.phone =  userModel.phone
//        self.userStatus = userModel.userStatus
//    }
//}

