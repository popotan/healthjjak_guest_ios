//
//  MyScheduleViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 15..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class MyScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

	@IBOutlet weak var leadToLoginContainerView: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
    }
	
	override func viewDidAppear(animated: Bool) {
		//세션체크
		UserSession.sharedInstance.getValidInfo()
		if UserSession.sharedInstance.valid {
			leadToLoginContainerView.hidden = true
		}else{
			leadToLoginContainerView.hidden = false
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	/*func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		
	}*/
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("scheduleCell", forIndexPath: indexPath)
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
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
