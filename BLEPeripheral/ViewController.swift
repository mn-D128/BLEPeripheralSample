//
//  ViewController.swift
//  BLEPeripheral
//
//  Created by 電気なまず on 2017/11/12.
//  Copyright © 2017年 Masanori Nakano. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet private weak var logTV: UITextView!
    
    private let peripheralMgr: CBPeripheralManager
//    private let proximityUUID: UUID = UUID()
    private let proximityUUID: UUID = UUID(uuidString: "605391ce-48c0-4118-aa61-daeb5fdf99f1")!
    
    // MARK: - UIViewController
    
    required init?(coder aDecoder: NSCoder) {
        peripheralMgr = CBPeripheralManager(delegate: nil,
                                            queue: nil,
                                            options: nil)
        super.init(coder: aDecoder)
        
        peripheralMgr.delegate = self
        
        
        
//        let service = CBMutableService(type: CBUUID(nsuuid: proximityUUID),
//                                       primary: true)
//        peripheralMgr.add(service)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    // MARK: - Private
    
    private func addLog(_ text: String) {
        if var oldText: String = logTV.text {
            if 0 < oldText.count {
                oldText.append("\n")
            }
            
            oldText.append(text)
            
            logTV.text = oldText
        } else {
            logTV.text = text
        }
    }
    
    // MARK: - Action
    
    @IBAction private func startAdvertising(_ sender: UIButton) {
        if peripheralMgr.isAdvertising {
            addLog("アドバタイズ停止")
            peripheralMgr.stopAdvertising()
            sender.setTitle("アドバタイズ開始", for: .normal)
        } else {
            switch peripheralMgr.state {
            case .poweredOff: addLog("BluetoothをONにしてね")
            case .resetting: addLog("Bluetoothをリセット中")
            case .unauthorized: addLog("Bluetoothが許可されてない")
            case .unknown: addLog("Bluetoothが不明な不具合")
            case .unsupported: addLog("Bluetoothもってねよ")
                
            case .poweredOn:
                if let identifier: String = Bundle.main.bundleIdentifier {
                    let beaconRegion: CLBeaconRegion = CLBeaconRegion(proximityUUID: proximityUUID,
                                                                      identifier: identifier)
                    if let advertisementData: [String : Any] = beaconRegion.peripheralData(withMeasuredPower: nil) as? [String : Any] {
                        addLog("アドバタイズ開始")
                        addLog("  " + proximityUUID.uuidString)
//                        addLog("  " + identifier)
                        peripheralMgr.startAdvertising(advertisementData)
                        sender.setTitle("アドバタイズ停止", for: .normal)
                    }
                    
    //                let advertisementData: [String: Any] = [
    //                    CBAdvertisementDataLocalNameKey: "iphonedayo",
    //                    CBAdvertisementDataServiceUUIDsKey: [CBUUID(nsuuid: proximityUUID)]
    //                ]
    //
    //                addLog("アドバタイズ開始")
    //                addLog("  " + proximityUUID.uuidString)
    //                addLog("  " + identifier)
    //                peripheralMgr.startAdvertising(advertisementData)
                }
            }
        }
    }
    
    // MARK: - CBPeripheralManagerDelegate

    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            addLog("peripheralManagerDidUpdateState poweredOff")
            
        case .poweredOn:
            addLog("peripheralManagerDidUpdateState poweredOn")
            
        case .resetting:
            addLog("peripheralManagerDidUpdateState resetting")
            
        case .unauthorized:
            addLog("peripheralManagerDidUpdateState unauthorized")
            
        case .unknown:
            addLog("peripheralManagerDidUpdateState unknown")
            
        case .unsupported:
            addLog("peripheralManagerDidUpdateState unsupported")
        }
    }
    
    internal func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            addLog("peripheralManagerDidStartAdvertising error" + error.localizedDescription)
        } else {
            addLog("peripheralManagerDidStartAdvertising success")
        }
    }

//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, willRestoreState dict: [String : Any])
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?)
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic)
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic)
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest)
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])
//    optional public func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager)
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, didPublishL2CAPChannel PSM: CBL2CAPPSM, error: Error?)
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, didUnpublishL2CAPChannel PSM: CBL2CAPPSM, error: Error?)
//    optional public func peripheralManager(_ peripheral: CBPeripheralManager, didOpen channel: CBL2CAPChannel?, error: Error?)
    
}

