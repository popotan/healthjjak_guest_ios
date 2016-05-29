//
//  RaiusView.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 5. 15..
//  Copyright © 2016년 이가람. All rights reserved.
//

import UIKit

class RaiusView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		self.layer.cornerRadius = 5.0
		self.layer.masksToBounds = true
	}

}
