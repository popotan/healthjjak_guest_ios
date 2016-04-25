//
//  MyInfoViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 16..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	var session:Bool = false
	let menuTitlesOnSessionTrue = ["로그아웃","즐겨찾기목록","푸시알림내역","결제내역"]
	let menuTitlesOnSessionFalse = ["로그인"]
	let menuTitlesOnBasic = ["공지사항","파트너문의"]
	
	@IBOutlet weak var menuTable: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(animated: Bool) {
		//세션체크
		UserSession.sharedInstance.getValidInfo()
		if UserSession.sharedInstance.valid {
			self.session = true
		}else{
			self.session = false
		}
		menuTable.reloadData()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if self.session {
			return menuTitlesOnSessionTrue.count + menuTitlesOnBasic.count
		}else{
			return menuTitlesOnBasic.count + menuTitlesOnSessionFalse.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
		
		if self.session {
			if indexPath.row < self.menuTitlesOnSessionTrue.count {
				cell.textLabel?.text = self.menuTitlesOnSessionTrue[indexPath.row]
			}else{
				cell.textLabel?.text = self.menuTitlesOnBasic[indexPath.row - self.menuTitlesOnSessionTrue.count]
			}
		}else{
			if indexPath.row < self.menuTitlesOnSessionFalse.count {
				cell.textLabel?.text = self.menuTitlesOnSessionFalse[indexPath.row]
			}else{
				cell.textLabel?.text = self.menuTitlesOnBasic[indexPath.row - self.menuTitlesOnSessionFalse.count]
			}
		}
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
		print(selectedCell?.textLabel?.text)
		
		switch (selectedCell?.textLabel?.text)! {
		case "로그인":
			let JoinView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView")
			presentViewController(JoinView!, animated: true, completion: nil)
			break
			case "공지사항":
			break
			case "로그아웃":
				self.performSegueWithIdentifier("LogoutView", sender: nil)
			break
			case "즐겨찾기목록":
				self.performSegueWithIdentifier("FavoriteList", sender: nil)
			break
			case "푸시알림내역":
				self.performSegueWithIdentifier("PushMessageList", sender: nil)
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
