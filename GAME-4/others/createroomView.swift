////
////  createroomView.swift
////  GAME-4
////
////  Created by 吳庭愷 on 2021/6/12.
//
//
//import SwiftUI
//import Kingfisher
//import Firebase
//
//struct createroomView: View {
//    @EnvironmentObject var gameObject: GameObject
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @Binding var showroom : Bool
//    @State var currentUserData: UserData
//    @State private var titleText = ""
//    @State private var showText = false
//    @State private var userNum = 0
//    @State private var notReadyAlert = false
//    @State private var showHostLeft = false
//    @State private var gotoGameView = false
//    @State private var otherUserData = UserData(id: "", username: "", userGender: "", age: 0, userBD: "", userFirstLogin: "", userPhotoURL: "")
//    //@StateObject var myRoomData = myroom()
//    var mRN: String
//    var body: some View {
//        ZStack{
//            Image("createscreen")
//                .resizable()
//                .scaledToFill()
//                .edgesIgnoringSafeArea(.all)
//            Text("等待房間:   \(titleText)")
//                .bold()
//                .foregroundColor(.white)
//                .font(.system(size: 23))
//                .frame(width: 190, height: 30)
//                .padding(.horizontal, 30)
//                .padding(.vertical, 10)
//                .background(Color("Color-1"))
//                .cornerRadius(10)
//                .offset(x: -260, y: -150)
//            HStack{
//
//            VStack{
//                Text("主持人：\(currentUserData.username)")
//                    .font(.system(size: 25))
//                    .bold()
//                    .shadow(radius: 10)
//                    .padding(.bottom, 40)
//                if currentUserData.userPhotoURL != "" {
//                    //KFImage(URL(string: currentUserData.userPhotoURL)!)
//                    Image("me")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 90, height: 200)
//                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//                    .overlay(
//                        Rectangle()
//                            .stroke(Color.red, lineWidth: 3)
//                            .frame(width: 200, height: 200)
//
//                        )
//                }
//            }.foregroundColor(.black)
//            .frame(width: 200, height: 290)
//            .padding(.horizontal, 30)
//            .padding(.vertical, 10)
//            .background(Color.yellow)
//            .cornerRadius(10)
//            .offset(x: 0, y: 50)
//
//                Button(action: {
//                    showroom = false
//                }, label: {
//                    Text("返回")
//                        .bold()
//                })
//                HStack {
//                    VStack {
//                        //Text("\(myRoomData.roomData.user1.username)")
//                        Text("\(myRoomData.roomData.user1.username)")
//                            .font(.system(size: 25))
//                            .bold()
//                            .shadow(radius: 10)
//                            .padding(.bottom, 40)
//                        if currentUserData.userPhotoURL != "" {
//                            //KFImage(URL(string: currentUserData.userPhotoURL)!)
//                            Image("me")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 90, height: 200)
//                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//                            .overlay(
//                                Rectangle()
//                                    .stroke(Color.red, lineWidth: 3)
//                                    .frame(width: 200, height: 200)
//
//                                )
//                        }
//                    }.foregroundColor(.black)
//                    .frame(width: 200, height: 290)
//                    .padding(.horizontal, 30)
//                    .padding(.vertical, 10)
//                    .background(Color.yellow)
//                    .cornerRadius(10)
//                    .offset(x: 0, y: 50)
//
//           // .fullScreenCover(isPresented: $gotoGameView)
////                { GameView(myRoomData: myRoomData, userNum: userNum, startPlayer: myRoomData.roomData.startPlayer) }
//            .onAppear{
//
//                if mRN != "-1" {
//                    userNum = 1
//                }
//                self.myCreatRoom(roomNum: mRN)
//            }
//            .onReceive(self.myRoomData.secondPlayerInto , perform: { _ in
//                print("Second Player Into Room.")
//            })
//            .onReceive(self.myRoomData.roomReady, perform: { _ in
//                print("Get Ready, Goto Game View.")
//              //  self.myRoomData.removeRoomListener()
//                self.gotoGameView = true
//            })
//            .onReceive(self.myRoomData.changeHost, perform: { _ in
//                if userNum == 1{
//                    self.showHostLeft = true
//                    self.userNum = 0
//                }
//            })
//            .navigationTitle("等待房間: " + titleText)
//            .navigationBarBackButtonHidden(true)
//            .navigationBarItems(leading: Button(action:{
//                if userNum == 0 && self.myRoomData.roomData.user1.username != "" {
//                    self.myRoomData.leaveRoom(userNum: 0)
//                } else if userNum == 0 && self.myRoomData.roomData.user1.username == "" {
//                  //  self.myRoomData.removeRoomListener()
//                    self.myRoomData.delRoom()
//                } else {
//                    self.myRoomData.leaveRoom(userNum: 1)
//                }
//                self.presentationMode.wrappedValue.dismiss()
//                }){
//                HStack {
//                    Image(systemName: "figure.walk")
//                    Text("離開")
//                }.font(.title3)
//                .foregroundColor(.blue)
//            }, trailing:
//                Button(action:{
//                if self.userNum == 0{
//                    if myRoomData.roomData.user1ready {
//                        myRoomData.selectStartPlayer()
//                        myRoomData.getReady(userNum: 0)
//                    } else{
//                        self.notReadyAlert = true
//                    }
//                }else{
//                if self.myRoomData.roomData.user1ready{
//                    self.myRoomData.cancelReady(userNum: self.userNum)
//                }else {
//                    self.myRoomData.getReady(userNum: self.userNum)
//                }}}){
//                HStack {
//                    if self.userNum == 0 {
//                        Image(systemName: "gamecontroller")
//                            .foregroundColor(.red)
//                        Text("開始")
//                            .foregroundColor(.red)
//                    }else{
//                        if userNum == 1 && self.myRoomData.roomData.user1ready == false {
//                            Image(systemName: "gamecontroller")
//                            Text("準備")
//                        } else if userNum == 1 && self.myRoomData.roomData.user1ready {
//                            Image(systemName: "gamecontroller")
//                            Text("取消準備")
//                        }
//                    }
//                }.font(.title3)
//                .foregroundColor(.blue)
//
//            })
//                }
//            }
//        }
//
//
//    }
//
//    func myCreatRoom(roomNum: String) {
//        FireBase.shared.createRoom(ud: [currentUserData, otherUserData], rid_str: roomNum) { result in
//            switch result {
//            case .success(let rNum):
//                titleText = rNum
//                print("創建房間成功，房號為: " + rNum)
//                FireBase.shared.fetchRooms() { result in
//                    switch result {
//                    case .success(let rArray):
//                        for r in rArray {
//                            if r.id == rNum || r.id == mRN{
//                                myRoomData.roomData = r
//                                myRoomData.addRoomListener()
//                                break
//                            }
//                        }
//
//                    case .failure(_):
//                        print("fail")
//                    }
//                }
//            case .failure(_):
//                print("創建房間失敗")
//            }
//        }
//    }
//
//    private func endEditing() {
//        UIApplication.shared.endEditing()
//    }
//
//}
//
//struct createroomView_Previews: PreviewProvider {
//    static var previews: some View {
//        createroomView(showroom: .constant(true), currentUserData: UserData(id: "123", username: "KAIVIOR", userGender:"女", age: 0, userBD: "2000 May 21", userFirstLogin: "2021 May 25 13:44", userPhotoURL: ""), mRN: "13820")
//            .previewLayout(.fixed(width: 844, height: 390))
//            .environmentObject(GameObject())
//
//    }
//}
//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
