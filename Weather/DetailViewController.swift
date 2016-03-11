//
//  DetailViewController.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    private struct Constants {
        static let CellNibName = "WeatherCell"
        static let CellIdentifier = "WeatherCellIdentifier"
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerNib(UINib(nibName: Constants.CellNibName, bundle: nil), forCellReuseIdentifier: Constants.CellIdentifier)
            tableView.tableFooterView = UIView()
        }
    }
    var data: RegionForecastData? {
        didSet {
            configure()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = data?.region.capitalizedString
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if data?.data == nil || (data?.dateOfFetch?.isMoreThanHourAgo() ?? true) {
            NetworkManager.sharedInstance.getForecastForRegion(data!.region,
                success: {
                    self.data = $0
                    DataManager.sharedInstance.forecastWeatherData[self.data!.region] = self.data
                    DataManager.sharedInstance.cacheForecastData()
                },
                failure: {
                    self.activityIndicator.stopAnimating()
                    self.errorLabel.hidden = false
            })
        }
        configure()
    }
    
    private func configure() {
        if data?.data == nil { return }
        tableView?.reloadData()
        tableView?.hidden = false
        activityIndicator?.stopAnimating()
    }
    
    @IBAction func close() {
        WindowShower.sharedInstance.hide()
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data?.data else { return 0 }
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let data = data?.data else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellIdentifier) as! WeatherCell
        cell.data = data[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }
}
