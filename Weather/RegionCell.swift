//
//  RegionCell.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import UIKit
import SDWebImage

class RegionCell: UITableViewCell {
    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var data: RegionCurrentData! {
        didSet {
            configure()
        }
    }
    
    private func configure() {
        tempLabel.hidden = true
        weatherImageView.hidden = true
        descriptionLabel.hidden = true
        regionLabel.text = data.region.capitalizedString
        
        if data.data == nil {
            reload()
            return
        }
        
        tempLabel.hidden = false
        tempLabel.text = "\(data.data!.temp)°"
        
        guard let condition = data.data!.conditions.first else { return }
        weatherImageView.hidden = false
        descriptionLabel.hidden = false
        descriptionLabel.text = condition.weatherDescription ?? ""
        let url = NSURL(string: "\(Constants.ImageURL)/\(condition.iconURL).png")
        weatherImageView.sd_setImageWithURL(url)
        
        if data.dateOfFetch?.isMoreThanHourAgo() ?? true { reload() }
    }
    
    private func reload() {
        NetworkManager.sharedInstance.getCurrentWeatherForRegion(data.region, success: {
            DataManager.sharedInstance.currentWeatherData[self.data.region] = $0
            self.data = $0
        })
    }
}
