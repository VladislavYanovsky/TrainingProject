
//import Foundation
//import RealmSwift
//
//protocol UserPersistenceProtocol {
//    func add(user: RealmUserModel)
//    func get(username: String) -> Object?
//    func delete(username: String)
//}
//
//class RealmUserPersistence: UserPersistenceProtocol {
//    
//    private lazy var  mainRealm = try! Realm()
//    
//    func add(user: RealmUserModel) {
//        try! mainRealm.write {
//            mainRealm.add(user)
//        } 
//    }
//    
//    func get(username: String) -> Object?{
//        let users = mainRealm.objects(RealmUserModel.self).filter("username = '\(username)'")
//        let user = users.first(where: {$0.username == username})
//        return user ?? nil
//    }
//    
//    func delete(username: String) {
//        let user = mainRealm.objects(RealmUserModel.self).filter("username = '\(username)'")
//        try! mainRealm.write{
//            mainRealm.delete(user)
//        }
//    }
//
//}
