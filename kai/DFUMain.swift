
//
//  DFUMain.swift
//  kai
//
//  Created by Tushar Singh on 23/03/19.
//  Copyright © 2019 Tushar Singh. All rights reserved.
//
var success = true
var inDFU = false
var kai = KaiBluetoothDFUManager()


import UIKit
import CoreBluetooth
import iOSDFULibrary
import Alamofire


class KaiBluetoothDFUManager: UIViewController, DFUServiceDelegate, DFUProgressDelegate, CBCentralManagerDelegate {
    
    var percentageDone:Float = 0
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "DfuTarg"{
            selectedPeripheral = peripheral
            inDFU = true
    
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:    bluetoothState = "Powered ON"
        centralManager?.scanForPeripherals(withServices: nil) ;break
        case .poweredOff:   bluetoothState = "Powered OFF";break
        case .resetting:    bluetoothState = "Resetting";break
        case .unauthorized: bluetoothState = "Unautthorized";break
        case .unsupported:  bluetoothState = "Unsupported";break
        case .unknown:      bluetoothState = "Unknown";break;
        }
    }
    
    var selectedPeripheral : CBPeripheral?
    var centralManager     : CBCentralManager?
    var selectedFirmware   : DFUFirmware?
    var selectedFileURL    : URL?
    
    
    var uploadStatus = ""
    var bluetoothState = ""
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectFirmware() {
        let stringPath = URL(string: "/var/mobile/Containers/Data/Application/BF40C083-7124-48C5-812F-69449826DA26/Documents/kai.zip")
        selectedFileURL = stringPath
        let fileNameExtension = stringPath?.pathExtension.lowercased()
        if fileNameExtension == "zip" {
            selectedFirmware = DFUFirmware(urlToZipFile: stringPath!)
        }
    }
    
    
    func performDFU() {
        
        let initiator = DFUServiceInitiator(centralManager: centralManager!, target: selectedPeripheral!)
        initiator.delegate = self
        initiator.progressDelegate = self
        initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
        
        if let str = selectedFirmware{
            let dfuStartVariable = initiator.with(firmware: selectedFirmware!)
            _ = dfuStartVariable.start()
            
        }else{
            print("nil")
            //performDFU()
        }
    }
    
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        percentageDone = Float(progress)
    }
    
    func dfuStateDidChange(to state: DFUState) {
        switch state {
        case .connecting:       uploadStatus = "connecting"
        case .starting:         uploadStatus = "starting"
        case .enablingDfuMode:  uploadStatus = "enablingDfuMode"
        case .uploading:        uploadStatus = "uploading"
        case .validating:       uploadStatus = "validating"
        case .disconnecting:    uploadStatus = "disconnecting"
        case .completed:
            // show a notification that the upload is completed
            showAlert(title: "Status", message: "Upload Completed")
        case .aborted:
            // show a notification that the upload is completed
            showAlert(title: "Status", message: "Upload Aborted")
        }
        print(uploadStatus)
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        success = false
        DispatchQueue.main.async {
            self.uploadStatus = "Error: \(message)"
            self.showAlert(title: "Error", message: message)
        }
    }
    
    func flashTheFirmware() {
        
    }
    
    func setTheDelegate() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scanForTheKai() {
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
    
    var downloadAPI = "http://dwnlds.vicara.co/kai.zip"
    var isDownloaded = false
    var downloadURL = String()
    
    func downloadFirmware(){
        let downloadLocation:DownloadRequest.DownloadFileDestination = {_,_ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("kai.zip")
            print(fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(downloadAPI, to: downloadLocation).response { response in
            if response.error == nil{
                print(response.destinationURL)
                self.selectedFirmware = DFUFirmware(urlToZipFile: response.destinationURL!)
                self.isDownloaded = true
                self.performDFU()
            }
        }
    }
}

