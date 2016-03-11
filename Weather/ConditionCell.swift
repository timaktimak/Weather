//
//  ConditionCell.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import UIKit

class ConditionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.transform = CGAffineTransformMakeScale(-1, 1)
    }
    
    var iconURL: String? {
        didSet {
            guard let iconURL = iconURL else { return }
            let url = NSURL(string: "\(Constants.ImageURL)/\(iconURL).png")
            imageView.sd_setImageWithURL(url)
        }
    }
}
