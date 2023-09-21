//
//  String.swift
//  Mist-PoC
//
//  Created by Pradeep Chandrasekaran on 23/08/23.
//

extension String {

    var shortOrgUUIDString: String {
        let shortOrgId = String(self.dropLast(2))
        let orgUUIDString = String(format: "%@%@", shortOrgId, "0")
        return orgUUIDString
    }
}
