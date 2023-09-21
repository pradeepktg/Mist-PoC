//
//  constants.swift
//  Mist-PoC
//
//  Created by Pradeep Chandrasekaran on 22/08/23.
//

import Foundation

struct Mist {

    struct SDK {
//        static let token = "PdVsiSlXAMdnq4Bkl58YsWEnTT3HQssL" // HTC MIST SDK TOKEN
//        static let orgId = "8b86bad7-e6b5-47d0-81aa-607bf3fe09bf" // HTC MIST ORG ID

        static let token = "Pc5KTOBPGgSbXxddNHTsZXpVmdAn5zWq" // MEIJER MIST SDK TOKEN
        static let orgId = "39b04356-4cc3-41cc-bc1a-5de54beb1941" // MEIJER MIST ORG ID

    }

    struct WakeUp {
        static let monitoringMessage = "The app is monitoring beacons. You can minimize the app now."
        static let notMonitoringMessage = "The app is not monitoring beacons."
        static let unsupportedMessage = "Simulator is not supported to scan Bluetooth devices"
    }

}
