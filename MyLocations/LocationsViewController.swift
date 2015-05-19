//
//  SecondViewController.swift
//  MyLocations
//
//  Created by Denzel Carter on 5/11/15.
//  Copyright (c) 2015 BearBrosDevelopment. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {
    var locations = [Location]()
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        let fetchRequest = NSFetchRequest()
        // 2
        let entity = NSEntityDescription.entityForName("Location",
            inManagedObjectContext: managedObjectContext)
        fetchRequest.entity = entity
        // 3
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        // 4
        var error: NSError?
        let foundObjects = managedObjectContext.executeFetchRequest(
            fetchRequest, error: &error)
        if foundObjects == nil {
            fatalCoreDataError(error)
            return
        }
        // 5
        locations = foundObjects as! [Location]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return locations.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell")
                as! UITableViewCell
            let location = locations[indexPath.row]
            let descriptionLabel = cell.viewWithTag(100) as! UILabel
            descriptionLabel.text = location.locationDescription
            let addressLabel = cell.viewWithTag(101) as! UILabel
            if let placemark = location.placemark {
                addressLabel.text =
                    "\(placemark.subThoroughfare) \(placemark.thoroughfare)," +
                "\(placemark.locality)"
            } else {
                addressLabel.text = "njnjnnijjij"
            }
            return cell
    }

}

