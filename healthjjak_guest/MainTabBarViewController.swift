//
//  MainTabBarViewController.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 24..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let item1: UITabBarItem = self.tabBar.items![0]
		item1.image = UIImage(named: "home-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		item1.selectedImage = UIImage(named: "home-icon-selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		
		let item2: UITabBarItem = self.tabBar.items![1]
		item2.image = UIImage(named: "mySchedule-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		item2.selectedImage = UIImage(named: "mySchedule-icon-selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		
		let item3: UITabBarItem = self.tabBar.items![2]
		item3.image = UIImage(named: "myInfo-icon")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
		item3.selectedImage = UIImage(named: "myInfo-icon-selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        // Do any additional setup after loading the view.
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
