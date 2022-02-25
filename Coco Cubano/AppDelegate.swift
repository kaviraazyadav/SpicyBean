//
//  AppDelegate.swift
//  Coco Cubano
//
//  Created by kavi yadav on 14/12/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import Firebase
import FirebaseAnalytics
import CoreLocation
var user_lat = ""
var user_long = ""
@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        IQKeyboardManager.shared.enable = true
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
            // Show the app's signed-out state.
          } else {
              print("GooglePreviousUser:",user)
            // Show the app's signed-in state.
          }
        }
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        self.getUserCurrentLocation()
        return true
    }
    
    func getUserCurrentLocation(){
        locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()

           if CLLocationManager.locationServicesEnabled(){
               locationManager.startUpdatingLocation()
           }

    }
    
    // Location delegate
    //MARK: - location delegate methods
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation :CLLocation = locations[0] as CLLocation
    user_lat = "\(userLocation.coordinate.latitude)"
    user_long = "\(userLocation.coordinate.longitude)"
//    print("user latitude = \(user_lat)")
//    print("user longitude = \(user_long)")
    
    userDefault.shared.save_user_lat(data:"\(userLocation.coordinate.latitude)", key: Constants.user_lat)
    userDefault.shared.save_user_long(data: "\(userLocation.coordinate.longitude)", key: Constants.user_long)

    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
        if (error != nil){
//            print("error in reverseGeocode")
        }
//        let placemark = placemarks! as [CLPlacemark]
//        if placemark.count>0{
//            let placemark = placemarks![0]
//            print(placemark.locality!)
//            print(placemark.administrativeArea!)
//            print(placemark.country!)
//
//        }
    }

}
func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error \(error)")
}

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//      print("Firebase registration token: \(String(describing: fcmToken))")
        print("Firebase registration token:\(fcmToken ?? "")")
        
        userDefault.shared.save_device_token(data: fcmToken ?? "", key: Constants.user_token)
    }
   
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }



    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Coco_Cubano")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("deviceToken",deviceToken)
      Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        debugPrint("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
    let userInfo = notification.request.content.userInfo

    print(userInfo)

    // Change this to your preferred presentation option
      completionHandler([[.alert, .sound , .badge]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    print(userInfo)

    completionHandler()
  }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                       -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

  
      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }

}
