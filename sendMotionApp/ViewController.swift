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
            let session: WCSession = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    
    
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
//        var request = URLRequest(url: NSURL(string: "https://script.google.com/macros/s/AKfycbx592MBeBoz8pygZESl7etv6ws3gfADMZxV4oGHRY7Z11GvEhV0/exec?attitude=\(String(describing: message["attitude"]))&gravity=\(String(describing: message["gravity"]))&rotationRate=\(String(describing: message["rotationRate"]))&userAcceleration=\(String(describing: message["userAcceleration"]))&time=22")! as URL)
        
        // let urlString = "https://www.google.co.jp/"
        // let request = NSMutableURLRequest(url: URL(string: urlString)!)
        
        // request.httpMethod = "POST"
        
        // let params:[String:Any] = message
        
        // do{
        //     request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
        //     let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
        //         let resultData = String(data: data!, encoding: .utf8)!
        //         print("result:\(resultData)")
        //         print("response:\(String(describing: response))")
                
        //     })
        //     task.resume()
        // }catch{
        //     print("Error:\(error)")
        //     return
        // }
//
        replyHandler(
            ["reply" : message as Any])
    }
//    "gravity": self.gravity,
//    "rotationRate": self.rotationRate,
//    "userAcceleration": self.userAcceleration
  
    
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
