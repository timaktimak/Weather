//
//  NewRegionViewController.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import UIKit
import Alamofire

class NewRegionViewController: UIViewController {
    
    private let buttonColor = UIColor(red: 49/255, green: 130/255, blue: 217/255, alpha: 1.0)
    var timer: NSTimer? = nil
    var request: Alamofire.Request?
    var data: RegionCurrentData?
    var presenter: MainViewController!
    
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem! {
        didSet {
            saveButton.setTitleTextAttributes([NSForegroundColorAttributeName: buttonColor, NSFontAttributeName: Avenir.medium(17)], forState: .Normal)
            saveEnabled(false)
        }
    }
    @IBOutlet weak var cancelButton: UIBarButtonItem! {
        didSet {
            cancelButton.setTitleTextAttributes([NSForegroundColorAttributeName: buttonColor, NSFontAttributeName: Avenir.roman(17)], forState: .Normal)
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.layer.cornerRadius = 5
            let paddingView = UIView(frame: CGRectMake(0, 0, 8, textField.bounds.height))
            textField.leftView = paddingView
            textField.leftViewMode = .Always
            textField.tintColor = UIColor.grayColor()
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var successLabel: UILabel! {
        didSet {
            successLabel.layer.cornerRadius = successLabel.bounds.width / 2
            successLabel.clipsToBounds = true
        }
    }
    @IBOutlet weak var failureLabel: UILabel! {
        didSet {
            failureLabel.layer.cornerRadius = failureLabel.bounds.width / 2
            failureLabel.clipsToBounds = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        WindowShower.sharedInstance.hide()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        DataManager.sharedInstance.currentWeatherData[data!.region] = data
        DataManager.sharedInstance.cacheCurrentData()
        textField.resignFirstResponder()
        presenter.tableView.reloadData()
        WindowShower.sharedInstance.hide()
    }
}

extension NewRegionViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let resultingString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        timer?.invalidate()
        saveEnabled(false)
        successLabel.hidden = true
        failureLabel.hidden = true
        noInternetLabel.hidden = true
        activityIndicator.stopAnimating()
        request?.cancel()
        data = nil
        if resultingString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" { return true }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("checkRegion"), userInfo: nil, repeats: false)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if saveButton.enabled == true {
            save(saveButton)
        }
        return true
    }
}

extension NewRegionViewController {
    
    func checkRegion() {
        activityIndicator.startAnimating()
        guard let region = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) else { return }
        request = NetworkManager.sharedInstance.getCurrentWeatherForRegion(region,
            success: { data in
                if data.region == region.capitalizedString {
                    self.regionSearchResult(.Sucess, data: data)
                } else {
                    self.regionSearchResult(.Failure)
                }
            },
            failure: {
                self.regionSearchResult(.Failure)
            }, noInternetBlock:  {
                self.regionSearchResult(.NoInternet)
        })
    }
    
    private func saveEnabled(enabled: Bool) {
        saveButton.enabled = enabled
        let color = enabled ? buttonColor : UIColor.lightGrayColor()
        saveButton.setTitleTextAttributes([NSForegroundColorAttributeName: color, NSFontAttributeName: Avenir.medium(17)], forState: .Normal)
    }
    
    private func regionSearchResult(result: Result, data: RegionCurrentData? = nil) {
        activityIndicator.stopAnimating()
        switch result {
        case .Sucess:
            successLabel.hidden = false
            saveEnabled(true)
            self.data = data
        case .Failure:
            failureLabel.hidden = false
        case .NoInternet:
            noInternetLabel.hidden = false
            failureLabel.hidden = false
        }
    }
    
    private enum Result {
        case Sucess
        case Failure
        case NoInternet
    }
}








