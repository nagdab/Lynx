//
//  CouponDisplayController.swift
//  LynxStudent
//
//  Created by Yifan Xu on 3/5/17.
//  Copyright © 2017 Yifan & Bhavik. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FBSDKLoginKit
import Cosmos
import  UserNotifications
import UserNotificationsUI
import CoreLocation

class CouponDisplayController : UITableViewController
{
    // data model for the table class
    var couponMaster = CouponMaster()
    
    // firebase reference to the coupons
    let ref = FIRDatabase.database().reference(withPath: "coupon")
    
    // firebase reference to the businesses
    let businessRef = FIRDatabase.database().reference(withPath: "business")
    
    let requestIdentifier = "SampleRequest" //identifier is to cancel the notification request
    
    var displayFilter = false
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("view loaded")
        
        locationManager.startUpdatingLocation()
        
        // set up the cell's height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        ref.observe(.childAdded, with: { snapshot in
            let content = UNMutableNotificationContent()
            content.title = "New Coupon is posted"
            content.body = "Go check it out"
            content.sound = UNNotificationSound.default()
            
            // Deliver the notification in point five seconds.
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier:self.requestIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request){(error) in
                
                if (error != nil){
                    
                    print(error?.localizedDescription)
                }
            }
        })

        
        ref.observe(.value, with: { snapshot in
            
            var coupons = [Coupon]()
            if snapshot.exists()
            {
                for item in snapshot.children
                {
                    let snap = item as! FIRDataSnapshot
                    let coupon = Coupon(snapshot: snap)
                    // if coupon is not expired, add it to coupon list
                    if coupon.endDate > Date() && coupon.numbersLeft > 0
                    {
                        coupons.append(Coupon(snapshot: item as! FIRDataSnapshot))
                    }
                    // else delete it from the database
                    else
                    {
                        snap.ref.removeValue()
                    }
                }
                self.couponMaster.coupons = coupons
                self.tableView.reloadData()
            }
            else
            {
                print("no coupons yet")
            }
            
        })
        
        self.tableView.reloadData()
        
    }

    
    
    @IBAction func filterOptionChanged(_ sender: Any)
    {
        displayFilter = !displayFilter
        
        self.tableView.reloadData()
    }
    
    @IBAction func LogOut(_ sender: Any)
    {
        do
        {
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: "logOut", sender: nil)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } catch let signOutError as NSError{
            print(signOutError)
        }
        
    }
    
    // function for number of cells in table
    override func tableView(_: UITableView, numberOfRowsInSection: Int) -> Int
    {
        if numberOfRowsInSection == 0
        {
            if displayFilter
            {
                return couponMaster.orderedOptions.count
            }
            else
            {
                return couponMaster.coupons.count
            }
        }
        else
        {
            return couponMaster.coupons.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        if displayFilter
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 && displayFilter
        {
            return 45.0
        }
        else
        {
            return 155.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if indexPath.section == 0 && displayFilter
        {
            let text = cell.textLabel!.text!
            // if the sorting option is not selected
            if cell.accessoryType == .none
            {
                couponMaster.availableOptions[text] = couponMaster.options[text]
                cell.accessoryType = .checkmark
            }
            else
            {
                couponMaster.availableOptions[text] = nil
                cell.accessoryType = .none
            }
        }
        else
        {
            let coupon = couponMaster.coupons[indexPath.row]
            if couponMaster.selected.contains(coupon)
            {
                couponMaster.selected.remove(coupon)
                print(couponMaster.selected)
            }
            else
            {
                couponMaster.selected.insert(coupon)
                print(couponMaster.selected)
            }
        }
        self.tableView.reloadData()
    }

    
    @IBAction func detailButtonPressed(_ sender: UIButton)
    {
        let coupon = couponMaster.sortedCoupons[sender.tag]
        self.businessRef.child(coupon.businessID).observeSingleEvent(of: .value, with: { snapshot in
            let newBusiness = Business(snapshot: snapshot)
            self.performSegue(withIdentifier: "couponDetail", sender: (coupon, newBusiness))
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "couponDetail"
        {
            let sender = sender as! (Coupon, Business)
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.coupon = sender.0
            detailViewController.business = sender.1
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // 0th section is for sorting options
        if indexPath.section == 0 && displayFilter
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                                     for: indexPath)
            cell.textLabel?.text = couponMaster.orderedOptions[indexPath.row]
            
            return cell
        }
        
        if indexPath.section == 1 || !displayFilter
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell",
                                                     for: indexPath) as! CouponCell
            cell.cellSetUp()
            
            // create the black background of the cell
            let blackRoundedView : UIView = UIView(frame: CGRect(x: 8, y: 8, width: self.view.frame.size.width - 16, height: 139))
            
            blackRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
            blackRoundedView.layer.masksToBounds = false
            blackRoundedView.layer.cornerRadius = 2.0
            blackRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
            blackRoundedView.layer.shadowOpacity = 0.2
            
            cell.contentView.addSubview(blackRoundedView)
            cell.contentView.sendSubview(toBack: blackRoundedView)
            let coupon = couponMaster.sortedCoupons[indexPath.row]
            cell.coupon = coupon
        
            businessRef.child(coupon.businessID).observeSingleEvent(of: .value, with: { snapshot in
                let newBusiness = Business(snapshot: snapshot)
                cell.business = newBusiness
                cell.businessName.text = newBusiness.name
                cell.businessName.font = cell.businessName.font.withSize(20)
     //           cell.couponDescription.text = newBusiness.address
     //           cell.ratingView.rating = newBusiness.overallRating
      //          cell.ratingView.text = "\(newBusiness.numOfRating) reviews"
      //          cell.ratingView.settings.updateOnTouch = false
                cell.detailButton.tag = indexPath.row
                let value = snapshot.value as! [String : Any]
                
                let propicURL = URL(string: value["photoURL"] as! String)
                
                let session = URLSession(configuration: .default)
                
                let downloadPicTask = session.dataTask(with: propicURL!) { (data, response, error) in
                    // The download has finished.
                    if let e = error
                    {
                        print("Error downloading cat picture: \(e)")
                    }
                    else
                    {
                        // No errors found.
                        // It would be weird if we didn't have a response, so check for that too.
                        if let imageData = data
                        {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            // set the profile picture
                            cell.profilePic.image = image
                            cell.profilePic.contentMode = .scaleAspectFit
                        }
                        else
                        {
                            print("Couldn't get image: Image is nil")
                        }
                        
                    }
                }
                
                // resumes the download
                downloadPicTask.resume()
            })
            
     //       cell.numLeft.text = "\(coupon.numbersLeft)"
      //      cell.endDate.text = dateToString(dateData: coupon.endDate)
            cell.remainingExpiry.text = "\(coupon.numbersLeft) coupons left, expiring on \(dateToString(dateData: coupon.endDate))"
            cell.discount.text = coupon.discount.uppercased()
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "UITableViewCell",
                                             for: indexPath)
    }
}
