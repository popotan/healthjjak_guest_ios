//
//  HomeWebViewViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 15..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class HomeWebViewViewController: UIViewController, UIWebViewDelegate{
	
	@IBOutlet weak var loadingInfoLabel: UILabel!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var homeWebView: UIWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		//print(NSUserDefaults.standardUserDefaults())
		print(NSUserDefaults.standardUserDefaults().valueForKey("wasPerformed"))
		
		if NSUserDefaults.standardUserDefaults().valueForKey("wasPerformed") == nil {
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(true, forKey: "wasPerformed")
			
			let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginOrJoin")
			
			presentViewController(nextView!, animated: false, completion: nil)
		}
		
		loadWebViewInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loadWebViewInit(){
		let homeURL = NSURL(string:"http://211.253.24.190/webview/")
		homeWebView.loadRequest(NSURLRequest(URL: homeURL!))
	}

	@IBAction func edgeSwipeAction(sender: AnyObject) {
		homeWebView.goBack()
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
			case "showInfo":
				self.showInfo(functionParam)
				break
			default:
				return false
			}
		}
		
		return true
	}
	
	func showInfo(param:Dictionary<String,String>) {
		let nextView: InfoWebViewViewController = self.storyboard?.instantiateViewControllerWithIdentifier("infoView") as! InfoWebViewViewController
		
		nextView.division = param["division"]!
		nextView.targetKey = param["targetKey"]!
		
		self.navigationController?.pushViewController(nextView, animated: true)
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
