//
//  RegionCurrentData.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import CoreData

class RegionCurrentData {
    let region: String
    var dateOfFetch: NSDate?
    var data: WeatherData?
    
    init(region: String, dateOfFetch: NSDate? = nil, data: WeatherData? = nil) {
        self.region = region
        self.dateOfFetch = dateOfFetch
        self.data = data
    }
    
    init(managedObject: NSManagedObject) {
        self.region = managedObject.valueForKey(ModelKeys.Region) as! String
        self.dateOfFetch = managedObject.valueForKey(ModelKeys.DateOfFetch) as? NSDate
        self.data = WeatherData(managedObject: managedObject.valueForKey(ModelKeys.Data) as? NSManagedObject)
    }
}
