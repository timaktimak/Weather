//
//  CoreDataManager.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    private struct ModelClasses {
        static let CurrentData = "RegionCurrentData"
        static let ForecastData = "RegionForecastData"
        static let WeatherData = "WeatherData"
        static let WeatherCondition = "WeatherCondition"
    }
    
    func loadAllData() -> ([RegionCurrentData], [RegionForecastData]) {
        let context = Coredata.sharedInstance.managedObjectContext!
        var currentData = [RegionCurrentData]()
        var forecastData = [RegionForecastData]()
        
        let requestC = NSFetchRequest(entityName: ModelClasses.CurrentData)
        requestC.returnsObjectsAsFaults = false
        do {
            guard let objects = try context.executeFetchRequest(requestC) as? [NSManagedObject] else { return (currentData, forecastData)}
            currentData = objects.map { RegionCurrentData(managedObject: $0) }
        } catch { print("Countn't fetch data") }
        
        let requestF = NSFetchRequest(entityName: ModelClasses.ForecastData)
        requestF.returnsObjectsAsFaults = false
        do {
            guard let objects = try context.executeFetchRequest(requestF) as? [NSManagedObject] else { return (currentData, forecastData)}
            forecastData = objects.map { RegionForecastData(managedObject: $0) }
        } catch { print("Countn't fetch data") }
        
        return (currentData, forecastData)
    }
    
    func saveRegionCurrentData(data: RegionCurrentData) {
        let context = Coredata.sharedInstance.managedObjectContext!
        let dataObj = NSEntityDescription.insertNewObjectForEntityForName(ModelClasses.CurrentData, inManagedObjectContext: context)
        
        dataObj.setValue(data.region, forKey: ModelKeys.Region)
        dataObj.setValue(data.dateOfFetch, forKey: ModelKeys.DateOfFetch)
        
        if let weatherData = data.data {
            let weatherDataED = NSEntityDescription.entityForName(ModelClasses.WeatherData, inManagedObjectContext: context)
            let weatherDataObj = NSManagedObject(entity: weatherDataED!, insertIntoManagedObjectContext: context)
            
            weatherDataObj.setValue(weatherData.temp, forKey: ModelKeys.Temp)
            weatherDataObj.setValue(weatherData.dayTime.rawValue, forKey: ModelKeys.DayTime)
            let conditionObjs = weatherData.conditions.map { (obj: WeatherCondition) -> (NSManagedObject) in
                let conditionED = NSEntityDescription.entityForName(ModelClasses.WeatherCondition, inManagedObjectContext: context)
                let conditionObj = NSManagedObject(entity: conditionED!, insertIntoManagedObjectContext: context)
                conditionObj.setValue(obj.weatherDescription, forKey: ModelKeys.Description)
                conditionObj.setValue(obj.iconURL, forKey: ModelKeys.IconURL)
                return conditionObj
            }
            
            let conditionsSet = NSSet(array: conditionObjs)
            weatherDataObj.setValue(conditionsSet, forKey: ModelKeys.Conditions)
            dataObj.setValue(weatherDataObj, forKey: ModelKeys.Data)
        }
        do { try context.save() }
        catch { print("Coundn't save object: \(data)") }
    }
    
    func saveRegionForecastData(data: RegionForecastData) {
        let context = Coredata.sharedInstance.managedObjectContext!
        let dataObj = NSEntityDescription.insertNewObjectForEntityForName(ModelClasses.ForecastData, inManagedObjectContext: context)
        
        dataObj.setValue(data.region, forKey: ModelKeys.Region)
        dataObj.setValue(data.dateOfFetch, forKey: ModelKeys.DateOfFetch)
        
        guard let forecast = data.data else {
            do { try context.save() }
            catch _ { print("Coundn't save object: \(data)") }
            return
        }
        
        var weatherDataArray = [NSManagedObject]()
        for weatherData in forecast {
            let weatherDataED = NSEntityDescription.entityForName(ModelClasses.WeatherData, inManagedObjectContext: context)
            let weatherDataObj = NSManagedObject(entity: weatherDataED!, insertIntoManagedObjectContext: context)
            
            weatherDataObj.setValue(weatherData.temp, forKey: ModelKeys.Temp)
            weatherDataObj.setValue(weatherData.dayTime.rawValue, forKey: ModelKeys.DayTime)
            let conditionObjs = weatherData.conditions.map { (obj: WeatherCondition) -> (NSManagedObject) in
                let conditionED = NSEntityDescription.entityForName(ModelClasses.WeatherCondition, inManagedObjectContext: context)
                let conditionObj = NSManagedObject(entity: conditionED!, insertIntoManagedObjectContext: context)
                conditionObj.setValue(obj.weatherDescription, forKey: ModelKeys.Description)
                conditionObj.setValue(obj.iconURL, forKey: ModelKeys.IconURL)
                return conditionObj
            }
            let conditionsSet = NSSet(array: conditionObjs)
            weatherDataObj.setValue(conditionsSet, forKey: ModelKeys.Conditions)
            weatherDataArray.append(weatherDataObj)
        }
        let weatherDataSet = NSOrderedSet(array: weatherDataArray)
        dataObj.setValue(weatherDataSet, forKey: ModelKeys.Data)
        
        do { try context.save() }
        catch _ { print("Coundn't save object: \(data)") }
    }
    
    func deleteAllCurrentData() {
        deleteData(ModelClasses.CurrentData)
    }
    
    func deleteAllForecastData() {
        deleteData(ModelClasses.ForecastData)
    }
    
    private func deleteData(entityName: String) {
        let context = Coredata.sharedInstance.managedObjectContext!
        let request = NSFetchRequest(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            guard let objects = try context.executeFetchRequest(request) as? [NSManagedObject] else { return }
            for obj in objects {
                context.deleteObject(obj)
            }
        } catch { print("Countn't delete \(entityName) data") }
        
        do { try context.save() }
        catch _ { print("Coundn't delete \(entityName) data") }
    }
}
