//
//  postRequestManage.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 18..
//  Copyright © 2016년 이가람. All rights reserved.
//

import Foundation

class postRequestManage {
	var url:NSURL?
	var parameter:[String:AnyObject]?
	var session = NSURLSession.sharedSession()
	
	func setRequest() -> NSMutableURLRequest {
		let request = NSMutableURLRequest(URL: self.url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 15.0)
		request.HTTPMethod = "POST"
		request.HTTPShouldHandleCookies = true
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Accept")
		request.HTTPBody = self.extractParameter().dataUsingEncoding(NSUTF8StringEncoding)! as NSData
		
		return request
	}
	
	func extractParameter() -> String{
		var bodyString = ""
		
		for param in self.parameter!.enumerate() {
			bodyString += param.element.0
			bodyString += "="
			bodyString += param.element.1 as! String
			if param.index + 1 != self.parameter!.count {
				bodyString += "&"
			}
		}
		
		return bodyString
	}
}