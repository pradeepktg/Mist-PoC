//
//  MistService.swift
//  Mist-PoC
//
//  Created by Pradeep Chandrasekaran on 23/08/23.
//

import Foundation
import FirebaseDatabase


protocol MistService {
    var isStarted: Bool { get }
    func start()
    func stop()
}

#if !targetEnvironment(simulator)
import MistSDK
var VBeaconModelList = [VBeaconModelElement]()
//var ref: DatabaseReference!



class RealMistService: NSObject, MistService {
    var isStarted: Bool

    let mistManager: IndoorLocationManager

    init(token: String) {
       // ref = Database.database().reference()
        isStarted = false
        self.mistManager = IndoorLocationManager.sharedInstance(token)
    }

    func start() {
        isStarted = true
        // Subscribe other delegate callBack
        mistManager.indoorLocationDelegate = self
        mistManager.virtualBeaconsDelegate = self

        // start mist indoor location service
        mistManager.start(with: self)
    }

    func stop() {
        isStarted = false
        // stop mist indoor location service
        mistManager.stop()
    }
}

// MARK :- IndoorLocationDelegate
extension RealMistService: IndoorLocationDelegate {

    func didUpdate(_ map: MistMap!) {
        debugPrint(">>> didUpdate MistMap.name = \(map.name.description)")
    }

    func didUpdateRelativeLocation(_ relativeLocation: MistPoint!) {
        debugPrint(">>> didUpdateRelativeLocation MistPoint = x=\(relativeLocation.x) y=\(relativeLocation.y)")
    }

    func didReceivedOrgInfo(withTokenName tokenName: String!, andOrgID orgID: String!) {
        debugPrint(">>> didReceivedOrgInfo tokenName = \(tokenName.description) orgID = \(orgID.description)")
        let payload = NotificationData(title: "Organization Info", subtitle: tokenName, body: orgID)
        Notification.schedule(after: 1.0, payload: payload)
    }

    func didErrorOccur(with errorType: ErrorType, andMessage errorMessage: String!) {
        debugPrint(">>> didErrorOccur errorType = \(errorType.rawValue) errorMessage = \(errorMessage.description)")

    }
}

// MARK :- VirtualBeaconsDelegate
extension RealMistService: VirtualBeaconsDelegate {

    func didRangeVirtualBeacon(_ mistVirtualBeacon: MistVirtualBeacon!) {
        debugPrint(">>> didRangeVirtualBeacon MistVirtualBeacon.name = \(mistVirtualBeacon.name.description)")

        checkBeaconExists(mistVirtualBeacon: mistVirtualBeacon)

    }

    func didUpdateVirtualBeaconList(_ mistVirtualBeacons: [MistVirtualBeacon]!) {
        debugPrint(">>> didUpdateVirtualBeaconList mistVirtualBeacons = \(mistVirtualBeacons.count)")
    }
}

func checkBeaconExists(mistVirtualBeacon: MistVirtualBeacon) {
    var checkMajorExists:Bool = false
    var checkMinorExists:Bool = false

     checkMajorExists = VBeaconModelList.filter {$0.major == mistVirtualBeacon.vbMajor}.isEmpty == false

    if(checkMajorExists == true) {
        checkMinorExists = VBeaconModelList.filter {$0.minor == mistVirtualBeacon.vbMinor}.isEmpty == false
    }

    if(checkMajorExists  == false){
        let payload = NotificationData(title: "Found Virtual Beacon", subtitle: mistVirtualBeacon.name, body: mistVirtualBeacon.message)
        Notification.schedule(after: 1.0, payload: payload)
        let beacon = VBeaconModelElement(orgID: mistVirtualBeacon.orgID, name: mistVirtualBeacon.name, message: mistVirtualBeacon.message, udid: mistVirtualBeacon.vbUUID, major: mistVirtualBeacon.vbMajor, minor: mistVirtualBeacon.vbMinor)
        VBeaconModelList.append(beacon)
//        let beaconDict = ["OrgID" : beacon.orgID,
//                          "name" : beacon.name,
//                          "message" : beacon.message,
//                          "udid" : beacon.udid,
//                          "major" : beacon.major,
//                          "minor" : beacon.minor,
//                          "time" : Date().formatted(date: .abbreviated, time: .shortened)] as [String : Any]
//        ref.child("Beacons").childByAutoId().setValue(beaconDict)
        
    } else {
        if(checkMajorExists  == true && checkMinorExists == false){
            let payload = NotificationData(title: "Found Virtual Beacon", subtitle: mistVirtualBeacon.name, body: mistVirtualBeacon.message)
            Notification.schedule(after: 1.0, payload: payload)
            let beacon = VBeaconModelElement(orgID: mistVirtualBeacon.orgID, name: mistVirtualBeacon.name, message: mistVirtualBeacon.message, udid: mistVirtualBeacon.vbUUID, major: mistVirtualBeacon.vbMajor, minor: mistVirtualBeacon.vbMinor)
            VBeaconModelList.append(beacon)
//            let beaconDict = ["OrgID" : beacon.orgID,
//                              "name" : beacon.name,
//                              "message" : beacon.message,
//                              "udid" : beacon.udid,
//                              "major" : beacon.major,
//                              "minor" : beacon.minor,
//                              "time" : Date().formatted(date: .abbreviated, time: .shortened)] as [String : Any]
//            ref.child("Beacons").childByAutoId().setValue(beaconDict)
        }
    }

}

#endif
