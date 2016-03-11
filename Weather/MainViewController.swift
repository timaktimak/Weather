//
//  MainViewController.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private let CellIdentifier = "RegionDataCellIdentifier"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.getInfo()
        NetworkManager.sharedInstance
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func newRegion(sender: UIBarButtonItem) {
        let newRegionNavVC = storyboard!.instantiateViewControllerWithIdentifier(.NewRegionNavVC) as! UINavigationController
        if let newRegionVC = newRegionNavVC.viewControllers.first as? NewRegionViewController {
            newRegionVC.presenter = self
        }
        newRegionNavVC.view.roundCorners([.TopLeft, .TopRight], radius: 8)
        let screen = UIScreen.mainScreen().bounds
        let frame = CGRect(x: 0, y: 20, width: screen.width, height: screen.height - 20)
        WindowShower.sharedInstance.showViewController(newRegionNavVC, windowFrame: frame, animation: .SlideUp, shouldHideOnTouch: false)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.sharedInstance.currentWeatherData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! RegionCell
        cell.data = DataManager.sharedInstance.currentWeatherSortedValues?[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? RegionCell {
            let region = cell.data.region
            guard let nc = storyboard?.instantiateViewControllerWithIdentifier(.DetailedDataNavVC) as? UINavigationController else { return }
            nc.view.layer.cornerRadius = 10
            nc.view.clipsToBounds = true
            guard let detailVC = nc.viewControllers.first as? DetailViewController else { return }
            detailVC.data = DataManager.sharedInstance.forecastWeatherData[region] ?? RegionForecastData(region: region)
            
            let frame = CGRect(centralForSize: CGSize(width: view.bounds.width - 40, height: view.bounds.height / 2))
            WindowShower.sharedInstance.showViewController(nc, windowFrame: frame, animation: .SlideUp, shouldHideOnTouch: true)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! RegionCell
            let region = cell.data!.region
            DataManager.sharedInstance.forecastWeatherData.removeValueForKey(region)
            DataManager.sharedInstance.currentWeatherData.removeValueForKey(region)
            DataManager.sharedInstance.cacheCurrentData()
            DataManager.sharedInstance.cacheForecastData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
}

extension MainViewController: LocationManagerDelegate {
    
    func locationManagerDidGetRegionName(region: String) {
        NetworkManager.sharedInstance.getCurrentWeatherForRegion(region,
            success: { data in
                if data.region == region.capitalizedString {
                    DataManager.sharedInstance.currentWeatherData[data.region] = data
                    self.tableView.reloadData()
                    DataManager.sharedInstance.cacheCurrentData()
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(true, forKey: Constants.LocationDetectedIdentifier)
                    defaults.synchronize()
                    
                } else {
                    print("user's city not found")
                }
            }, failure: {
                print("user's city not found")
        })
    }
}
