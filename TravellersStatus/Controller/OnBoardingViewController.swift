//
//  OnBoardingViewController.swift
//  TravellersStatus
//
//  Created by Siva Cherukuri on 08/02/17.
//  Copyright © 2017 ithaka. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIRequestManagerDelegate {
    
    /// Util class Object - To check internet connection, to show loading view etc..
    var utilObj = UtilClass()
    
    var travelersDataObj = TravelersData()

    var OnBoardingDataArray = Array<Any>()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var onBoardingCount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.getHackerStoriesFromServer()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(OnBoardingViewController.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)

    }

    func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot : UIView? = nil
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
        
        switch state {
        case UIGestureRecognizerState.began:
            if indexPath != nil {
                Path.initialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!) as UITableViewCell!
                My.cellSnapshot  = snapshotOfCell(cell!)
                
                var center = cell?.center
                My.cellSnapshot!.center = center!
                My.cellSnapshot!.alpha = 0.0
                tableView.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center!
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
            
        case UIGestureRecognizerState.changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    self.OnBoardingDataArray.insert(self.OnBoardingDataArray.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
                    tableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = tableView.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = (cell?.center)!
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.OnBoardingDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let onBoardData:OnBardingDoneData = self.OnBoardingDataArray[indexPath.row] as! OnBardingDoneData
        cell.textLabel?.text =  onBoardData.travellerName
        cell.detailTextLabel?.text = "Trip Date:  " + onBoardData.travelDate!
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.layer.cornerRadius = 10 //set corner radius here
        cell.layer.borderColor = UIColor.black.cgColor  // set cell border color here
        cell.layer.borderWidth = 0.5 // set border width here
        cell.textLabel?.font = UIFont(name: "Cochin-Bold", size: 28.0)
        cell.detailTextLabel?.font = UIFont(name: "Cochin", size: 17.0)

        return cell

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getHackerStoriesFromServer()
    {
        
        // Check internet status
        
        if UtilClass.isConnectedToNetwork()
        {
            // Dispose of any resources that can be recreated.
            
            // Show activity indicator on the table view
            self.tableView.addSubview(utilObj.showLoadingViewOn())
            
            var resultString = kBaseUrl
            resultString += "travelers"
            
            let apiManager = APIRequestManager();
            apiManager.delegate = self
            
            /// Delegate call backs
            /// 1.func didgetResponseSuccessfully(jsonData: Any)
            /// 2. func didgetResponseFail(error: NSString)
            
            apiManager.getJsonResponseFromUrl(urlString: resultString)
            
        }
        else
        {
            self.displayAlertView(alertMessage: "Please connect to internet")
        }
        
    }
    
    // MARK: APIRequestManager delegate funtions
    
    func didgetResponseSuccessfully(jsonData: Any)
    {
       travelersDataObj = TravelersData((jsonData as? Array)!)
       self.OnBoardingDataArray = travelersDataObj.onBoardingDataArray
        
        let sharedTravelObj:TravelersManager = TravelersManager.sharedInstance
        sharedTravelObj.localTravelData = travelersDataObj
        
        DispatchQueue.main.sync {
            
            self.onBoardingCount.text = "OnBoardingDone(" + "\(self.OnBoardingDataArray.count)" + ")"
            tableView.reloadData()
            utilObj.removeLoadingView()
            
        }
    }
    
    func didgetResponseFail(error: NSString)
    {
        self.displayAlertView(alertMessage: error as String)
        
    }
    
    // MARK: Alert View
    func displayAlertView(alertMessage:String)
    {
        
        let alert = UIAlertController(title: "Alert", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            switch action.style{
                
            case .default:
                //Check internet status
                if UtilClass.isConnectedToNetwork()
                {
                    //Get data from server, if user connects to internet
//                    self.getHackerStoriesFromServer()
                }
                else
                {
                    self.displayAlertView(alertMessage: "Please connect to internet")
                    
                }
                
                
            case .cancel: break
                
            case .destructive: break
                
            }
            
        }))
    }

}
