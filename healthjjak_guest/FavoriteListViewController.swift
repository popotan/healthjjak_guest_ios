//
//  FavoriteListViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 25..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class FavoriteListCell : UITableViewCell {
	@IBOutlet weak var logoImgView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var gradeLabel: UILabel!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var activeFitnessLabel: UILabel!
}

class FavoriteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var favoriteList:NSDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
		getList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func getList(){
		let baseURL = NSURL(string: "http://211.253.24.190/api/index.php/react/favorite/get?purpose=list")
		
		do{
			let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: .MutableContainers) as! NSDictionary
			
			if JSONData["state"] as! Int == 200 {
				self.favoriteList = JSONData["res"] as! NSDictionary
			}else{
				let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: JSONData["msg"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
				alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
				self.presentViewController(alertView, animated: true, completion: nil)
			}
		}catch{
			let alertView: UIAlertController = UIAlertController.init(title: "헬스짝 알림", message: "통신에 이상이 생겼습니다. 다시 시도해 주세요.", preferredStyle: UIAlertControllerStyle.Alert)
			alertView.addAction(UIAlertAction.init(title: "확인", style: UIAlertActionStyle.Cancel, handler: nil))
			self.presentViewController(alertView, animated: true, completion: nil)
		}
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let hmCount = self.favoriteList["hm"]?.count
		return hmCount!
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("favoriteListCell") as! FavoriteListCell
		cell.nameLabel.text = self.favoriteList["hm"]![indexPath.row]["info"]!!["name"] as? String
		cell.gradeLabel.text  = {() -> String in
			var gradeStr = ""
			switch self.favoriteList["hm"]![indexPath.row]["info"]!!["hm_grade"] as! String {
			case "0":
				gradeStr = "HM Master"
				break
			case "1":
				gradeStr = "HM 1급"
				break
			case "2":
				gradeStr = "HM 2급"
				break
			case "3":
				gradeStr = "HM 3급"
				break
			case "9":
				gradeStr = "미등록PT"
				break
			default:
				gradeStr = ""
				break
			}
			return gradeStr
		}()
		cell.infoLabel.text = "좋아요 \(self.favoriteList["hm"]![indexPath.row]["info"]!!["star"] as! Int) | \(self.favoriteList["hm"]![indexPath.row]["info"]!!["activeTime"] as! Int)시간 활동 | \(self.favoriteList["hm"]![indexPath.row]["info"]!!["review_count"] as! Int)개 평가"
		cell.logoImgView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "http://211.253.24.190/userimgs/\(self.favoriteList["hm"]![indexPath.row]["info"]!!["logo_img"] as! String)")!)!)
		cell.logoImgView.layer.masksToBounds = true
		cell.logoImgView.layer.cornerRadius = cell.logoImgView.frame.size.width / 2
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let memberKey = self.favoriteList["hm"]![indexPath.row]["info"]!!["member_key"] as! String
		performSegueWithIdentifier("gotoInfoView", sender: memberKey)
	}
	
	//sender로 memberKey를 전송함
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		switch segue.identifier! {
		case "gotoInfoView":
			let nextView = segue.destinationViewController as! InfoWebViewViewController
			nextView.division = "hm"
			nextView.targetKey = sender as! String
			break
		default:
			break
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
