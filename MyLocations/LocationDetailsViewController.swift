//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Denzel Carter on 5/17/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDetailsViewController: UITableViewController, UITextViewDelegate {
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter
        }()
    
    var descriptionText = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func done() {
       println("Description '\(descriptionText)'")
       dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
        let controller = segue.sourceViewController
            as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        dateLabel.text = formatDate(NSDate())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue,
        sender: AnyObject?) {
            if segue.identifier == "PickCategory" {
                let controller = segue.destinationViewController
                    as! CategoryPickerViewController
                controller.selectedCategoryName = categoryName
            }
    }
    
    override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            if indexPath.section == 0 && indexPath.row == 0 {
                return 88
            } else if indexPath.section == 2 && indexPath.row == 2 {
                addressLabel.frame.size = CGSize(
                    width: view.bounds.size.width - 115,
                    height: 10000)
                addressLabel.sizeToFit()
                addressLabel.frame.origin.x = view.bounds.size.width -
                    addressLabel.frame.size.width - 15
                return addressLabel.frame.size.height + 20
            } else {
                return 44
            }
    }
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        return
            "\(placemark.subThoroughfare) \(placemark.thoroughfare), " +
                "\(placemark.locality), " +
                "\(placemark.administrativeArea) \(placemark.postalCode)," +
        "\(placemark.country)"
    }
    
}


extension LocationDetailsViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange
        range: NSRange, replacementText text: String) -> Bool {
            descriptionText =
                (textView.text as NSString).stringByReplacingCharactersInRange(
                    range, withString: text)
            return true
    }
    func textViewDidEndEditing(textView: UITextView) {
        descriptionText = textView.text
    }
}
