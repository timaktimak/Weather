//
//  UIStoryboardExtension.swift
//  Boost
//
//  Created by Timur Galimov on 26/09/15.
//  Copyright © 2015 Timur Galimov. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    func instantiateViewControllerWithIdentifier(identifier: ViewControllerIdentifier) -> UIViewController {
        return self.instantiateViewControllerWithIdentifier(identifier.rawValue)
    }
}
