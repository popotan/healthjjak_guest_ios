//
//  InfoWebViewViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 16..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class InfoWebViewViewController: UIViewController, UIWebViewDelegate{
	
	var division:String!
	var targetKey:String!
	var info:NSDictionary!
	var agrmt:NSDictionary!
	let selectedScheduleKeyInfo = SelectedScheduleInfo.instance
	
	
	@IBOutlet weak var loadingInfoLabel: UILabel!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var infoWebView: UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		if getMemberInfo() {
			if checkAgrmt() {
				loadWebViewInit()
				setNativeOutlets()
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func loadWebViewInit(){
		let homeURL = NSURL(string:"http://211.253.24.190/webview/#/info/\(self.division)/\(self.targetKey)")
		infoWebView.loadRequest(NSURLRequest(URL: homeURL!))
	}
	
	func setNativeOutlets(){
		navigationItem.title = (self.info["name"] as! String)
	}
	
	@IBAction func selectButtonAction(sender: AnyObject) {
		let nextView: ReserveViewController = self.storyboard?.instantiateViewControllerWithIdentifier("calendarView") as! ReserveViewController
		
		nextView.division = self.division
		nextView.targetKey = self.targetKey
		nextView.info = self.info
		selectedScheduleKeyInfo.agrmt = self.agrmt
		
		self.navigationController?.pushViewController(nextView, animated: true)
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		return true
	}
	
	func webViewDidStartLoad(webView: UIWebView) {
		loadingIndicator.startAnimating()
		loadingInfoLabel.hidden = false
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		loadingIndicator.stopAnimating()
		loadingInfoLabel.hidden = true
	}
	
	func getMemberInfo() -> Bool {
		
		var JSONData:NSDictionary
		
		let baseURL = NSURL(string:"http://211.253.24.190/api/index.php/info/\(self.division)?targetKey=\(self.targetKey)")
		
		do{
			JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			if (JSONData["state"] as! Int) == 200 {
				JSONData = JSONData["res"] as! NSDictionary
			}else{
				let alertView = UIAlertController.init(title: "헬스짝 알림", message: JSONData["msg"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
				presentViewController(alertView, animated: true, completion: nil)
			}
			//print(JSONData)
			
			switch self.division {
			case "hm":
				let infoManager = hmInfoManage(memberKey: self.targetKey, info: JSONData["info"] as! NSDictionary, agrmt: JSONData["agrmt"] as! NSDictionary)
				self.info = infoManager.info
				self.agrmt = infoManager.agrmt
				break
				case "fitness":
					let infoManager = fitnessInfoManage(memberKey: self.targetKey, info: JSONData["info"] as! NSDictionary, agrmt: JSONData["agrmt"] as! NSDictionary)
					self.info = infoManager.info
					self.agrmt = infoManager.agrmt
				break
			default:
				break
			}
			
			return true
		}catch{
			print("Error")
			return false
		}
	}
	
	func checkAgrmt() -> Bool {
		if !(self.agrmt["valid"] as! Bool) {
			let alertView = UIAlertController.init(title: "헬스짝 알림", message: "계약이 종료된 회원입니다.", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler: { (action:UIAlertAction!) -> Void in
				self.navigationController?.popViewControllerAnimated(true)
			}))
		presentViewController(alertView, animated: true, completion: nil)
			return false
		}else{
			return true
		}
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
