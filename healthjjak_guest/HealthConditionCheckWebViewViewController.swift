//
//  HealthConditionCheckWebViewViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 8..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class HealthConditionCheckWebViewViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var healthCheckWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		loadWebViewInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loadWebViewInit(){
		let homeURL = NSURL(string:"https://healthjjak.com/webview/#/healthCheck")
		healthCheckWebView.loadRequest(NSURLRequest(URL: homeURL!))
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let scheme:String = (request.URL?.absoluteString)!
		let schemeManager = schemeManage(scheme)
		
		for (functionName, functionParam) in schemeManager.functions {
			switch functionName {
			case "posted":
				let alertView = UIAlertController.init(title: "작성완료", message: "[스케쥴예약]을 다시 시도해 주시기 바랍니다.", preferredStyle: UIAlertControllerStyle.Alert)
				alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler:{(action:UIAlertAction!) -> Void in
					self.dismissViewControllerAnimated(true, completion: nil)
				}))
				presentViewController(alertView, animated: true, completion: nil)

				break
				case "cancel":
					let alertView = UIAlertController.init(title: "작성취소", message: "작성을 취소하셨습니다.", preferredStyle: UIAlertControllerStyle.Alert)
					alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler:{(action:UIAlertAction!) -> Void in
					self.dismissViewControllerAnimated(true, completion: nil)
					}))
					presentViewController(alertView, animated: true, completion: nil)
				break
			default:
				return false
			}
		}
		return true
	}
	
	func webViewDidStartLoad(webView: UIWebView) {
		
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		
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
