//
//  GAME_4App.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/8.
//

import SwiftUI

@main
struct GAME_4App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//          settingfaceView(newUser:.constant(UserData(id: "dd", userGender: "dd", age: 16, userBD: "dd", userFirstLogin: "dd")))
//                .previewLayout(.fixed(width: 844, height: 390))
            ContentView()
            
        }
    }
}
