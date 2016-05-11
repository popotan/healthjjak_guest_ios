//
//  MyInfoViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 16..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let userSession = UserSession.sharedInstance
	
	let menuTitlesOnSessionTrue = ["로그아웃","즐겨찾기목록","결제내역"]
	let menuTitlesOnSessionFalse = ["로그인","가입하기"]
	let menuTitlesOnBasic = ["공지사항","파트너문의"]
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userEmailLabel: UILabel!
	@IBOutlet weak var menuTable: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(animated: Bool) {
		//세션체크
		if userSession.valid {
			userNameLabel.text = userSession.info["name"] as? String
			userEmailLabel.text = userSession.info["email"] as? String
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
		if userSession.valid {
			return menuTitlesOnSessionTrue.count + menuTitlesOnBasic.count
		}else{
			return menuTitlesOnBasic.count + menuTitlesOnSessionFalse.count
		}
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath)
		
		if userSession.valid {
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
		
		switch (selectedCell?.textLabel?.text)! {
		case "로그인":
			let loginView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView")
			presentViewController(loginView!, animated: true, completion: nil)
			break
			case "공지사항":
				let baseURL = NSURL(string: "http://blog.naver.com/PostList.nhn?blogId=healthjjak&from=postList&categoryNo=8")
				UIApplication.sharedApplication().openURL(baseURL!)
			break
			case "파트너문의":
				let baseURL = NSURL(string: "https://healthjjak.com/html/index.php/join/befriends")
				UIApplication.sharedApplication().openURL(baseURL!)
			break
			case "로그아웃":
				self.performSegueWithIdentifier("LogoutView", sender: nil)
			break
			case "즐겨찾기목록":
				self.performSegueWithIdentifier("FavoriteList", sender: nil)
			break
			case "가입하기":
				let JoinView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginOrJoin") as! LoginOrJoinViewController
				JoinView.cancelAble = true
				presentViewController(JoinView, animated: true, completion: nil)
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
