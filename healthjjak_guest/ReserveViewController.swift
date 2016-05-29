//
//  ReserveViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 17..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

//캘린더 웹뷰 뷰컨트롤러
class ReserveViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
	
	var division:String = ""
	var targetKey:String = ""
	var info:NSDictionary = [:]
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var loadingInfoLabel: UILabel!
	@IBOutlet weak var calendarWebView: UIWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		let session = UserSession.sharedInstance
		if !session.valid {
			let alertView = UIAlertController.init(title: "헬스짝 알림", message: "로그인이 필요한 메뉴입니다.", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler: { (action:UIAlertAction!) -> Void in
				self.navigationController?.popViewControllerAnimated(true)
			}))
			presentViewController(alertView, animated: true, completion: nil)
		}else{
			loadWebViewInit()
			calendarWebView.scrollView.bounces = false
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(true)
		
		self.navigationController?.interactivePopGestureRecognizer?.enabled = false
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
	}
	
	override func viewDidDisappear(animated: Bool) {
		self.navigationController?.interactivePopGestureRecognizer?.enabled = true
		self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
	}
	
	func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		return false
	}
	
	func sendScriptToWebview(scheduleKey:String) {
		calendarWebView.stringByEvaluatingJavaScriptFromString("deleteSchedule(\(scheduleKey))")
		print("call ok")
	}
	
	func loadWebViewInit(){
		let homeURL = NSURL(string:"https://healthjjak.com/webview/#/reserve/\(self.targetKey)")
		calendarWebView.loadRequest(NSURLRequest(URL: homeURL!))
	}
	
	func webViewDidStartLoad(webView: UIWebView) {
		loadingIndicator.startAnimating()
		loadingInfoLabel.hidden = false
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		loadingIndicator.stopAnimating()
		loadingInfoLabel.hidden = true
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let scheme:String = (request.URL?.absoluteString)!
		let schemeManager = schemeManage(scheme)
		
		for (functionName, functionParam) in schemeManager.functions {
			switch functionName {
				case "selectScheduleKeyDone":
				self.selectScheduleKeyDone(functionParam)
				break
			default:
				return false
			}
		}
		return true
	}
	
	func selectScheduleKeyDone(param:Dictionary<String,String>) {
		
		let nextView: PayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PayView") as! PayViewController
		
		nextView.scheduleKeyStr = param["scheduleKeyArr"]!
		nextView.scheduleKeyArr = param["scheduleKeyArr"]!.componentsSeparatedByString("_")
		
		presentViewController(nextView, animated: true, completion: nil)
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
