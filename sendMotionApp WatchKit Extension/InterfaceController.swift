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
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    var applicationDict = [String: String]()
    var attitude = ""
    var gravity = ""
    var rotationRate = ""
    var userAcceleration = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        activateSession()
        
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            if deviceMotion != nil {
//                print("attitude = \(deviceMotion!.attitude)")
//                print("gravity = \(deviceMotion!.gravity)")
//                print("rotationRate = \(deviceMotion!.rotationRate)")
//                print("userAcceleration = \(deviceMotion!.userAcceleration)")
//
                self.attitude = "\(deviceMotion!.attitude)"
                self.gravity = "\(deviceMotion!.gravity)"
                self.rotationRate = "\(deviceMotion!.rotationRate)"
                self.userAcceleration = "\(deviceMotion!.userAcceleration)"
            }
            sleep(UInt32(0.5))
            self.sendMessage()
        }
    }
    
    func activateSession(){
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            //            self.sendMessage()
        }
    }
    
    func sendMessage(){
        if WCSession.default.isReachable {
            applicationDict = [
                "attitude": attitude,
                "gravity": gravity,
                "rotationRate": rotationRate,
                "userAcceleration": userAcceleration
            ]
//            applicationDict = ["test":"Hello, World!!"]
            WCSession.default.sendMessage(applicationDict, replyHandler: {(reply) -> Void in
                print(reply)
//                print("           ")
            }){(error) -> Void in
                print(error)
//                print("gggggggggg")
            }
        }
    }
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //        print(message[0] as String)
    }
}
