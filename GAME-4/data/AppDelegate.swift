//
//  AppDelegate.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/8.
//

import UIKit
import Firebase
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        AVPlayer.setupBgMusic()
        //AVPlayer.bgQueuePlayer.play()
        
        FirebaseApp.configure()
        
        return true
    }
}
