//
//  ViewController.swift
//  IosFinalProject
//
//  Created by user192032 on 8/12/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var myLocTable: UITableView!

    var clLocManager:CLLocationManager?
    var userTimeStamp:Date = Date()
    var userLatitude:Double = 0.0
    var userLongitude:Double = 0.0
    var userDataArray=[String]()
    var dataItem:String = ""
    var rowDataLines:Int=3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clLocManager = CLLocationManager()
        clLocManager?.delegate = self
        clLocManager?.requestWhenInUseAuthorization()
        clLocManager?.startUpdatingLocation()
        // Do any additional setup after loading the view
        if let userItem = UserDefaults.standard.object(forKey: "dataItemKey") as? [String]
        {
            print("\(userItem)")
            userDataArray=userItem
        }
        
    }
    //--------------------------------LOCATION MANAGER-----------------------------
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locPayload = locations.first else {
            return
        }
        print("\(locPayload.timestamp)")
        userLongitude = locPayload.coordinate.longitude
        userLatitude = locPayload.coordinate.latitude
        userTimeStamp = locPayload.timestamp
        
        print("\(userTimeStamp) \(userLatitude) \(userLongitude)")
        dataItem = "Latitude : \(String(userLatitude)) Longitude : \(String(userLongitude)) Timestamp : \(userTimeStamp)"
        print ("\(dataItem)")
        //Add data to array
        userDataArray.append(dataItem)
        //Add to local storage
        UserDefaults.standard.set(userDataArray, forKey: "dataItemKey")
        myLocTable.reloadData()
        clLocManager?.stopUpdatingLocation()
    }
    
    //--------------------------------TAVLE VIEW---------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item=myLocTable.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        item.textLabel?.numberOfLines=rowDataLines
        item.textLabel?.text=userDataArray[indexPath.row]
        return item
    }

    //--------------------------------DELETE ROW---------------------------------
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            userDataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:.fade)
            UserDefaults.standard.set(userDataArray, forKey: "dataItemKey")
            tableView.endUpdates()
        }
    }
    
}

