//
//  schemeManage.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 16..
//  Copyright © 2016년 이가람. All rights reserved.
//

import Foundation

struct schemeManage {
	let scheme:String!
	var isValid:Bool = false
	var functions:[String:[String:String]] = [:]
	
	init(_ scheme:String){
		self.scheme = scheme
		self.isValid = self.extractScheme()
	}
	
	mutating func extractScheme() -> Bool {
		if self.scheme.hasPrefix("scheme://") {
			let schemeBody = scheme.componentsSeparatedByString("://")[1]
			
			let functionStringArray = schemeBody.componentsSeparatedByString("//")
			
			for functionString in functionStringArray {
				let functionName = functionString.componentsSeparatedByString("=")[0]
				
				if	functionString.componentsSeparatedByString("=").count > 1 {
				let functionParamString = functionString.componentsSeparatedByString("=")[1]
				self.functions[functionName] = [:]
				for functionParam in functionParamString.componentsSeparatedByString(",") {
					let paramName = functionParam.componentsSeparatedByString(":")[0]
					let paramValue = functionParam.componentsSeparatedByString(":")[1]
					self.functions[functionName]![paramName] = paramValue
				}
				}else{
					self.functions[functionName] = [:]
				}
			}
			return true
		}
		return false
	}
	
}