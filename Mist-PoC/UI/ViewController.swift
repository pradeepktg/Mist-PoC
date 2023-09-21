//
//  ViewController.swift
//  Mist-PoC
//
//  Created by Pradeep Chandrasekaran on 22/08/23.
//

import UIKit
import FirebaseDatabase

protocol ViewDelegate: AnyObject {
    func didUpdateRelativeLocation(_ location: CGPoint)
}
var VBeaconModelList1 = [VBeaconModelElement]()


class ViewController: UIViewController {
    //var VBeaconModelList = [VBeaconModelElement]()
    //var ref: DatabaseReference!
    var viewModel: ViewModelWakeUpDelegate?

    var wakeUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(wakeUpServiceCall), for: .touchUpInside)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.setTitle("Start WakeUp Service", for: .normal)
        button.setTitle("Stop WakeUp Service", for: .selected)
        return button
    }()

//    var checkBeacon: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(checkBeaconExists), for: .touchUpInside)
//        button.backgroundColor = .gray
//        button.layer.cornerRadius = 5
//        button.setTitle("Check Beacon", for: .normal)
////        button.setTitle("Stop WakeUp Service", for: .selected)
//        return button
//    }()

    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.textColor = .black
        label.text = Mist.WakeUp.notMonitoringMessage
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // ref = Database.database().reference()
       // loadBeaconDetails()
        configureUI()
        updateStatus()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViewModel()
    }

    private func configureViewModel() {
        #if !targetEnvironment(simulator)
        let wakeUpService = RealWakeupService()
        let mistService = RealMistService(token: Mist.SDK.token)
        let viewModel = ViewModel(wakeUpService: wakeUpService, mistService: mistService)
        viewModel.viewDelegate = self
        wakeUpService.delegate = viewModel
        self.viewModel = viewModel
        #endif
    }


    fileprivate func configureUI()  {
        wakeUpButton.isSelected = false

        self.view.backgroundColor = .white
        [wakeUpButton, statusLabel].forEach{(self.view.addSubview($0))}

        wakeUpButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        wakeUpButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        wakeUpButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        wakeUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

//        checkBeacon.bottomAnchor.constraint(equalTo: self.wakeUpButton.topAnchor, constant: -20).isActive = true
//        checkBeacon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
//        checkBeacon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
//        checkBeacon.heightAnchor.constraint(equalToConstant: 40).isActive = true


        statusLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        statusLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true

    }
/*
    func loadBeaconDetails() {
        for i in 1...5 {
            VBeaconModelList1.append(VBeaconModelElement(orgID: "HTC", name: "Physical Beacon", message: "Hey, this is physical beacon", udid: "123456789", major: 1, minor: i))
        }

    } */

//    @objc func checkBeaconExists() {
//
//        var checkMajorExists:Bool = false
//        var checkMinorExists:Bool = false
//
//         checkMajorExists = VBeaconModelList1.filter {$0.major == 2}.isEmpty == false
//        if(checkMajorExists) {
//              checkMinorExists = VBeaconModelList1.filter {$0.minor == 0}.isEmpty == false
//        }
//
//        if(!checkMajorExists && !checkMinorExists) {
//            print("New");
//        }
//
//
//        if(!checkMajorExists){
//            let payload = NotificationData(title: "Found Virtual Beacon", subtitle: "mistVirtualBeacon.name", body: "mistVirtualBeacon.message")
//            Notification.schedule(after: 1.0, payload: payload)
//            let beacon = VBeaconModelElement(orgID: "mistVirtualBeacon.orgID", name: "mistVirtualBeacon.name", message: "mistVirtualBeacon.message", udid: "123456789", major: 2345, minor: 0002)
//            VBeaconModelList.append(beacon)
//            let beaconDict = ["OrgID" : beacon.orgID,
//                              "name" : beacon.name,
//                              "message" : beacon.message,
//                              "udid" : beacon.udid,
//                              "major" : beacon.major,
//                              "minor" : beacon.minor,
//                              "time" : Date().formatted(date: .abbreviated, time: .shortened)] as [String : Any]
//
//            ref.child("Beacons").childByAutoId().setValue(beaconDict)
//        } else {
//            if(checkMajorExists && !checkMinorExists){
//                let payload = NotificationData(title: "Found Virtual Beacon", subtitle: "mistVirtualBeacon.name", body: "mistVirtualBeacon.message")
//                Notification.schedule(after: 1.0, payload: payload)
//                let beacon = VBeaconModelElement(orgID: "mistVirtualBeacon.orgID", name: "mistVirtualBeacon.name", message: "mistVirtualBeacon.message", udid: "123456789", major: 2345, minor: 0002)
//                VBeaconModelList.append(beacon)
//                let beaconDict = ["OrgID" : beacon.orgID,
//                                  "name" : beacon.name,
//                                  "message" : beacon.message,
//                                  "udid" : beacon.udid,
//                                  "major" : beacon.major,
//                                  "minor" : beacon.minor,
//                                  "time" : Date().formatted(date: .abbreviated, time: .shortened)] as [String : Any]
//
//                ref.child("Beacons").childByAutoId().setValue(beaconDict)
//
//            }
//        }
//
//    }

    @objc func wakeUpServiceCall() {
#if targetEnvironment(simulator)
        statusLabel.text = Mist.WakeUp.unsupportedMessage

#else
        guard let viewModel = viewModel else { return }

        if viewModel.isWakeUpRuning {
            viewModel.stopWakeUp()
        } else {
            viewModel.startWakeUp()
        }
        updateStatus()

#endif
    }

    func updateStatus() {
        guard let viewModel = viewModel else { return }
        wakeUpButton.isSelected = viewModel.isWakeUpRuning
        statusLabel.text = wakeUpButton.isSelected ? Mist.WakeUp.monitoringMessage : Mist.WakeUp.notMonitoringMessage
    }
}

extension ViewController: ViewDelegate {

    func didUpdateRelativeLocation(_ location: CGPoint) {
        debugPrint(">>> didUpdateRelativeLocation = x=\(location.x) y=\(location.y)")
    }
}

