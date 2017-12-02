//
//  InterfaceController.swift
//  sendMotionApp WatchKit Extension
//
//  Created by 井上雄貴 on 2017/11/30.
//  Copyright © 2017年 井上雄貴. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import CoreMotion

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var StartBtn: WKInterfaceButton!
    @IBOutlet var StopBtn: WKInterfaceButton!
    
    @IBAction func pushStartBtn() {
        self.sendMessage()
        StartBtn.setHidden(true)
        StopBtn.setHidden(false)
    }
    
    @IBAction func pushStopBtn() {
        StartBtn.setHidden(false)
        StopBtn.setHidden(true)
        motionManager.stopDeviceMotionUpdates()
    }
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    var applicationDict = [String: String]()
    var attitude = ""
    var gravity = ""
    var rotationRate = ""
    var userAcceleration = ""
    
    var workout = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        activateSession()
        StopBtn.setHidden(true)
        
//        if !motionManager.isDeviceMotionAvailable {
//            print("Device Motion is not available.")
//            return
//        }
//
//        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
//            if error != nil {
//                print("Encountered error: \(error!)")
//            }
//
//            if deviceMotion != nil {
//                self.attitude = "\(deviceMotion!.attitude)"
//                self.gravity = "\(deviceMotion!.gravity)"
//                self.rotationRate = "\(deviceMotion!.rotationRate)"
//                self.userAcceleration = "\(deviceMotion!.userAcceleration)"
//
////                print(self.attitude)
////                print(self.gravity)
////                print(self.rotationRate)
////                print(self.userAcceleration)
//            }
//            sleep(UInt32(0.5))
//        }
    }
    
    func activateSession(){
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendMessage(){
        let randNum = arc4random_uniform(10000000)
        
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            if deviceMotion != nil {
                self.attitude = "\(deviceMotion!.attitude)"
                self.gravity = "\(deviceMotion!.gravity)"
                self.rotationRate = "\(deviceMotion!.rotationRate)"
                self.userAcceleration = "\(deviceMotion!.userAcceleration)"
                
                                print(self.attitude)
                                print(self.gravity)
                                print(self.rotationRate)
                                print(self.userAcceleration)
            }
            
//            sleep(UInt32(0.5))
            if WCSession.default.isReachable {
                self.applicationDict = [
                    "deviceLabel": "D\(randNum)",
                    "attitude": self.attitude,
                    "gravity": self.gravity,
                    "rotationRate": self.rotationRate,
                    "userAcceleration": self.userAcceleration
                ]
                
                WCSession.default.sendMessage(self.applicationDict, replyHandler: {(reply) -> Void in
                    print(reply)
                }){(error) -> Void in
                    print(error)
                }
            }
        }
//        print(applicationDict["deviceLabel"])
    }
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

    }
    
    
}
