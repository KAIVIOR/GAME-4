//
//  ContentView.swift
//  FinalProject
//
//  Created by 吳庭愷 on 2021/5/19.
//
import UIKit
import SwiftUI

extension UIViewController {
    static func getLastPresentedViewController() -> UIViewController? {
        let window = UIApplication.shared.windows.first {
            $0.isKeyWindow
        }
        var presentedViewController = window?.rootViewController
            while presentedViewController?.presentedViewController != nil {
                presentedViewController = presentedViewController?.presentedViewController
        }
        return presentedViewController
    }
}
struct ContentView: View {
    @StateObject var gameObject = GameObject()
    var currentUserData = UserData( username: "KAIVIOR", userGender: "", age: 13, userBD: "", userFirstLogin: "", userPhotoURL: "https://firebasestorage.googleapis.com:443/v0/b/final-b3b4e.appspot.com/o/789FBB38-1CE7-4983-9DB5-7213F9215766.png?alt=media&token=7b5e733d-fe4b-4641-aace-104d23927fe7")
    @State var roomName = "4833"
    @State var name = "KAIVIOR"
    @State var testbool = false
    var body: some View {
       // CrashTextView()
        //gameView(Username: $name, roomDocumentName: $roomName).environmentObject(gameObject)
        //EnterRoomView(roomName: "", creatRoomName: "", SearchRoomName: "", searchRoomPassword: "", crearhRoomPassword: "")
        //LobbyView(roomName: "", creatRoomName: "", SearchRoomName: "")
        //ContentView()
        GateView()
        //createroomView(showroom: $testbool , currentUserData: currentUserData, mRN: "-1")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            gameView(Username: .constant(""), roomDocumentName: .constant(""))
                .previewLayout(.fixed(width: 844, height: 390))
           
        }
            
    }
}

//import GoogleMobileAds
//class RewardedAdController: NSObject {
//    private var ad: GADRewardedAd?
//
//        func loadAd() {
//            let request = GADRequest()
//                GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) {ad, error in
//                    if let error = error {
//                        print(error)
//                        return
//                    }
//                    ad?.fullScreenContentDelegate = self
//                    self.ad = ad
//                }
//
//        }
//
//func showAd() {
//    if let ad = ad,
//        let controller = UIViewController.getLastPresentedViewController() {
//
//        ad.present(fromRootViewController: controller) {
//            }
//        }
//    }
//
//}

//struct ContentView: View {
    //@State private var ad: GADRewardedAd?
//    let rewardedAdController = RewardedAdController()
//    func loadAd()  {
//        let request = GADRequest()
//
//        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313", request: request) {ad, error in
//
//        if let error = error {
//            print(error)
//                return
//        }
//            self.ad = ad
//        }
//    }
//    func showAd()  {
//        if let ad = ad,
//           let controller = UIViewController.getLastPresentedViewController() {
//
//                ad.present(fromRootViewController: controller) {
//                }
//
//        }
    //}
    
    //var body: some View {
//        VStack{
//            Button(action: {rewardedAdController.loadAd()}, label: {
//                Text("load Ad")
//            })
//            Button(action: {rewardedAdController.showAd()}, label: {
//                Text("show Ad")
//            })
//
//        }
//        Text("Hello")
//    }
//}
//extension RewardedAdController: GADFullScreenContentDelegate {
//
//    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print(#function)
//    }
//
//    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print(#function)
//    }
//
//    func ad(_ ad: GADFullScreenPresentingAd,
//            didFailToPresentFullScreenContentWithError error: Error) {
//                print(#function, error)
//
//    }
//
//}

