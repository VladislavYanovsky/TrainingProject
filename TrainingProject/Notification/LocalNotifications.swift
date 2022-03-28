import  UIKit
import  UserNotifications

final class Notifications: NSObject,UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    static let shared = Notifications() 
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
   func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] (granted, error)  in
            print("Local notification")
            if  granted {
                self?.checkRemoteNotification()
                print("Permishen granted: \(granted)")
            
            } else {
                print("Permisson denied")
            }
        }
    }
    
    func scheduleNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
    
        content.title = "Content Title " + notificationType
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = userAction
    
        let triger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let string = UUID().uuidString
        let request = UNNotificationRequest(identifier: string, content: content, trigger: triger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error.localizedDescription)
            }
        }

        let snoozeAction = UNNotificationAction(identifier: "Remind me later", title: "Remind me later", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Leave me alone! Don't send me this notification!", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "Remind me later":
            print("Remind me later is selected")
            scheduleNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
    
    func checkRemoteNotification() {
        notificationCenter.getNotificationSettings { settings in
            switch settings.alertSetting {
            case .enabled:
                print("Enabled")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .disabled:
                print("Disabled")
            case .notSupported:
                print("notSupported")
            default:
                break
            }
        }
    }
}
