//
//  ViewModel.swift
//  Mist-PoC
//
//  Created by Pradeep Chandrasekaran on 23/08/23.
//

import Foundation
import CoreLocation
import FirebaseDatabase

protocol ViewModelWakeUpDelegate: AnyObject {
    var isWakeUpRuning: Bool { get }
    func startWakeUp()
    func stopWakeUp()
}

protocol ViewModelMistServiceDelegate: AnyObject {
    func startMistService()
    func stopMistService()
}


// MARK: - ViewModel

class ViewModel {
    weak var viewDelegate: ViewDelegate?
    private let wakeUpService: WakeUpService
    private let mistService: MistService

    init(wakeUpService: WakeUpService, mistService: MistService) {
        self.wakeUpService = wakeUpService
        self.mistService = mistService
    }
}

extension ViewModel: WakeUpServiceDelegate {
    func didRangeBeacons(beacon: [CLBeacon], region: CLRegion) {
        debugPrint(">>> found beacon")

        let payload = NotificationData(title: "Found physical beacon", subtitle: region.identifier, body: beacon.first?.description ?? "")
        Notification.schedule(after: 1.0, payload: payload)
    }

    func didStartMonitoring(region: String) {
        debugPrint(">>> Started to find region = \(region)")
        let payload = NotificationData(title: "Started to find region", subtitle: region, body: region)
        Notification.schedule(after: 1.0, payload: payload)
    }

    func didFailRegion(error: Error) {
        debugPrint(">>> Failed to find region = \(error)")
        let payload = NotificationData(title: "Failed to find region", subtitle: error.localizedDescription, body: error.localizedDescription)
        Notification.schedule(after: 1.0, payload: payload)

    }

    func didEnterRegion(region: String) {
        debugPrint(">>> didEnterRegion Beacon = \(region)")

        let payload = NotificationData(title: "didEnterRegion", subtitle: region, body: "Welcome!! You have enter in the beacon range")
        Notification.schedule(after: 1.0, payload: payload)

        if mistService.isStarted == false {
            // Start Mist SDK
            mistService.start()

            let sdkPayload = NotificationData(title: "Starting SDK...", subtitle: "", body: "Mist Location Tracking Started !!!")
            Notification.schedule(after: 2.0, payload: sdkPayload)
        }
    }

    func didExitRegion(region: String) {
        debugPrint(">>> didExitRegion Beacon = \(region)")
    }
}


// MARK: - App WakeUp
extension ViewModel: ViewModelWakeUpDelegate {

    var isWakeUpRuning: Bool {
        wakeUpService.isWakeUpRuning
    }

    func startWakeUp() {
        wakeUpService.start()
    }

    func stopWakeUp() {
        wakeUpService.stop()
    }
}

// MARK: - Mist SDK Service Call
extension ViewModel: ViewModelMistServiceDelegate {

    func startMistService() {
        mistService.start()
    }

    func stopMistService() {
        mistService.stop()
    }
}
