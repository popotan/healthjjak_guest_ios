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

class UserSession : NSObject {
	var valid: Bool = false {
		willSet{
			if newValue {
				self.getUserSessionInfo()
			}
		}
		didSet{
			print("valid : \(self.valid)")
		}
	}
	var info:NSDictionary = [:] {
		willSet{
			
		}
		didSet{
			print("info : \(self.info)")
		}
	}
	
	static let sharedInstance = UserSession()
	
	func getValidInfo(){
		let baseURL = NSURL(string:"http://211.253.24.190/api/index.php/log/checkUserSession")
		
		do{
		let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			
		self.valid = JSONData["valid"] as! Bool
		}catch{
			self.valid = false
		}
	}
	
	func getUserSessionInfo() {
		let baseURL = NSURL(string:"http://211.253.24.190/api/index.php/log/info")
		
		do{
		let JSONData = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: baseURL!)!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
			
			if JSONData["state"] as! Int == 200 {
				self.info = (JSONData["res"] as? NSDictionary)!
			}else{
				self.info = [:]
			}
		}catch{
			self.info = [:]
		}
	}
}

class SelectedScheduleInfo {
	var agrmt:NSDictionary = [:]
	var selectedScheduleKey:[String] = [] {
		willSet{
			
		}
		didSet{
			self.totalPrice = selectedScheduleKey.count * Int((self.agrmt["info"]! as! NSDictionary)["price"]! as! String)!
		}
	}
	
	var totalPrice = 0 {
		willSet{
			
		}
		didSet{
			self.vatPrice = Int(Double(totalPrice) * 0.1)
		}
	}
	
	var vatPrice = 0 {
		willSet{
			
		}
		didSet{
			self.finalPriceToPay = totalPrice + vatPrice
		}
	}
	
	var finalPriceToPay = 0
	
	static let instance = SelectedScheduleInfo()
	
	func addScheduleKey(scheduleKey:String) {
		self.selectedScheduleKey.append(scheduleKey)
	}
	
	func removeScheduleKey(scheduleKey:String) {
		for (index, key) in self.selectedScheduleKey.enumerate() {
			if key == scheduleKey {
				self.selectedScheduleKey.removeAtIndex(index)
			}
		}
	}
	
	func removeScheduleKey(fromIndex:Int) {
		print("fromIndex")
		self.selectedScheduleKey.removeAtIndex(fromIndex)
	}
}