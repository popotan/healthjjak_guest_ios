//
//  JoinViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 16..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class LoginOrJoinViewController : UIViewController {
	
	var cancelAble : Bool = false
	
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var welcomeImage: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if !cancelAble {
			cancelButton.hidden = true
		}
		
		//let gifImage = UIImage.gifWithName("")
		//welcomeImage.image = UIImageView(image: gifImage)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	@IBAction func cancelAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}

class JoinScrollViewController : UIScrollView{
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.superview?.touchesBegan(touches, withEvent: event)
	}
}

class JoinViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {

	var infoInstance = JoinInfoManage.instance
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var passwordCheckField: UITextField!
	@IBOutlet weak var birthField: UITextField!
	@IBOutlet weak var verifyCodeField: UITextField!
	@IBOutlet weak var genderSegmentedControl: UISegmentedControl!
	@IBOutlet weak var formScrollView: JoinScrollViewController!
	@IBOutlet weak var gotoStartPageButton: UIButton!
	@IBOutlet weak var joinButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

		if self.restorationIdentifier != nil && self.restorationIdentifier! == "joinForm" {
		self.formScrollView.contentSize = CGSize(width: 320, height: 422)
			
			NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JoinViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
			NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(JoinViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
		}
		if self.restorationIdentifier != nil && self.restorationIdentifier! == "welcome" {
			self.navigationController?.setNavigationBarHidden(true, animated: true)
			
			postLogin()
			
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
			formScrollView.setContentOffset(CGPointMake(0.0, (keyboardSize.height - 40.0)), animated: true)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
			formScrollView.setContentOffset(CGPointMake(0.0, 0.0), animated: true)
		}
	}
	
	func postLogin() {
		let body = "user_id=\(URLEncode(self.infoInstance.email!))&user_password=\(URLEncode(infoInstance.password!))"
		let bodyData = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
		
		let postURL = NSURL(string:"https://healthjjak.com/api/index.php/log/in")!
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
				let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields!, forURL: NSURL(string:"https://healthjjak.com")!)
				NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: NSURL(string:"https://healthjjak.com")!, mainDocumentURL: NSURL(string:"https://healthjjak.com")!)
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
				}
				
				let userDefaults = NSUserDefaults.standardUserDefaults()
				userDefaults.setBool(true, forKey: "LOGGED")
				
				NSOperationQueue.mainQueue().addOperationWithBlock({
					if JSONData["state"] as! Int == 200 {
						//성공시
						let userSession = UserSession.sharedInstance
						userSession.getValidInfo()
						
						self.gotoStartPageButton.hidden = false
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

	
	func URLEncode(s: String) -> String {
		return (s as NSString).stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
	}
	
	@IBAction func joinCancelAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
    
	@IBAction func doubletCheck(sender: AnyObject) {
		if emailField.text! != "" && emailField.text!.isEmail {
		let body = "email=\(URLEncode(emailField.text!))"
		let bodyData = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
		
		let postURL = NSURL(string:"https://healthjjak.com/api/index.php/join/emailCheck")!
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
			}
			
			do {
				let JSONData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary

				NSOperationQueue.mainQueue().addOperationWithBlock({
					if JSONData["res"] as! Bool {
						self.infoInstance.email = self.emailField.text!
						self.performSegueWithIdentifier("InputPhone", sender: nil)
					}else{
						let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: (JSONData["msg"] as! String), preferredStyle: UIAlertControllerStyle.Alert)
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
			
		}else{
			let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "이메일 주소를 입력해 주세요!", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
			self.presentViewController(alertView, animated: true, completion: nil)
		}
	}

	@IBAction func sendAuthKey(sender: AnyObject) {
		if phoneField.text! != "" {
			let body = "phone=\(URLEncode(phoneField.text!))"
			let bodyData = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
			
			let postURL = NSURL(string:"https://healthjjak.com/api/index.php/certificationKey/send_phone")!
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
				}
				
				do {
					let JSONData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
					
					NSOperationQueue.mainQueue().addOperationWithBlock({
						if JSONData["res"] as! Bool {
							self.infoInstance.phone = self.phoneField.text!
							self.infoInstance.certiKeyHash = JSONData["code"] as? String
							self.performSegueWithIdentifier("InputAuthKey", sender: nil)
						}else{
							let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: (JSONData["msg"] as! String), preferredStyle: UIAlertControllerStyle.Alert)
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
			
		}else{
			let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "문자 수신이 가능한 핸드폰 번호를 입력해 주세요!", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
			self.presentViewController(alertView, animated: true, completion: nil)
		}
	}
	
	@IBAction func checkAuthKey(sender: AnyObject) {
		if verifyCodeField.text! != "" {
			let body = "code=\(URLEncode(verifyCodeField.text!))&hash=\(URLEncode(self.infoInstance.certiKeyHash!))"
			let bodyData = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
			
			let postURL = NSURL(string:"https://healthjjak.com/api/index.php/certificationKey/check")!
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
				}
				
				do {
					let JSONData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
					
					NSOperationQueue.mainQueue().addOperationWithBlock({
						if JSONData["res"] as! Bool {
							self.infoInstance.certiKey = self.verifyCodeField.text!
							self.performSegueWithIdentifier("InputForm", sender: nil)
						}else{
							let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: (JSONData["msg"] as! String), preferredStyle: UIAlertControllerStyle.Alert)
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
			
		}else{
			let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "문자로 발송된 인증코드를 입력해 주세요!", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
			self.presentViewController(alertView, animated: true, completion: nil)
		}
		
	}
	
	@IBAction func postForm(sender: AnyObject) {
		if passwordField.text! != passwordCheckField.text!{
			let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "비밀번호가 일치하지 않습니다. 다시 입력해주세요!", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
			self.presentViewController(alertView, animated: true, completion: nil)
		}else{
		
		if nameField.text! != "" && passwordField.text! != "" && passwordCheckField.text! != "" && birthField.text! != "" {
			infoInstance.birth = birthField.text!
			infoInstance.gender = genderSegmentedControl.selectedSegmentIndex + 1
			infoInstance.password = passwordField.text!
			infoInstance.passwordCheck = passwordCheckField.text!
			
			var body = "email=\(infoInstance.email!)"
			body += "&phone=\(infoInstance.phone!)"
			body += "&password=\(passwordField.text!)"
			body += "&birth=\(birthField.text!)"
			body += "&gender=\(genderSegmentedControl.selectedSegmentIndex + 1)"
			body += "&name=\(nameField.text!)"
			let bodyData = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
			print(bodyData)
			
			let postURL = NSURL(string:"https://healthjjak.com/api/index.php/join/guest/post")!
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
				}
				
				do {
					let JSONData = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
					
					NSOperationQueue.mainQueue().addOperationWithBlock({
						if JSONData["res"] as! Bool {
							self.performSegueWithIdentifier("GoWelcomePage", sender: nil)
						}else{
							let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: (JSONData["msg"] as! String), preferredStyle: UIAlertControllerStyle.Alert)
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
			
		}else{
			let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "비어있는 곳을 채워주세요!", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
			self.presentViewController(alertView, animated: true, completion: nil)
		}
		}
	}
	
	@IBAction func gotoStartPage(sender: AnyObject) {
		let nextPage = self.storyboard?.instantiateViewControllerWithIdentifier("startPage")
		presentViewController(nextPage!, animated: true, completion: nil)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.view.endEditing(true)
	}

	func textFieldShouldReturn(textField: UITextField) -> Bool {
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
