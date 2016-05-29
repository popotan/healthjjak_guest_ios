//
//  MyScheduleListViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 1..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class MyScheduleTableCell : UITableViewCell{
	
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var todayAlertLabel: UILabel!
	@IBOutlet weak var fitnessNameLabel: UILabel!
	@IBOutlet weak var hmNameLabel: UILabel!
	@IBOutlet weak var logoImgView: UIImageView!
	
}

class MyScheduleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var scheduleListTableView: UITableView!
	var schedule:NSArray = [] {
		willSet{}
		didSet{
			schedule = schedule.reverse()
		}
	}
	var member:NSDictionary = [:]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		getSchedules()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		//getSchedules()
	}
	
	func getSchedules(){
		let baseURL = NSURL(string: "https://healthjjak.com/api/index.php/schedule/guest/get?purpose=total")
		
		do{
			let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: .MutableContainers) as! NSDictionary
			
			if JSONData["state"] as! Int == 200 {
				self.schedule = JSONData["res"]!["schedule"] as! NSArray
				self.member = JSONData["res"]!["member"] as! NSDictionary
				//print(self.schedule)
				
				if self.schedule.count < 1 {
					let subview = self.storyboard?.instantiateViewControllerWithIdentifier("NoScheduleAlert")
					subview!.navigationItem.title = "내 스케쥴"
					subview!.navigationItem.hidesBackButton = true
					self.navigationController?.pushViewController(subview!, animated: false)
					
					scheduleListTableView.reloadData()
				}
				
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
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.schedule.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("myScheduleListCell") as! MyScheduleTableCell
		
		cell.dateLabel.text = {
			let formatter1 = NSDateFormatter()
			formatter1.dateFormat = "Y-MM-dd"
			let sDateFromString = formatter1.dateFromString((self.schedule[indexPath.row]["s_date"] as? String)!)
			let formatter2 = NSDateFormatter()
			formatter2.dateFormat = "MM.dd E"
			
			//오늘인지 아닌지 확인
			let now = formatter1.stringFromDate(NSDate())
			
			if now != (self.schedule[indexPath.row]["s_date"] as? String)! {
				cell.todayAlertLabel.hidden = true
			}
			
			return formatter2.stringFromDate(sDateFromString!)
		}()
		
		cell.timeLabel.text = {
			let formatter1 = NSDateFormatter()
			formatter1.dateFormat = "HH:m:s"
			formatter1.timeStyle = .MediumStyle
			let sTimeFromString = formatter1.dateFromString((self.schedule[indexPath.row]["s_time"] as? String)!)
			let formatter2 = NSDateFormatter()
			formatter2.dateFormat = "a hh:mm"
			formatter2.locale = NSLocale(localeIdentifier: "ko_KR")
			formatter2.AMSymbol = "오전"
			formatter2.PMSymbol = "오후"
			formatter2.timeZone = NSTimeZone(name: "KST")
			return formatter2.stringFromDate(sTimeFromString!)
			}()
		
		cell.fitnessNameLabel.text = self.member["fitness"]!["\(self.schedule[indexPath.row]["fitness_key"] as! String)"]!!["info"]!!["center_name"] as? String
		
		cell.hmNameLabel.text = self.member["hm"]!["\(self.schedule[indexPath.row]["hm_key"] as! String)"]!!["info"]!!["name"] as? String
		
		cell.logoImgView.image = UIImage(data: NSData(contentsOfURL: NSURL(string:"https://healthjjak.com/html/userimgs/\(self.member["hm"]![self.schedule[indexPath.row]["hm_key"] as! String]!!["info"]!!["logo_img"] as! String)")!)!)
		cell.logoImgView.layer.masksToBounds = true
		cell.logoImgView.layer.cornerRadius = cell.logoImgView.frame.width / 2
		
		cell.todayAlertLabel.layer.masksToBounds = true
		cell.todayAlertLabel.layer.cornerRadius = 8.0
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("scheduleInfo") as! ScheduleinfoViewController
		
		nextView.scheduleKey = self.schedule[indexPath.row]["schedule_key"] as! String
		nextView.info = self.schedule[indexPath.row] as! NSDictionary
		nextView.member["hm"] = self.member["hm"]!["\(self.schedule[indexPath.row]["hm_key"] as! String)"] as? NSDictionary
		nextView.member["fitness"] = self.member["fitness"]!["\(self.schedule[indexPath.row]["fitness_key"] as! String)"] as? NSDictionary
		
		self.navigationController?.pushViewController(nextView, animated: true)
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		tableView.separatorInset = UIEdgeInsetsZero
		cell.layoutMargins = UIEdgeInsetsZero
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
