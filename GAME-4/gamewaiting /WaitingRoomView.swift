//
//  WaitingRoomView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/7.
//bug 準備的部分
//
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase

struct WaitingRoomView: View {
    //返回
    @Binding var goWaitingRoom: Bool
    @Binding  var currentUserData :UserData
    @State private var direction = "right"
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    //炸彈數字
    @State private var bomb_number = 0
    //@State private var goWaitingRoom = false
    @State private var goRoomBuilding = false
    @State private var goRoomSearching = false
    
    @State private var showRoomQuantity: Int = 0
    @State private var showPreparedQuantity: Int = 0
    @State private var showRoomName = ""
    
    @State private var showRoomStart : Bool = false
    
    @State private var showPlayer1_name : String = ""
    @State private var showPlayer2_name : String = ""
    
    @State  var URL_Player1 : String = ""
    @State  var URL_Player2 : String = ""
    
    @State var searchRoomName: String
    @State var creatRoomName: String
    
    @State var GamePrepared: Bool = false
    @State var GamePreparedText: String = "未準備"
    
    @Binding var roomDocumentName:String
    
    @State var goGameView = false
    @State var showEnterGameError = false
        
    
    var body: some View {
        
        ZStack{
            Image("createscreen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                        Text("等待房間:  \(showRoomName)")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 23))
                            .frame(width: 190, height: 25)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color("Color-1"))
                            .cornerRadius(10)
                            .offset(x: -260, y: -170)
            Button(action: {
                goWaitingRoom = false
            }, label: {
                Text("返回")
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .frame(width: 70, height: 35)
//                    .padding(.horizontal, 30)
//                    .padding(.vertical, 10)
                    .background(Color.red)
                    .cornerRadius(10)
            }).offset(x: 260, y: -170)
            HStack(alignment: .center, spacing: 70, content: {
                VStack{
                   
                    HStack{
                        VStack{
                            
                            ImageView(withURL: "\(URL_Player1)")
                                .scaledToFit()
                                .frame(width: 150, height: 180)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color.red, lineWidth: 3)
                                        .frame(width: 150, height: 150)
                                    
                                                    )
                                Text("\(showPlayer1_name)")
                                    .font(.system(size: 20))
                            
                        }.foregroundColor(.black)
                                    .frame(width: 150, height: 290)
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 10)
                                    .background(Color.yellow)
                                    .cornerRadius(10)
                                    .offset(x: 0, y: 30)
                    }
                    HStack{
                        
                        Button(action: {
                            GamePrepared.toggle()
                            if GamePrepared == true{
                                addprepare(room:roomDocumentName)
                                GamePreparedText = "已準備"
                            }else{
                                minusprepare(room:roomDocumentName)
                                GamePreparedText = "未準備"
                            }
                            
                        }, label: {
                            Text("\(GamePreparedText)")
                        }).offset(x: 0, y: -10.0)
                        Button(action: {
                            
                            if(showRoomQuantity == 2){
                                start(room: showRoomName)
                                    createCharacterPositon(name: userName, direction: direction, x: 0, y: 0)
                            }
                            else{
                                   showEnterGameError = true
                               }
                          
                        }, label: {
                            Text("進入遊戲")
                                .bold()
                        })
                        .alert(isPresented: $showEnterGameError) { () -> Alert in
                            
                            Alert(title: Text("遊戲進入失敗"), message: Text("人數不足兩人"), dismissButton: .default(Text("確定"), action: {
                                
                            }))
                            
                        }
                        .offset(x: 0, y: -10.0)

                    }
                }
                    VStack{
                       
                        HStack{
                            VStack{
                                ImageView(withURL: "\(URL_Player2)")
                                    .scaledToFit()
                                    .frame(width: 150, height: 180)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.red, lineWidth: 3)
                                            .frame(width: 150, height: 150)
                                
                                                        )
                                if(showPlayer2_name != nil){
                                    Text("\(showPlayer2_name)")
                                        .font(.system(size: 18))
                                }else{
                                    Text("等待進入")
                                        .font(.system(size: 18))
                                }
                                    
                                
                            }.foregroundColor(.black)
                                        .frame(width: 150, height: 290)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 10)
                                        .background(Color.yellow)
                                        .cornerRadius(10)
                                        .offset(x: 0, y: 30)
                        }
                        HStack{
                            Button(action: {
                                GamePrepared.toggle()
                                if GamePrepared == true{
                                    addprepare(room:roomDocumentName)
                                    GamePreparedText = "已準備"
                                }else{
                                    minusprepare(room:roomDocumentName)
                                    GamePreparedText = "未準備"
                                }
                                
                            }, label: {
                                Text("\(GamePreparedText)")
                            }).offset(x: 0, y: -10.0)
                     

                        }
                    }
            })
       
        .onAppear(
            perform:{
                //取得角色資訊
                userPhotoURL = (currentUser?.photoURL)
                if let user = Auth.auth().currentUser {
                    userName = currentUserData.username
                }
                //
                let db = Firestore.firestore()
                let db1 = Firestore.firestore()
                    
                db.collection("waitingRoom").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let room = try? snapshot.data(as: RoomState.self) else { return }
                    showRoomName = String(room.room_number)
                    showRoomStart = Bool(room.start)
                    
                    showRoomQuantity = Int(room.quantity)
                    showPreparedQuantity = Int(room.preparequantity)
                    
                    showPlayer1_name = String(room.player1)
                    showPlayer2_name = String(room.player2)
                    
                    
                    URL_Player1 = String(room.URL_player1)
                    URL_Player2 = String(room.URL_player2)
                    
                    
                    print("room.URL_player1 :\(room.URL_player1)")
                    print("room.URL_player2 :\(room.URL_player2)")
                    
                }
                
                db1.collection("Users_Data").document(Auth.auth().currentUser?.uid ?? "顯示錯誤").addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else { return }
                guard let hoster = try? snapshot.data(as: UserData.self) else { return }
                currentUserData = hoster

            }

            })
            
            EmptyView().sheet(isPresented: $showRoomStart,content:{
                gameView(Username: $currentUserData.username, roomDocumentName: $roomDocumentName)
                
            })
        }
 
        
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView(goWaitingRoom: .constant(true), currentUserData: .constant( UserData(id: "123", username: "KAIVIOR", userGender:"女", age: 0, userBD: "2000 May 21", userFirstLogin: "2021 May 25 13:44", userPhotoURL: "")), searchRoomName: "", creatRoomName: "", roomDocumentName: .constant(""))
            .previewLayout(.fixed(width: 844, height: 390))
    }
}

