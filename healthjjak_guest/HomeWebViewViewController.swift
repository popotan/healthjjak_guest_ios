//
//  HomeWebViewViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 15..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class HomeWebViewViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate{
	
	@IBOutlet weak var loadingInfoLabel: UILabel!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var homeWebView: UIWebView!
	var refreshControl:UIRefreshControl!
	var refreshLoadingView: UIView!
	var refreshColorView: UIView!
	var refreshingLabel: UILabel!
	var refreshIndicator:UIImageView!
	
	var isRefreshIconsOverlap = false;
	var isRefreshAnimating = false;
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setupRefreshControl()
		homeWebView.scrollView.delegate = self
		homeWebView.scrollView.addSubview(self.refreshControl)
		
		//print(NSUserDefaults.standardUserDefaults())
		print(NSUserDefaults.standardUserDefaults().valueForKey("wasPerformed"))
		
		if NSUserDefaults.standardUserDefaults().valueForKey("wasPerformed") == nil || NSUserDefaults.standardUserDefaults().valueForKey("LOGGED") == nil {
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(true, forKey: "wasPerformed")
			
			let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginOrJoin")
			
			presentViewController(nextView!, animated: false, completion: nil)
		}else{
			loadWebViewInit()
		}
    }
	
	override func viewDidDisappear(animated: Bool) {
		self.navigationController?.hidesBarsOnSwipe = false
		self.navigationController?.setNavigationBarHidden(false, animated: true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setupRefreshControl() {
		
		// Programmatically inserting a UIRefreshControl
		self.refreshControl = UIRefreshControl()
		
		// Setup the loading view, which will hold the moving graphics
		self.refreshLoadingView = UIView(frame: self.refreshControl!.bounds)
		self.refreshLoadingView.frame = CGRectMake(0, 0, self.view.frame.width, self.refreshControl.frame.height) //UIRefreshControl의 높이는 60
		self.refreshLoadingView.backgroundColor = UIColor.clearColor()
		
		// Create the graphic image views
		self.refreshIndicator = UIImageView(image: UIImage(named: "refresh-icon.png"))
		refreshIndicator.frame = CGRectMake(self.view.frame.width/2 - 25, self.refreshControl.frame.height/2 - 25, 50, 50)
		
		// Add the graphics to the loading view
		self.refreshLoadingView.addSubview(self.refreshIndicator)
		
		// Clip so the graphics don't stick out
		self.refreshLoadingView.clipsToBounds = true;
		
		// Hide the original spinner icon
		self.refreshControl!.tintColor = UIColor.clearColor()
		
//		self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
//		self.refreshColorView.frame = CGRectMake(0, 0, self.refreshLoadingView.frame.width, self.refreshLoadingView.frame.height)
//		self.refreshColorView.backgroundColor = UIColor.clearColor()
		self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
		self.refreshColorView.frame = CGRectMake(0, 0, self.refreshLoadingView.frame.width, self.refreshLoadingView.frame.height)
		
		self.refreshingLabel = UILabel(frame: self.refreshControl!.bounds)
		self.refreshingLabel.text = "새로고침 중입니다..."
		self.refreshingLabel.textAlignment = NSTextAlignment.Center
		self.refreshingLabel.textColor = UIColor.darkGrayColor()
		self.refreshingLabel.font = UIFont(name: "System-Light", size: 14.0)
		self.refreshingLabel.alpha = 0.0
		self.refreshingLabel.frame = CGRectMake(0, 20, self.refreshLoadingView.frame.width, 20)
		
		// Add the loading and colors views to our refresh control
		self.refreshControl!.addSubview(self.refreshLoadingView)
		self.refreshControl!.addSubview(self.refreshColorView)
		self.refreshColorView.addSubview(self.refreshingLabel)
		
		// Initalize flags
		self.isRefreshIconsOverlap = false;
		self.isRefreshAnimating = false;
		
		// When activated, invoke our refresh function
		self.refreshControl?.addTarget(self, action: #selector(HomeWebViewViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		self.refreshIndicator.transform = CGAffineTransformMakeRotation(CGFloat(6.28313 * (self.refreshControl.frame.origin.y/100)))
		
		self.refreshControl.alpha = {() -> CGFloat in
				if self.refreshControl.frame.origin.y < 100 {
					return (-1 * self.refreshControl.frame.origin.y) / 100
				}else{
					return 1.0
				}
			}()
	}
	
	func refresh(){
		self.homeWebView.reload()
		animateRefreshView()
	}
	
	func animateRefreshView() {
		// Background color to loop through for our color view
//		var colorArray = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.orangeColor(), UIColor.magentaColor()]
		
		// In Swift, static variables must be members of a struct or class
//		struct ColorIndex {
//			static var colorIndex = 0
//		}
		
		// Flag that we are animating
		self.isRefreshAnimating = true
		
				UIView.animateWithDuration(
					Double(0.2),
					delay: Double(0.0),
					options: UIViewAnimationOptions.TransitionCrossDissolve,
					animations: {
		
						// Change the background color
						self.refreshIndicator.alpha = 0
						self.refreshingLabel.alpha = 1
					},
					completion: { finished in
						// If still refreshing, keep spinning, else reset
						if (self.refreshControl!.refreshing) {
							self.animateRefreshView()
						}else {
							self.resetAnimation()
						}
					}
				)
	}
	
	func resetAnimation() {
		self.isRefreshAnimating = false
		self.refreshIndicator.alpha = 1
		self.refreshingLabel.alpha = 0
	}
	
	func loadWebViewInit(){
		let homeURL = NSURL(string:"https://healthjjak.com/webview/")
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
		
		self.refreshControl!.endRefreshing()
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
