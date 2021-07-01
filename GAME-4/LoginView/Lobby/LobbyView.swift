//
//  LobbyView.swift
//  FinalProject
//
//  Created by 吳庭愷 on 2021/6/7.
//



import Kingfisher
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
import AppTrackingTransparency
struct LobbyView: View {
    @State  var currentUserData = UserData(id: "",username: "", userGender: "", age: 16, userBD: "", userFirstLogin: "", userPhotoURL: "")
    @StateObject var myUserData = MyUserData()
    //收尋房間名稱
    
    @State var roomName: String
    @State var creatRoomName: String
    @State var SearchRoomName: String
    //頁面換
    @State var goWaitingRoom = false
    func requestTracking() {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .notDetermined:
                    break
                case .restricted:
                    break
                case .denied:
                    break
                case .authorized:
                    break
                @unknown default:
                    break
                }
            }
        }
    
    var body: some View {
        ZStack{
            
            Image("screen2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 0, content: {
               
                LinearGradient(gradient: Gradient(colors: [Color("Color-8"), Color("Color-9")]), startPoint: .top, endPoint: .bottom)
                    .frame(width: 940, height: 85, alignment: .center)
                    .offset(x: 0, y: -20)
                    
                    .overlay(
                        HStack(alignment: .center, spacing: 40, content: {
                            if myUserData.currentUser?.photoURL != nil {
                                KFImage(myUserData.currentUser?.photoURL)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55, height: 55)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color("Color-5"), lineWidth: 5 )
                                    )
                                    
                            }
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("Color-11"), lineWidth: 5)
                                .background(LinearGradient(gradient: Gradient(colors: [Color("Color-11"), Color("Color-10")]), startPoint: .top, endPoint: .bottom)
                                                .frame(width: 200, height: 31, alignment: .center)
                                )

                                .background( RoundedCorners(tl: 15, tr: 15, bl: 15, br: 15)
                                )

                                .frame(width: 203, height: 35, alignment: .center)
                              .overlay(
//
                                HStack{
                                    Text("暱稱:  " + (currentUserData.username))
                                        .foregroundColor(.white)
                                            .font(.system(size: 20))
                                            .bold()
                                        .padding(.trailing,20)

                                }
                                   )
                                   
                                
                                
                          
                        }).padding(.top,30)
                        .offset(x: -210, y: -25)
                        
                    )
               
                Spacer()
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color"), lineWidth: 5)
                            .frame(width: 250, height: 260, alignment: .center)
                            .background(RoundedCorners(tl: 8, tr: 9, bl: 0, br: 0).fill(Color("Color-1")))
                            .offset(x: 0, y: -60)
                            
                            .overlay(
                                VStack(alignment: .center, spacing: nil, content: {
                                   
                                    Text("Create a game")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.black)
                                        .offset(x: 0, y: -10)
                                    Text("自己創建一個新的遊戲房間")
                                        .bold()
                                    Image("gun")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .offset(x: 0, y: 0)
                                    Button(action: {
                                        let rid = [Int.random(in: 0...9), Int.random(in: 0...9), Int.random(in: 0...9), Int.random(in: 0...9)]
                                        roomName = String(rid[0]) + String(rid[1]) + String(rid[2]) + String(rid[3])
                                        createRoom(room_number: "\(roomName)", start: true, player1: "\(currentUserData.username)", player2: "", URL_player1: "\(currentUserData.userPhotoURL)", URL_player2: "", quantity: 1, preparedQuantity: 0)
                                        goWaitingRoom = true
                                        
                                        print("創建者名字: " + currentUserData.username)
                                    }, label: {
                                        SpecialButton(buttonText: "創建遊戲房間", buttonColor: Color("Color-6"))
                                    }).offset(x: 0, y: 10)

                                }).offset(x: 0, y: -65)
                                

                            )
                            
                       Spacer()
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color"), lineWidth: 5)
                            .frame(width: 250, height: 260, alignment: .center)
                            .background(RoundedCorners(tl: 8, tr: 9, bl: 0, br: 0).fill(Color("Color-1")))
                            .offset(x: 0, y: -60)
                            .overlay(
                                VStack(alignment: .center, spacing: nil, content: {
                                    Text("Join a game")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.black)
                                        //.offset(x: 0, y: -10)
                                    
                                    TextField("房間號碼",text:$SearchRoomName)
                                        .frame(width: 140, height: 30, alignment: .center)
                                        .overlay( RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.black, lineWidth: 3)
                                                        .frame(width: 160  , height: 40, alignment: .center)
                                            )
                                   
                                    //    .offset(x: 0, y: 10)
                                    
                                    Image("sniper")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100, alignment: .center)
                                      //  .offset(x: 0, y: 10)
                                    Button(action: {
                                        print("searchRoomName1:\(SearchRoomName)")
                                        let db4 = Firestore.firestore()
                                        db4.collection("waitingRoom").whereField("room_number", isEqualTo: "\(SearchRoomName)").getDocuments { snapshot, error in
                                            guard let snapshot = snapshot else { return }
                                                 if snapshot.documents.isEmpty  {
                                                    
                                                    print("找不到此房間，error")
                                                    print("searchRoomName:\(SearchRoomName)")
                                                    
                                                 } else {//要先取得id才能找到該密碼
                                                    print("success")
                                                    roomName = SearchRoomName
                                                    ModifyChararcterName(roomName:roomName,name: currentUserData.username, URLSting: currentUserData.userPhotoURL)
                                                    goWaitingRoom = true
                                                 }
                                        }
                                    }, label: {
                                        SpecialButton(buttonText: "進入以創建房間", buttonColor: Color("Color-7"))
                                    })
                                  


                                }).offset(x: 0, y: -65)
                                


                            )
                     
                        Spacer()
                    }
                    .offset(x: 0, y: -20)
            
              
            })
        }.onAppear(perform:{
            requestTracking()
        //抓使用者資料
        //let db3 = Firestore.firestore()
            let db3 = Firestore.firestore()
            db3.collection("Users_Data").document(Auth.auth().currentUser?.uid ?? "顯示錯誤").addSnapshotListener { snapshot, error in
            
            guard let snapshot = snapshot else { return }
            guard let hoster = try? snapshot.data(as: UserData.self) else { return }
            currentUserData = hoster
            print("hoster 名稱抓取：\(hoster.username)")
            
        }
    })
        EmptyView().sheet(isPresented: $goWaitingRoom, content:{WaitingRoomView(goWaitingRoom: $goWaitingRoom, currentUserData: $currentUserData, searchRoomName: "", creatRoomName: "", roomDocumentName: $roomName)})
      
    }
    
}
struct LobbyView_Previews: PreviewProvider {
    static var previews: some View {
        LobbyView(roomName: "", creatRoomName: "", SearchRoomName: "")
            .previewLayout(.fixed(width: 844, height: 390))
            .environmentObject(GameObject())
    }
}

