//
//  BeaconRegion.swift
//  Mist-PoC
//
//  Created by Pradeep Chandrasekaran on 23/08/23.
//

import Foundation
import CoreLocation

extension CLBeaconRegion {

    static func create(with name: String, uuid: UUID) -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: name)
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        beaconRegion.notifyEntryStateOnDisplay = true
        return beaconRegion
    }
}
