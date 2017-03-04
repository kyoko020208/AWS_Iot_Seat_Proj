//
//  SeatViewController.swift
//  MySampleApp
//
//  Created by Kyoko Otsuka on 2017/02/25.
//
//
import Foundation
import UIKit
import AWSDynamoDB

class SeatViewController: UIViewController {
    
    
    @IBOutlet weak var Vacant: UILabel!
    
    @IBOutlet weak var Full: UILabel!
    
    
    @IBAction func reload(_ sender: UIButton) {
//        getItemWithCompletionHandler
        ColorChange()
    }
    
    var numberOfSeats: Int = 54
    
    var results2: String?
    
    var i: Int = 0
    
    var j: Int = 0
    
    let SBGreen = UIColor(red: 0/255, green: 112/255, blue: 74/255, alpha: 1.0)
    let hanterGreen = UIColor(red: 29/255, green: 68/255, blue: 40/255, alpha: 1.0)
    let snowwhite = UIColor(red: 246/255,green: 251/255, blue:253/255, alpha: 1.0)
    let Red = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
    
    @IBOutlet weak var Zaseki1: UIView!
    
    var vacantFlag: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(results2)
        
        ColorChange()
        
        Vacant.text = String(i)
        Full.text = String(j)
    }
    
    func ColorChange () {
        if results2 == "1" {
            Zaseki1.backgroundColor = SBGreen
            i += 1
        } else {
            Zaseki1.backgroundColor = Red
            j += 1
        }
    }
    
//    func getItemWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBObjectModel?, _ error: NSError?) -> Void) {
//        let objectMapper = AWSDynamoDBObjectMapper.default()
//        objectMapper.load(SanoParkTower.self, hashKey: "demo-key-3", rangeKey: "demo-timestamp-500000") { (response: AWSDynamoDBObjectModel?, error: Error?) in
//            DispatchQueue.main.async(execute: {
//                completionHandler(response, error as NSError?)
//            })
//        }
//        
//        
//    }
}

