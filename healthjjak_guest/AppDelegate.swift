//
//  AppDelegate.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 14..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func getCookies() {
		//쿠키가져오기
		let cookiesData = NSUserDefaults.standardUserDefaults().objectForKey("cookies")
		if cookiesData != nil {
			let cookies: NSArray = NSKeyedUnarchiver.unarchiveObjectWithData(cookiesData as! NSData) as! NSArray
			
			for cookie in cookies {
				if(cookie.name! == "healthjjaksession"){
					NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie as! NSHTTPCookie)
				}
			}
		}
	}

	func saveCookies() {
		//쿠키저장하기
		let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
		let cookieData = NSKeyedArchiver.archivedDataWithRootObject(cookies!)
		
		NSUserDefaults.standardUserDefaults().setObject(cookieData, forKey: "cookies")
	}

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		
		//푸시알림유형 등록
		let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
		let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
		application.registerUserNotificationSettings(pushNotificationSettings)
		application.registerForRemoteNotifications()
		
		return true
	}
	
	//푸시알림을 위한 델리게이트 메소드
	func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
		print("DEVICE TOKEN = \(deviceToken.description)")
		//나중에 <,>,공백 제거하여 저장
		let userSession = UserSession.sharedInstance
		userSession.deviceTokenFullString = deviceToken.description
	}
	
	//푸시알림 실패시 델리게이트 메소드
	func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		print(error)
	}
	
//	//푸시알림을 통해 실행됐을 때 델리게이트 메소드
//	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//		print(userInfo)
//	}
	
	
	func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		if (UIApplication.sharedApplication().applicationState == UIApplicationState.Inactive) {
			// 백그라운드에서 푸쉬 수신 후 사용자 클릭으로 실행된 경우
			print("in Background \(userInfo)")
		}
		else {
			// 앱 실행 중 푸쉬를 받은 경우
			print("in exe \(userInfo)")
				// call the completion handler
				// -- pass in NoData, since no new data was fetched from the server.
				completionHandler(UIBackgroundFetchResult.NoData)
			}
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
		
		saveCookies()
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		getCookies()
		let userSession = UserSession.sharedInstance
		userSession.getValidInfo()
		
		//실행시 뱃지 초기화
		UIApplication.sharedApplication().applicationIconBadgeNumber = 0
		
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		
		saveCookies()
	}
}

