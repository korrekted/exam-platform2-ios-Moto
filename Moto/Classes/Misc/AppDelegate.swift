//
//  AppDelegate.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit
import RxCocoa
import Firebase
import OtterScaleiOS
import RushSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    lazy var sdkProvider = SDKProvider()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        NumberLaunches().launch()
        
        let vc = SplashViewController.make()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        FacebookManager.shared.initialize(app: application, launchOptions: launchOptions)
        BranchManager.shared.initialize(launchOptions: launchOptions)
        AmplitudeManager.shared.initialize()
        FirebaseManager.shared.initialize()
        OtterScale.shared.initialize(host: GlobalDefinitions.otterScaleHost, apiKey: GlobalDefinitions.otterScaleApiKey)
        
        PurchaseValidationObserver.shared.startObserve()
        TestCloseObserver.shared.startObserve()
        
        runProvider(on: vc.view)
        
        sdkProvider.application(application, didFinishLaunchingWithOptions: launchOptions)
        SDKStorage.shared.pushNotificationsManager.application(didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        sdkProvider.application(app, open: url, options: options)
        
        FacebookManager.shared.application(app, open: url, options: options)
        BranchManager.shared.application(app, open: url, options: options)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        sdkProvider.application(application, continue: userActivity, restorationHandler: restorationHandler)
        
        BranchManager.shared.application(continue: userActivity)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        sdkProvider.applicationDidBecomeActive(application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SDKStorage.shared.pushNotificationsManager.application(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SDKStorage.shared.pushNotificationsManager.application(didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        SDKStorage.shared.pushNotificationsManager.application(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
    }
}

// MARK: Private
private extension AppDelegate {
    func runProvider(on view: UIView) {
        let settings = SDKSettings(backendBaseUrl: GlobalDefinitions.sdkDomainUrl,
                                   backendApiKey: GlobalDefinitions.sdkApiKey,
                                   amplitudeApiKey: nil,
                                   appsFlyerApiKey: GlobalDefinitions.appsFlyerApiKey,
                                   facebookActive: false,
                                   branchActive: false,
                                   firebaseActive: false,
                                   applicationTag: GlobalDefinitions.applicationTag,
                                   userToken: SessionManager().getSession()?.userToken,
                                   userId: nil,
                                   view: view,
                                   shouldAddStorePayment: true,
                                   featureAppBackendUrl: GlobalDefinitions.domainUrl,
                                   featureAppBackendApiKey: GlobalDefinitions.apiKey,
                                   appleAppID: GlobalDefinitions.appStoreId)
            
        
        sdkProvider.initialize(settings: settings)
    }
}
