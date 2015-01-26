//
//  AppstoreId.swift
//  AppHookupSwift
//
//  Created by Arthur GUIBERT on 25/01/2015.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

import Foundation

extension String {
    func extractAppIdFromURL() -> String? {
        var strippedString : String = ""
        let scanner = NSScanner(string: self)
        let digits = NSCharacterSet(charactersInString: "0123456789")
        var numberStarted = false
        
        while !scanner.atEnd {
            var buffer: NSString?
            if scanner.scanCharactersFromSet(digits, intoString: &buffer) {
                strippedString += buffer!
                numberStarted = true
            } else {
                if numberStarted {
                    break
                }
                
                scanner.scanLocation = scanner.scanLocation + 1
            }
        }
        
        if numberStarted {
            return strippedString
        }

        return nil
    }
}