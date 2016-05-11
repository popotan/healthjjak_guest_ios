//
//  extensions.swift
//  healthjjak_guest
//
//  Created by 이가람 on 2016. 4. 26..
//  Copyright © 2016년 이가람. All rights reserved.
//

import Foundation

extension String {
	var isEmail: Bool {
		do {
			let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
			return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
		} catch {
			return false
		}
	}
}