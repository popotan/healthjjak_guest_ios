//
//  LogoutViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 18..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

	@IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setViewStyle() {
		self.logoutButton.layer.masksToBounds = true
		self.logoutButton.layer.cornerRadius = 5.0
	}
	
	@IBAction func postLogoutAction(sender: AnyObject) {
		let postURL = NSURL(string:"http://211.253.24.190/api/index.php/log/out")!
		let request = NSMutableURLRequest(URL: postURL)
		request.HTTPMethod = "POST"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
		
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(request){
			data, response, error in
			if error != nil {
				print("Fail to post content")
			} else {
				print("Successfully posted.")
				print(data)
			}
			
			do{
				let JSONData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
				print(JSONData)
				
				let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(NSURL(string:"http://211.253.24.190")!)
				
				for cookie in cookies! {
					NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
				}
				
				NSOperationQueue.mainQueue().addOperationWithBlock({
					if JSONData["state"] as! Int == 200 {
						let userSession = UserSession.sharedInstance
						userSession.getValidInfo()
						
						let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("startPage")
						self.presentViewController(nextView!, animated: true, completion: nil)
					}else{
						let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "로그아웃에 실패하였습니다. 다시 시도해 주세요.", preferredStyle: UIAlertControllerStyle.Alert)
						alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
						self.presentViewController(alertView, animated: true, completion: nil)
					}
				})
			}catch{
				NSOperationQueue.mainQueue().addOperationWithBlock({
					let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "통신에 이상이 생겼습니다. 다시 시도해 주세요.", preferredStyle: UIAlertControllerStyle.Alert)
					alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
					self.presentViewController(alertView, animated: true, completion: nil)
				})
			}
		}
		task.resume()
	}
	
	@IBAction func cancelAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
