//
//  RegionForecastData.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import CoreData

class RegionForecastData {
    let region: String
    var dateOfFetch: NSDate?
    var data: [WeatherData]?
    
    init(region: String) {
        self.region = region
    }
    
    init(managedObject: NSManagedObject) {
        self.region = managedObject.valueForKey(ModelKeys.Region) as! String
        self.dateOfFetch = managedObject.valueForKey(ModelKeys.DateOfFetch) as? NSDate
        self.data = (managedObject.valueForKey(ModelKeys.Data) as? NSOrderedSet)?.map { WeatherData(managedObject: $0 as? NSManagedObject)! }
    }
}
