//
//  ReserveViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 17..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit


//선택창 뷰클래스
class ReserveContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	let selectedScheduleKeyInfo = SelectedScheduleInfo.instance
	
	@IBOutlet weak var vatLabel: UILabel!
	@IBOutlet weak var unitPriceLabel: UILabel!
	@IBOutlet weak var totalScheduleLengthLabel: UILabel!
	@IBOutlet weak var totalPriceLabel: UILabel!
	@IBOutlet weak var selectedTableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.labelUpdate()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func labelUpdate() {
		totalPriceLabel.text = "결제예정금액 : \(selectedScheduleKeyInfo.finalPriceToPay)원"
		vatLabel.text = "부가세 : \(selectedScheduleKeyInfo.vatPrice)원"
		unitPriceLabel.text = "단위가격 : \((selectedScheduleKeyInfo.agrmt["info"]! as! NSDictionary)["price"]! as! String)원"
		totalScheduleLengthLabel.text = "총 \(selectedScheduleKeyInfo.selectedScheduleKey.count)개 스케쥴 선택"
	}
	
	@IBAction func backButtonAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func gotoReservePageAction(sender: AnyObject) {
		print("selected")
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return selectedScheduleKeyInfo.selectedScheduleKey.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("selectedScheduleCell", forIndexPath: indexPath) as! SelectedScheduleCell
		cell.fitnessNameLabel.text = selectedScheduleKeyInfo.selectedScheduleKey[indexPath.row]
		return cell
	}
	
	func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
		let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "일정삭제", handler: {
		action, indexPath in
			self.selectedScheduleKeyInfo.removeScheduleKey(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
			self.labelUpdate()
		})
		return [deleteAction]
	}
}

//선택창 테이블셀 클래스
class SelectedScheduleCell: UITableViewCell {
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var fitnessNameLabel: UILabel!
}

//캘린더 웹뷰 뷰컨트롤러
class ReserveViewController: UIViewController, UIWebViewDelegate {
	
	var division:String = ""
	var targetKey:String = ""
	var info:NSDictionary = [:]
	let selectedScheduleKeyInfo = SelectedScheduleInfo.instance

	
	@IBOutlet weak var selectedNotiButton: UIButton!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var loadingInfoLabel: UILabel!
	@IBOutlet weak var calendarWebView: UIWebView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		let session = UserSession.sharedInstance
		session.getValidInfo()
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
		
		selectedNotiButton.setTitle("총 \(self.selectedScheduleKeyInfo.selectedScheduleKey.count)개 스케쥴 선택", forState: UIControlState.Normal)
	}
	
	func sendScriptToWebview(scheduleKey:String) {
		calendarWebView.stringByEvaluatingJavaScriptFromString("deleteSchedule(\(scheduleKey))")
		print("call ok")
	}
	
	func loadWebViewInit(){
		let homeURL = NSURL(string:"http://211.253.24.190/webview/#/reserve/\(self.targetKey)")
		calendarWebView.loadRequest(NSURLRequest(URL: homeURL!))
	}
	
	func webViewDidStartLoad(webView: UIWebView) {
		loadingIndicator.startAnimating()
		loadingInfoLabel.hidden = false
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		loadingIndicator.stopAnimating()
		loadingInfoLabel.hidden = true
		selectedScheduleKeyInfo.selectedScheduleKey = []
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		let scheme:String = (request.URL?.absoluteString)!
		let schemeManager = schemeManage(scheme)
		
		for (functionName, functionParam) in schemeManager.functions {
			switch functionName {
			case "addScheduleKey":
				self.addScheduleKey(functionParam)
				break
			case "removeScheduleKey":
				self.removeScheduleKey(functionParam)
				break
			default:
				return false
			}
		}
		return true
	}
	
	func addScheduleKey(param:Dictionary<String,String>) {
		selectedScheduleKeyInfo.addScheduleKey(param["scheduleKey"]!)
		
		selectedNotiButton.setTitle("총 \(self.selectedScheduleKeyInfo.selectedScheduleKey.count)개 스케쥴 선택", forState: UIControlState.Normal)
	}
	
	func removeScheduleKey(param:Dictionary<String,String>) {
		selectedScheduleKeyInfo.removeScheduleKey(param["scheduleKey"]!)
		
		selectedNotiButton.setTitle("총 \(self.selectedScheduleKeyInfo.selectedScheduleKey.count)개 스케쥴 선택", forState: UIControlState.Normal)
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
