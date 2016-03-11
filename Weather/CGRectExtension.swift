//
//  CGRectExtension.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    
    init(centralForSize size: CGSize) {
        let screen = UIScreen.mainScreen().bounds
        self.init(x: (screen.width-size.width)/2, y: (screen.height-size.height)/2, width: size.width, height: size.height)
    }
}
