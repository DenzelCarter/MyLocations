//
//  LocationDetailsViewController.swift
//  MyLocations
//
//  Created by Denzel Carter on 5/17/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import CoreLocation
import Dispatch
import CoreData

private let dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
    formatter.timeStyle = .ShortStyle
    return formatter
    }()

class LocationDetailsViewController: UITableViewController, UITextViewDelegate {
    
    var date = NSDate()
    var descriptionText = ""
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    var managedObjectContext: NSManagedObjectContext!
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(
                    location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func done() {
        let hudView = HudView.hudInView(navigationController!.view,
            animated: true)
        var location: Location
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = NSEntityDescription.insertNewObjectForEntityForName(
                "Location", inManagedObjectContext: managedObjectContext)
                as! Location
        }
        location.locationDescription = descriptionText
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        // 3
        var error: NSError?
        if !managedObjectContext.save(&error) {
            fatalCoreDataError(error)
            return
        }
        afterDelay(0.6) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
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
        if let location = locationToEdit {
            title = "Edit Location"
        }
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        dateLabel.text = formatDate(date)
        let gestureRecognizer = UITapGestureRecognizer(target: self,
            action: Selector("hideKeyboard:"))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func tableView(tableView: UITableView,
        willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
            if indexPath.section == 0 || indexPath.section == 1 {
                return indexPath
            } else {
                return nil
            }
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if indexPath.section == 0 && indexPath.row == 0 {
                descriptionTextView.becomeFirstResponder()
            }
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        descriptionTextView.frame.size.width = view.frame.size.width - 30
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
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        if indexPath != nil && indexPath!.section == 0
            && indexPath!.row == 0 {
                return
        }
        descriptionTextView.resignFirstResponder()
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
