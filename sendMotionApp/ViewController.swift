//
//  ViewController.swift
//  sendMotionApp
//
//  Created by 井上雄貴 on 2017/11/30.
//  Copyright © 2017年 井上雄貴. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        activateSession()
    }

    func activateSession(){
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        var request = URLRequest(url: NSURL(string: "https://script.google.com/macros/s/AKfycbx592MBeBoz8pygZESl7etv6ws3gfADMZxV4oGHRY7Z11GvEhV0/exec?attitude=\(String(describing: message["attitude"]))&gravity=\(String(describing: message["gravity"]))&rotationRate=\(String(describing: message["rotationRate"]))&userAcceleration=\(String(describing: message["userAcceleration"]))&time=22")! as URL)
        
//        var request = URLRequest(url: NSURL(string: "https://script.google.com/macros/s/AKfycbx592MBeBoz8pygZESl7etv6ws3gfADMZxV4oGHRY7Z11GvEhV0/exec?attitude=10&gravity=20&rotationRate=30&userAcceleration=40&time=22")! as URL)
//        request.httpMethod = "GET"
//        NSURLConnection.sendSynchronousRequest(request, returning: nil)
        
        replyHandler(["reply" : message["attitude"] as Any])
    }
    
  
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate")
    }
}
