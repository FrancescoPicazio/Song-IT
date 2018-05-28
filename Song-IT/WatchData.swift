//
//  WatchData.swift
//  Song-IT
//
//  Created by Francesco Picazio on 05/01/18.
//  Copyright © 2018 Giovanni Bassolino. All rights reserved.
//

import UIKit
import WatchConnectivity


class WatchData: NSObject, WCSessionDelegate {
    
    var session: WCSession!
    
    static let shared = WatchData()
    
    var validSession: WCSession! {
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        
        return nil
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactive")
    }
    
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        print ("\(String(describing: error ?? nil))")
    }
    
    private var validReachableSession: WCSession? {
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }
    
    
    func inizialize() {
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
            
        } else {
            print("Session isn't active")
        }
        
        print("Activation state: \(session.activationState)")
        print("isParied:\(session.isPaired) \nisReachable: \(session.isReachable) \nisWatchAppInstalled: \(session.isWatchAppInstalled)")
    }
    
    
    func applicationContext(iPhoneAppContext: [String : Any]){
        if let validSession = validReachableSession {
            do {
                try validSession.updateApplicationContext(iPhoneAppContext)
            } catch {
                print("Something went wrong")
            }
        }
    }
}
