//
//  memberInfoManage.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 16..
//  Copyright © 2016년 이가람. All rights reserved.
//

import Foundation

struct memberInfoManage {
	let memberKey:String
	let info:NSDictionary
	init(memberKey:String, info:NSDictionary){
		self.memberKey = memberKey
		self.info = info
	}
}

struct fitnessInfoManage {
	let memberKey:String
	let info:NSDictionary
	let agrmt:NSDictionary
	init(memberKey:String, info:NSDictionary, agrmt:NSDictionary){
		self.memberKey = memberKey
		self.info = info
		self.agrmt = agrmt
	}
}

struct hmInfoManage {
	let memberKey:String
	let info:NSDictionary
	let agrmt:NSDictionary
	init(memberKey:String, info:NSDictionary, agrmt:NSDictionary){
		self.memberKey = memberKey
		self.info = info
		self.agrmt = agrmt
	}
}

class JoinInfoManage {
	var email:String?
	var phone:String?
	var certiKeyHash:String?
	var certiKey:String?
	var password:String?
	var passwordCheck:String?
	var birth:String?
	var gender:Int?
	
	static let instance = JoinInfoManage()
}

class UserSession {
	var deviceTokenFullString:String = "" {
		willSet(newValue){
			var newValue1 = newValue.stringByReplacingOccurrencesOfString("<", withString: "")
			newValue1 = newValue1.stringByReplacingOccurrencesOfString(">", withString: "")
			deviceToken = newValue1.stringByReplacingOccurrencesOfString(" ", withString: "")

		}
		didSet{
			
		}
	}
	var deviceToken:String = ""
	
	var valid: Bool = false {
		willSet{
			if newValue {
				self.getUserSessionInfo()
			}
		}
		didSet{
		}
	}
	var info:NSDictionary = [:]
	
	static let sharedInstance = UserSession()
	
	func getValidInfo(){
		let baseURL = NSURL(string:"http://211.253.24.190/api/index.php/log/checkUserSession")
		
		do{
		let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			
			NSOperationQueue.mainQueue().addOperationWithBlock({
					self.valid = JSONData["valid"] as! Bool
			})
		}catch{
			self.valid = false
		}
	}
	
	func getUserSessionInfo() {
		let baseURL = NSURL(string:"http://211.253.24.190/api/index.php/log/info/get")
		
		do{
		let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			
			NSOperationQueue.mainQueue().addOperationWithBlock({
				if JSONData["state"] as! Int == 200 {
					self.info = (JSONData["res"] as? NSDictionary)!
				}else{
					self.info = [:]
				}
			})
		}catch{
			self.info = [:]
		}
	}
}