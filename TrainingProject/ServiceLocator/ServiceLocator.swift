import Foundation

let networkService: NetworkProtocol? = ServiceLocator.shared.getService()
let networkManager = networkService ?? NetworkService()

//let realmService: UserPersistenceProtocol? = ServiceLocator.shared.getService()
//let realmManager = realmService ?? RealmUserPersistence()

let coreDataService: PetPersistenceProtocol? =  ServiceLocator.shared.getService()
let coreDataManager = coreDataService ?? CoreDataManager()

protocol ServiceLocating {
    func getService<T>() -> T?
}
final class ServiceLocator: ServiceLocating {
    private lazy var services: [String: Any] = [:]
    private func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
    func addService<T>(service: T) {
        let key = typeName(T.self)
        services[key] = service
    }
    func getService<T>() -> T? {
        let key = typeName(T.self)
        return services[key] as? T
    }
    static let shared = ServiceLocator()
}
