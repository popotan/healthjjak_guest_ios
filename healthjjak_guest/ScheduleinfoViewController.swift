//
//  ScheduleinfoViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 14..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class ScheduleinfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var scheduleKey = ""
	var info = [:]
	var member = ["hm":[:],"fitness":[:]]
	var session = [:]
	var training = []

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var scheduleDateTimeLabel: UILabel!
	@IBOutlet weak var fitnessLogoImg: UIImageView!
	@IBOutlet weak var fitnessNameLabel: UILabel!
	@IBOutlet weak var hmLogoImg: UIImageView!
	@IBOutlet weak var hmNameLabel: UILabel!
	@IBOutlet weak var trainingListTable: UITableView!
	@IBOutlet weak var scheduleInfoView: UIView!
	@IBOutlet weak var trainingListView: UIView!
	@IBOutlet weak var sessionInfoView: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		getTrainingInfo()
		setLabelText()
		setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		
		//trainingTable 스크롤 막기
		self.trainingListTable.scrollEnabled = false
		
		var nextViewPositionY:CGFloat = 180 + 8 + 8
		
		//트레이닝정보 뷰 조정
		self.trainingListView.frame = CGRectMake(8, nextViewPositionY, self.view.frame.width - 16, 37 + CGFloat(training.count*40))
		
		//트레이닝내역 테이블 조정
		self.trainingListTable.frame = CGRectMake(0, 37, self.trainingListView.frame.width, CGFloat(training.count*40))
		
		nextViewPositionY = nextViewPositionY + self.trainingListView.frame.height + 8
		
		//세션정보 뷰 조정
		self.sessionInfoView.frame = CGRectMake(8, nextViewPositionY, self.view.frame.width - 16, 103)
		
		nextViewPositionY = nextViewPositionY + self.sessionInfoView.frame.height + 8
		
		self.scrollView.contentSize = CGSizeMake(self.view.frame.width, nextViewPositionY)
	}
	
	func setLabelText() {
		self.navigationItem.title = "상세정보"
		
		self.scheduleDateTimeLabel.text = {
			let formatter1 = NSDateFormatter()
			formatter1.dateFormat = "Y-MM-dd"
			let sDateFromString = formatter1.dateFromString((self.info["s_date"] as? String)!)
			let formatter2 = NSDateFormatter()
			formatter2.dateFormat = "MM.dd E"
			
			let formatter3 = NSDateFormatter()
			formatter3.dateFormat = "HH:m:s"
			formatter3.timeStyle = .MediumStyle
			let sTimeFromString = formatter3.dateFromString((self.info["s_time"] as? String)!)
			let formatter4 = NSDateFormatter()
			formatter4.dateFormat = "a hh:mm"
			formatter4.locale = NSLocale(localeIdentifier: "ko_KR")
			formatter4.AMSymbol = "오전"
			formatter4.PMSymbol = "오후"
			formatter4.timeZone = NSTimeZone(name: "KST")
			return "\(formatter2.stringFromDate(sDateFromString!)) \(formatter4.stringFromDate(sTimeFromString!))"
		}()
		
		self.hmNameLabel.text = "\(member["hm"]!["info"]!["name"] as! String)"
		self.fitnessNameLabel.text = "\(member["fitness"]!["info"]!["center_name"] as! String)"
		
		self.hmLogoImg.image = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://healthjjak.com/html/userimgs/\(self.member["hm"]!["info"]!["logo_img"] as! String)")!)!)
		self.fitnessLogoImg.image = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://healthjjak.com/html/userimgs/\(self.member["fitness"]!["info"]!["logo_img"] as! String)")!)!)
	}
	
	func setViewStyle() {
//		self.trainingListView.layer.cornerRadius = 5.0
//		self.trainingListView.layer.masksToBounds = true
//		
//		self.scheduleInfoView.layer.cornerRadius = 5.0
//		self.scheduleInfoView.layer.masksToBounds = true
//		
//		self.sessionInfoView.layer.cornerRadius = 5.0
//		self.sessionInfoView.layer.masksToBounds = true
		
		self.fitnessLogoImg.layer.cornerRadius = self.fitnessLogoImg.frame.width / 2
		self.fitnessLogoImg.layer.masksToBounds = true
		
		self.hmLogoImg.layer.cornerRadius = self.hmLogoImg.frame.width / 2
		self.hmLogoImg.layer.masksToBounds = true
	}
	
	func getTrainingInfo(){
		let baseURL = NSURL(string: "https://healthjjak.com/api/index.php/document/trcard/get?targetKey=\(self.scheduleKey)")

		do{
			let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: .MutableContainers) as! NSDictionary
			
			if JSONData["state"] as! Int == 200 {
				self.training = JSONData["res"] as! NSArray
				self.trainingListTable.reloadData()
			}else{
				let alertView = UIAlertController.init(title: "헬스짝 알림", message: JSONData["msg"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
				alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler: nil))
				presentViewController(alertView, animated: true, completion: nil)
			}
		}catch{
			let alertView = UIAlertController.init(title: "헬스짝 알림", message: "스케쥴을 가져오는데에 실패하였습니다.", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction(title: "확인", style: .Default, handler: nil))
			presentViewController(alertView, animated: true, completion: nil)
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.training.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("trainingList")!
		
		cell.textLabel?.text = "\(self.training[indexPath.row]["training_name"] as! String)"
		cell.detailTextLabel?.text = "\(self.training[indexPath.row]["count1"] as! Int)\(self.training[indexPath.row]["count1_unit"] as! String) X \(self.training[indexPath.row]["count2"] as! Int)\(self.training[indexPath.row]["count2_unit"] as! String)"
		
		return cell
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	@IBAction func fitnessPhoneCall(sender: AnyObject) {
		UIApplication.sharedApplication().openURL(NSURL(string: "telprompt:\(self.member["fitness"]!["info"]!["fitness_phone1"] as! String)\(self.member["fitness"]!["info"]!["fitness_phone2"] as! String)\(self.member["fitness"]!["info"]!["fitness_phone3"] as! String)")!)
	}
	
	@IBAction func hmPhoneCall(sender: AnyObject) {
	UIApplication.sharedApplication().openURL(NSURL(string: "telprompt:\(self.member["hm"]!["info"]!["phone1"] as! String)\(self.member["hm"]!["info"]!["phone2"] as! String)\(self.member["hm"]!["info"]!["phone3"] as! String)")!)
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
