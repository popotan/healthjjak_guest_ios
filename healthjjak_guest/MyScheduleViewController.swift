//
//  MyScheduleViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 15..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class LeadToLoginViewController: UIViewController {
	@IBOutlet weak var loginButton: UIButton!
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}

class MyScheduleViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
    }
	
	override func viewWillAppear(animated: Bool) {
		//세션체크
		if UserSession.sharedInstance.valid {
			let subview = self.storyboard?.instantiateViewControllerWithIdentifier("myScheduleList") as! MyScheduleListViewController
			subview.navigationItem.title = "내 스케쥴"
			subview.navigationItem.hidesBackButton = true
			self.navigationController?.pushViewController(subview, animated: false)
		}else{
			let subview = self.storyboard?.instantiateViewControllerWithIdentifier("LeadToLogin") as! LeadToLoginViewController
			subview.navigationItem.title = "내 스케쥴"
			subview.navigationItem.hidesBackButton = true
			self.navigationController?.pushViewController(subview, animated: false)
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
