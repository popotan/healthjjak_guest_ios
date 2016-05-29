//
//  PayHistoryViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 17..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class PayHistoryCell: UITableViewCell {
	@IBOutlet weak var division: UILabel!
	@IBOutlet weak var datetime: UILabel!
	@IBOutlet weak var price: UILabel!
	
}

class PayHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var payHistory = ["",""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.payHistory.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("PayHistoryCell") as! PayHistoryCell
		
		cell.division.text = "구분 : 결제"
		cell.datetime.text = "결제일시 : 2015-03-01 15:03:12"
		cell.price.text = "결제금액 : 100000원"
		
		return cell
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
