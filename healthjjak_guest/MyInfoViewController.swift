//
//  MyInfoViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 16..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class MyInfoViewController: UIViewController {

	let userSession = UserSession.sharedInstance
	
	let menuTitlesOnSessionTrue = ["로그아웃","즐겨찾기목록","결제내역","공지사항","파트너문의"]
	let menuTitlesOnSessionFalse = ["로그인","가입하기","공지사항","파트너문의"]
	let menuButtonSelector = [
		"로그인":#selector(MyInfoViewController.goLoginView),
		"가입하기":#selector(MyInfoViewController.goJoinView),
		"로그아웃":#selector(MyInfoViewController.goLogOutView),
		"즐겨찾기목록":#selector(MyInfoViewController.goFavoriteView),
		"결제내역":#selector(MyInfoViewController.goPayHistoryView),
		"공지사항":#selector(MyInfoViewController.goNoticeView),
		"파트너문의":#selector(MyInfoViewController.goPartnerView)
		]
	@IBOutlet weak var userNameLabel: UILabel!
	@IBOutlet weak var userEmailLabel: UILabel!

	@IBOutlet weak var menuWrapperView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var HICInfoView: UIView!

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(animated: Bool) {
		var menuLength = 0
		if userSession.valid {
			for (index, menu) in self.menuTitlesOnSessionTrue.enumerate() {
				self.makeButton(index, menu: menu)
				menuLength = index
			}
		}else{
			for (index, menu) in self.menuTitlesOnSessionFalse.enumerate() {
				self.makeButton(index, menu: menu)
				menuLength = index
			}
		}
		
		//menuWrapperView 높이 정의
		self.menuWrapperView.frame = CGRectMake(0, 163, self.view.frame.width, CGFloat(((menuLength+1) * 70) + menuLength + 2))
		
		//전체 컨텐츠 높이 계산하기
		var scrollViewContentSize = CGFloat(163) //기본적인 요소들의 총 합
	 	scrollViewContentSize = scrollViewContentSize + self.menuWrapperView.frame.height
		
		if self.view.frame.height >= scrollViewContentSize+self.HICInfoView.frame.height {
			//전체 내용보다 화면이 더 클 경우
			self.HICInfoView.frame = CGRectMake(0,self.view.frame.height - 74, self.view.frame.width, 74)
			
			self.scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height)
		}else{
			
		}
		self.HICInfoView.frame = CGRectMake(0,scrollViewContentSize, self.view.frame.width, 74)
		
		self.scrollView.contentSize = CGSizeMake(self.view.frame.width, CGFloat(scrollViewContentSize) + self.HICInfoView.frame.height)
	}
	
	func makeButton(index:Int, menu:String) {
		let button = UIButton.init(frame: CGRectMake(0, CGFloat((index*70)+index+1), self.scrollView.frame.width, 70))
		button.setTitleColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 1), forState: .Normal)
		button.setTitle(menu, forState: .Normal)
		button.backgroundColor = UIColor.whiteColor()
		button.addTarget(self, action: self.menuButtonSelector["\(menu)"]!, forControlEvents: UIControlEvents.TouchUpInside)
		button.autoresizingMask = [.FlexibleWidth, .FlexibleRightMargin, .FlexibleLeftMargin]
		self.menuWrapperView.addSubview(button)
	}
	
	@objc func goLoginView() {
		let loginView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView")
		presentViewController(loginView!, animated: true, completion: nil)
	}
	
	@objc func goNoticeView(){
		let baseURL = NSURL(string: "http://blog.naver.com/PostList.nhn?blogId=healthjjak&from=postList&categoryNo=8")
		UIApplication.sharedApplication().openURL(baseURL!)
	}
	
	@objc func goJoinView(){
		let JoinView = self.storyboard?.instantiateViewControllerWithIdentifier("LoginOrJoin") as! LoginOrJoinViewController
		JoinView.cancelAble = true
		presentViewController(JoinView, animated: true, completion: nil)
	}
	
	@objc func goPartnerView(){
		print("파트너문의")
		let baseURL = NSURL(string: "https://healthjjak.com/html/index.php/join/befriends")
		UIApplication.sharedApplication().openURL(baseURL!)
	}
	
	@objc func goLogOutView(){
		self.performSegueWithIdentifier("LogoutView", sender: nil)
	}
	
	@objc func goFavoriteView(){
		self.performSegueWithIdentifier("FavoriteList", sender: nil)
	}
	
	@objc func goPayHistoryView(){
		self.performSegueWithIdentifier("PayHistory", sender: nil)
	}
	
	override func viewDidAppear(animated: Bool) {
		//세션체크
		if userSession.valid {
			userNameLabel.text = userSession.info["name"] as? String
			userEmailLabel.text = userSession.info["email"] as? String
		}
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
