//
//  LoginViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 17..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func URLEncode(s: String) -> String {
		return (s as NSString).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
	}
	
	@IBAction func postLogin(sender: AnyObject) {
		let body = "user_id=\(URLEncode(emailTextField.text!))&user_password=\(URLEncode(passwordTextField.text!))"
		let bodyData = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
		
		let postURL = NSURL(string:"http://211.253.24.190/api/index.php/log/in")!
		let request = NSMutableURLRequest(URL: postURL)
		request.HTTPMethod = "POST"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
		request.HTTPBody = bodyData
		
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
				
				let httpResponse = response as? NSHTTPURLResponse
				let fields = httpResponse?.allHeaderFields as? [String:String]
				let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields!, forURL: NSURL(string:"http://211.253.24.190")!)
				NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: NSURL(string:"http://211.253.24.190")!, mainDocumentURL: NSURL(string:"http://211.253.24.190")!)
				for cookie in cookies {
					var cookieProperties = [String: AnyObject]()
					cookieProperties[NSHTTPCookieName] = cookie.name
					cookieProperties[NSHTTPCookieValue] = cookie.value
					cookieProperties[NSHTTPCookieDomain] = cookie.domain
					cookieProperties[NSHTTPCookiePath] = cookie.path
					cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
					cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
					
					let newCookie = NSHTTPCookie(properties: cookieProperties)
					NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie!)
					print("name: \(cookie.name) value: \(cookie.value)")
				}
				
				NSOperationQueue.mainQueue().addOperationWithBlock({
				if JSONData["state"] as! Int == 200 {
					let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("startPage")
					self.presentViewController(nextView!, animated: true, completion: nil)
				}else{
					let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "\(JSONData["msg"] as! String)", preferredStyle: UIAlertControllerStyle.Alert)
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
	
	@IBAction func cancelButtonAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if textField.restorationIdentifier != nil{
			if textField.restorationIdentifier! == "passwordField" {
				print("password")
			}
		}else{
			passwordTextField.becomeFirstResponder()
		}
		textField.resignFirstResponder()
		return true
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
