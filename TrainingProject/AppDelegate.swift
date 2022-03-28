import UIKit
import CoreData
import UserNotifications
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var backgroundTaskID: UIBackgroundTaskIdentifier? = nil
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ServiceLocator.shared.addService(service: NetworkService() as NetworkProtocol)
        Notifications.shared.requestAutorization()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceToken = deviceToken.map{String(format: "%02.2hhx", $0)}.joined()
        print("Device Token: \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Registraton error: \(error.localizedDescription)")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        bgTask()
    }
    
    func bgTask() {
        let queue = DispatchQueue(label: "Queue for bgTask" )
        let semaphore = DispatchSemaphore(value: 1)
        DispatchQueue.global().async {
            self.backgroundTaskID = UIApplication.shared.beginBackgroundTask (withName: "Finish Network Tasks") {
                UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
                self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
            }
            queue.async {
                semaphore.wait()
                networkManager.getPets(status: "pending") {  [weak self] (result) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let pets):
                        DispatchQueue.main.async {
                            coreDataManager.add(pets: pets)
                            semaphore.signal()
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        semaphore.signal()
                    }
                }
            }
            UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
}
