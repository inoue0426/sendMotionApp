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
        StartBtn.setHidden(true)
        StopBtn.setHidden(false)
        print("start")
        // randNum = String(arc4random_uniform(10000000))
        sendMessage()
    }
    
    @IBAction func pushStopBtn() {
        motionManager.stopDeviceMotionUpdates()
        print("stop")
        StartBtn.setHidden(false)
        StopBtn.setHidden(true)
        // randNum = ""
        sendMessage()
    }
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    var randNum =  String(UInt32())
    var applicationDict = [String: String]()
    var attitude = ""
    var gravity = ""
    var rotationRate = ""
    var userAcceleration = ""
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        activateSession()
        StopBtn.setHidden(true)
    }
    
    func activateSession(){
        if WCSession.isSupported() {
            let session: WCSession = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendMessage(){
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        if self.randNum == "" {
            motionManager.stopDeviceMotionUpdates()
            return
        }else{
            motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
                
                if error != nil {
                    print("Encountered error: \(error!)")
                }
                
                if deviceMotion != nil {
                    self.attitude = "\(deviceMotion!.attitude)"
                    self.gravity = "\(deviceMotion!.gravity)"
                    self.rotationRate = "\(deviceMotion!.rotationRate)"
                    self.userAcceleration = "\(deviceMotion!.userAcceleration)"
                }
                
                if WCSession.default.isReachable {
                    
                    let now = NSDate()
                    let srt = DateUtils.stringFromDate(date: now, format: "yyyy-MM-dd HH:mm:ss")
                    
                    self.applicationDict = [
                        "date": srt,
                        "attitude": self.attitude,
                        "gravity": self.gravity,
                        "rotationRate": self.rotationRate,
                        "userAcceleration": self.userAcceleration
                    ]
                    sleep(UInt32(0.5))
                    WCSession.default.sendMessage(self.applicationDict, replyHandler: {(reply) -> Void in
                        print(reply)
                    }){(error) -> Void in
                        print(error)
                    }
                }
            }
        }
    }
    
    class DateUtils {
        class func dateFromString(string: String, format: String) -> NSDate {
            let formatter: DateFormatter = DateFormatter()
            _ = Calendar(identifier: .gregorian) // グレゴリオ歴
            formatter.dateFormat = format
            return formatter.date(from: string)! as NSDate
        }
        
        class func stringFromDate(date: NSDate, format: String) -> String {
            let formatter: DateFormatter = DateFormatter()
            _ = Calendar(identifier: .gregorian) // グレゴリオ歴
            formatter.dateFormat = format
            return formatter.string(from: date as Date)
        }
    }
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    }
}
