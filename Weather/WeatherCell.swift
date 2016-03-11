//
//  WeatherCell.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    private struct Constants {
        static let CellNibName = "ConditionCell"
        static let CellIdentifier = "ConditionCellIdentifier"
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.transform = CGAffineTransformMakeScale(-1, 1)
            collectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        }
    }
    
    @IBOutlet weak var tempLabel: UILabel!
    
    var data: WeatherData? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerNib(UINib(nibName: Constants.CellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.CellIdentifier)
    }
    
    private func configure() {
        guard let data = data else { return }
        timeLabel.text = data.dayTime.rawValue
        tempLabel.text = "\(data.temp)°"
    }
    
}

extension WeatherCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.conditions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CellIdentifier, forIndexPath: indexPath) as! ConditionCell
        cell.iconURL = data?.conditions[indexPath.row].iconURL
        return cell
    }
}
