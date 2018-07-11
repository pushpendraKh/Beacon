//
//  ViewController.swift
//  Beacon
//
//  Created by Pushpendra Khandelwal on 11/07/18.
//  Copyright © 2018 Pushpendra Khandelwal. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!

    @IBOutlet weak var button: UIButton! {
        didSet {
            button.layer.cornerRadius = button.bounds.height/2
            button.clipsToBounds = true
        }
    }
    
    private var beaconRange: CLBeaconRegion!
    private var peripheralManager: CBPeripheralManager!
    private var beaconData: NSMutableDictionary!
    
    private var status: String = "Beacon Status" {
        didSet {
            statusLabel.text = status
        }
    }
    
    private let uuid = UUID.init(uuidString: "9CD99728-41E9-4723-8A7B-75F379FA5555")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beaconRange = CLBeaconRegion.init(proximityUUID: uuid!,
                                               major: 1,
                                               minor: 1,
                                               identifier: "estimode-pushpendra")
        
    }


    @IBAction func didBroadcast(_ sender: Any) {
        beaconData = beaconRange.peripheralData(withMeasuredPower: nil)
        beaconData.setValue("kuliza", forKey: "company")
        beaconData.setValue("service based", forKey: "company_type")
        
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil, options: nil)
        
    }
    
}

extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            self.status = "Broadcasting...."
            self.peripheralManager.startAdvertising(self.beaconData as! [String : Any])
        case .poweredOff:
            self.status = "Stopped.."
            self.peripheralManager.stopAdvertising()
        case .unsupported:
            self.status = "Unsupported..."
        case .unauthorized:
            self.status = "Unauthorized..."
        default:
            self.status = "Unknown.."
        }
    
    }
}
