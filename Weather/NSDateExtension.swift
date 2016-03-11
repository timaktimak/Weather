//
//  NSDateExtension.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation

extension NSDate {
    
    func isMoreThanHourAgo() -> Bool {
        let seconds = NSDate().timeIntervalSinceDate(self)
        return seconds > 3600
    }
    
    static func dateFromString(str: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.dateFromString(str)
    }
    
    func getTimeComponents() -> (Int, Int, Int) {
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: self)
        let hour = comp.hour
        let minute = comp.minute
        let second = comp.second
        return (hour, minute, second)
    }
}
