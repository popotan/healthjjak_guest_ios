//
//  PayViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 5..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class PayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var scheduleKeyStr = ""
	var scheduleKeyArr = []
	var info:NSArray = []
	
	var payMethod = ""
	var totalPrice:Int = 0 {
		willSet{
			
		}
		didSet{
			self.VAT = Int(Double(totalPrice) * 0.1)
		}
	}
	var VAT: Int = 0

	@IBOutlet weak var cardButton: UIButton!
	@IBOutlet weak var directBankButton: UIButton!
	@IBOutlet weak var payMethodSelectSubView: UIView!
	@IBOutlet weak var payInfoSubView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var selectScheduleLengthLabel: UILabel!
	@IBOutlet weak var unitPriceLabel: UILabel!
	@IBOutlet weak var totalPriceLabel: UILabel!
	@IBOutlet weak var payButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		getScheduleInfo()
		setViewStyle()
		setLabelText()
    }
	
	override func viewWillAppear(animated: Bool) {
		scrollView.frame = CGRectMake(0, 20, self.view.frame.width, self.view.frame.height - 20)
		scrollView.contentSize = CGSizeMake(320, 700)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func getScheduleInfo() {
		let baseURL = NSURL(string: "http://211.253.24.190/api/index.php/schedule/infoByArray/get?scheduleKeyStrArr=\(self.scheduleKeyStr)")
		
		do{
			let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: .MutableContainers) as! NSDictionary
			
			if JSONData["state"] as! Int == 200 {
				self.info = JSONData["res"] as! NSArray
			}else{
				let alertView = UIAlertController.init(title: "헬스짝 알림", message: JSONData["msg"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
				presentViewController(alertView, animated: true, completion: nil)
			}
		}catch{
			let alertView = UIAlertController.init(title: "헬스짝 알림", message: "통신에 이상이 생겼습니다. 네트워크 환경을 다시 한 번 확인해 주시기 바랍니다.", preferredStyle: UIAlertControllerStyle.Alert)
			presentViewController(alertView, animated: true, completion: {
			self.dismissViewControllerAnimated(true, completion: nil)
			})
		}
	}
	
	func setViewStyle() {
		self.payButton.layer.cornerRadius = 5.0
		self.payButton.layer.masksToBounds = true
		
		self.payInfoSubView.layer.cornerRadius = 5.0
		self.payInfoSubView.layer.masksToBounds = true
		
		self.payMethodSelectSubView.layer.cornerRadius = 5.0
		self.payMethodSelectSubView.layer.masksToBounds = true
	}
	
	func setLabelText() {
		selectScheduleLengthLabel.text = "선택한 스케쥴 : \(scheduleKeyArr.count)개"
		
		for schedule in self.info {
			self.totalPrice = self.totalPrice + (schedule["member"]!!["hm"]!!["agrmt"]!!["info"]!!["price"] as! Int)
		}
		
		totalPriceLabel.text = "총 결제가격 : \(self.totalPrice + self.VAT)원"
	}
	
	@IBAction func cancelAction(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func directBankSelect(sender: AnyObject) {
		self.cardButton.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
		self.directBankButton.backgroundColor = UIColor(red: 29/255, green: 114/255, blue: 200/255, alpha: 1)
		
		self.payMethod = "bank"
	}
	
	@IBAction func cardSelect(sender: AnyObject) {
		self.directBankButton.backgroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
		self.cardButton.backgroundColor = UIColor(red: 29/255, green: 114/255, blue: 200/255, alpha: 1)
		
		self.payMethod = "wcard"
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.scheduleKeyArr.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
		
		cell.textLabel!.text = "\(self.info[indexPath.row]["schedule"]!!["s_date"] as! String)  \(self.info[indexPath.row]["schedule"]!!["s_time"] as! String)"
		cell.detailTextLabel!.text = "\(self.info[indexPath.row]["member"]!!["hm"]!!["info"]!!["name"] as! String) / \(self.info[indexPath.row]["member"]!!["fitness"]!!["info"]!!["center_name"] as! String)"
		
		return cell
	}

	@IBAction func doPayAction(sender: AnyObject) {
		if self.payMethod == "" {
			let alertView = UIAlertController.init(title: "결제수단선택", message: "결제수단을 선택 해주세요!", preferredStyle: .Alert)
			alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler: nil))
			self.presentViewController(alertView, animated: true, completion: nil)
		}else{
			//결제화면 진행
			let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("INIPayWebView") as! INIPayWebViewViewController
			
			nextView.payMethod = self.payMethod
			nextView.P_NOTI = scheduleKeyStr.stringByReplacingOccurrencesOfString("_", withString: ".")
			nextView.P_OID = ""
			nextView.P_GOODS = "헬스짝스케쥴결제\(self.scheduleKeyArr.count)개"
			nextView.P_AMT = self.totalPrice + self.VAT
			nextView.P_TAX = self.VAT
			
			self.presentViewController(nextView, animated: true, completion: nil)
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
