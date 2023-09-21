//
//  VBeaconModel.swift
//  Mist-PoC
//
//  Created by Pradeep Chandrasekaran on 14/09/23.
//

import Foundation

// MARK: - VBeaconModelElement
class VBeaconModelElement: Codable {
    let orgID, name, message, udid: String
    let major, minor: Int

    init(orgID: String, name: String, message: String, udid: String, major: Int, minor: Int) {
        self.orgID = orgID
        self.name = name
        self.message = message
        self.udid = udid
        self.major = major
        self.minor = minor
    }
}

typealias VBeaconModel = [VBeaconModelElement]
