//
//  PayResultViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 10..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class PayResultViewController: UIViewController {

	var result = false
	
	@IBOutlet weak var showMyScheduleButton: UIButton!
	@IBOutlet weak var messageLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		setViewStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setViewStyle() {
		if self.result {
			self.showMyScheduleButton.layer.cornerRadius = 5.0
			self.showMyScheduleButton.layer.masksToBounds = true

			self.messageLabel.text = "결제가 완료되었습니다!"
		}else{
			self.showMyScheduleButton.hidden = true
			
			self.messageLabel.text = "결제에 실패하였습니다."
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
