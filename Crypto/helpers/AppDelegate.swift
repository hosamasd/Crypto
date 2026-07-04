//
//  AppDelegate.swift
//  Publo Ultra
//
//

import SwiftUI

//import IQKeyboardManager

class AppDelegate : NSObject,UIApplicationDelegate{
    

//    static var orientationLock = UIInterfaceOrientationMask.all // By default, allow all orientations

    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        startApp()
        
        //        Thread.sleep(forTimeInterval: 100)
        //        RunLoop.current.run(until: NSDate(timeIntervalSinceNow:0.1) as Date)
        //        FirebaseApp.configure()
        
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
//        application.addBackgroundTapGestureForKeyboardDismissal()

        


        return true
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //         UserServices.shared.isOnline(state: false)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //         Messaging.messaging().shouldEstablishDirectChannel = false
        //         UserServices.shared.isOnline(state: false)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //         UserServices.shared.isOnline(state: true)
        //        connectToFirebase()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //        Messaging.messaging().shouldEstablishDirectChannel = false
    }
}


// MARK: - Notifications
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func enableNotification(application: UIApplication) {
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//
//        // For iOS 10 data message (sent via FCM)
//        Messaging.messaging().delegate = self
//
//        Messaging.messaging().token { token, error in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let token = token {
//                UserDefaultsManager.shared().firebaseToken = token
//            }
//        }
//        connectToFcm()
//
//        NotificationCenter.default.addObserver(self, selector:#selector(tokenRefreshNotification(notification:)), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
//
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        debugPrint(error)
//    }
//
//    func application(_ application: UIApplication,
//                     didReceiveRemoteNotification notification: [AnyHashable : Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
////        if Auth.auth().canHandleNotification(notification) {
////            completionHandler(UIBackgroundFetchResult.noData)
////            return
////        }
//
//        print("Push notification received:\n\(notification.jsonString ?? "{}")")
//        Messaging.messaging().appDidReceiveMessage(notification)
//        // This notification is not auth related, developer should handle it.
//    }
//
//    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
//        // Print notification payload data
//        print("Push notification received:\n\(data.jsonString ?? "{}")")
//
//    }
//
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .badge, .sound])
//    }
//
//    @available(iOS 10.0, *)
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {return}
//        print("Push notification received:\n\(userInfo.jsonString ?? "{}")")
//
////        if let type = userInfo["type"] as? String {
////            Constants.uDefaults.set(type, forKey: Constants.notificationType)
////            switch type {
////            case "ad":
////                // open ViewVehicleVC
////                let adId = userInfo["ad_id"] as! String
////                let adTitle = userInfo["title"] as! String
////                Constants.uDefaults.set(Int(adId), forKey: Constants.notificationAdId)
////                Constants.uDefaults.set(adTitle, forKey: Constants.notificationAdTitle)
////                Constants.uDefaults.set(true, forKey: Constants.isFromNotifications)
////                let storyboard = UIStoryboard(name: StoryBoardName.vehicle.rawValue, bundle: nil)
////                let vc = storyboard.instantiateViewController(withIdentifier: StoryBoardVCIds.viewVehicle.rawValue) as! ViewVehicleVC
////                vc.vehicleId = Int(adId)!
////                vc.vehicleTitle = adTitle
////                vc.backToHome = true
////                Constants.uWindow?.rootViewController = vc
////                Constants.uWindow?.makeKeyAndVisible()
////                AppCoordinator.shared.clearNukeCache()
////            default:
////                break
////            }
////        }
//        completionHandler()
//    }
//}

extension Array where Element: Hashable {
    func distinct() -> Array<Element> {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    
    
}
