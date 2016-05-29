//
//  IamportViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 22..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class IamportViewController: UIViewController, UIWebViewDelegate {
	
	let user = UserSession.sharedInstance
	
	var payMethod = ""
	var P_NOTI = ""
	var P_OID = ""
	var P_GOODS = ""
	var P_AMT = 0
	var P_TAX = 0

	@IBOutlet weak var iamportWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		loadRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loadRequest() {
		let baseURL = NSURL(string: "https://healthjjak.com/webview/iamport/start.html")
		
		iamportWebView.loadRequest(NSURLRequest(URL: baseURL!))
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let scheme:String = (request.URL?.absoluteString)!
		let schemeManager = schemeManage(scheme)
		
		for (functionName, functionParam) in schemeManager.functions {
			switch functionName {
			case "requestPayInfo":
				self.setValues()
				break
			case "success":
				self.success(functionParam)
				break
			case "cancel":
				self.cancel(functionParam)
				break
			default:
				return false
			}
		}
		return true
	}
	
	func setValues() {
		var script = "setValues("
		//pg_name
		script += " 'inicis' "
		//paymethod
		script += ", '\(self.payMethod)' "
		//상품명
		script += ", '\(self.P_GOODS)' "
		//amount
		script += ", \(self.P_AMT)"
		//buyer_name
		script += ", '\(self.user.info["name"] as! String)' "
		//buyer_email
		script += ", '\(self.user.info["email"] as! String)' "
		//buyer_tel
		script += ", '\(self.user.info["phone"] as! String)' "
		//스케줄키
		script += ", '\(self.P_NOTI)' "
		script += ")"
		
		iamportWebView.stringByEvaluatingJavaScriptFromString(script)
	}
	
	func success(params: Dictionary<String,String>) {
		print("성공")
		let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("PayResultView") as! PayResultViewController
		nextView.result = true
		self.presentViewController(nextView, animated: true, completion: nil)
	}
	
	func cancel(params : Dictionary<String,String>) {
		print("취소")
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
