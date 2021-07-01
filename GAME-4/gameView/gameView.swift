//
//  gameView.swift
//  FinalProject
//
//  Created by 吳庭愷 on 2021/6/6.
//
//記得把音樂放上去
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
import AVFoundation
struct off {
    var offset = CGSize.zero
    var state = "bomb"
    var timeRemaining = 1
    
}
struct coins_offset {
    var offset = CGSize.zero
    var state = "get"
}
struct gameView: View {
    @StateObject var playersData = PlayerData()
    @State var backtoLobby = false
    //timer
    @State var time_bar = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var to: CGFloat = 0
    @State var count1 = 0
    @State var start = false
    //
    @State  var currentUserData = UserData(id: "",username: "", userGender: "", age: 16, userBD: "", userFirstLogin: "", userPhotoURL: "")
    @State  var currentDate = Date()
    @State var time = ""
    @State var test = ""
    @State var Offset_bomb = CGSize.zero
    //操作者
    @State var coins_get = 0
    @Binding var Username : String
    @State var user_and_time = ""
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var nick_name = "KAIVIOR"
    @State private var direction = ""
    let flgFormatter = DateFormatter()

    //產生＿炸彈的編號
    @State var firebase_bomb_state = ""
    @State private var bomb_Number = 0
    //玩家名字
    @State var PlayerName = "KAIVIOR"
    @State var PlayerName2 = "我是你的父親"
    //roomdocument
    @Binding var roomDocumentName:String
    //炸彈的編號
    @State var bomb_number = 0
    @State private var bomb_orignal_state = "dud"
    @State private var bomb_bomb_state = "bomb"
    //
    @EnvironmentObject var gameObject: GameObject
    @State  var position_x :CGFloat = 350.0
    @State  var position_y :CGFloat = 200.0
    
    @State private var count = 0
    //my offset
    @State private var myOffset:CGSize = .zero
    //玩家的offset
    @State private var mineOffset:CGSize = .zero
    @State private var playerffset1:CGSize = .zero
    //這邊僅用來顯示
    //player1
    
    @State private var offset1:CGSize = .zero
    @State private var direction1 = "player1_right"
    //player2

    @State private var offset2:CGSize = .zero
    @State private var direction2 = "player2_right"
    //步數
    @State private var footStep :CGFloat = 25.0
    //未知
    @State var isAnime :Bool = false
    //多炸彈offset
    @State  var bomb_offset = [off]()
    @State  var offsetB:CGSize = .zero
    //chest random offset
    @State var chest1 = CGSize.zero
    @State var chest2 = CGSize.zero
    //coins random offset
    @State var coins = [coins_offset(offset: .zero),coins_offset(offset: .zero), coins_offset(offset: .zero), coins_offset(offset: .zero), coins_offset(offset: .zero)]
    //addbomb
    var dingPlayer: AVPlayer { AVPlayer.sharedDingPlayer}
    var bgmPlayer: AVPlayer { AVPlayer.sharedSpinPlayer}
    @State var number = 0
    func addbomb()
   {
        bomb_Number += 1
        create_bomb(name: user_and_time, number: bomb_Number, state: bomb_orignal_state, x: myOffset.width, y: myOffset.height)
        bomb_offset.append(off(offset: CGSize(width: myOffset.width, height: myOffset.height)))
        
   }
    func get_bomb(name:String,number:Int)  {
        let db = Firestore.firestore()
            db.collection("\(name)").document("\(number)").addSnapshotListener { snapshot, error in

            guard let snapshot = snapshot else { return }
            guard let location = try? snapshot.data(as: bomb_Location.self) else { return }
            Offset_bomb = CGSize(width: location.x, height: location.y)
        }
    }
    //給變chest位置
    @State private var counter = 0
    func coins_random()  {
        coins[0].offset.width = CGFloat.random(in: -200..<200)
        coins[0].offset.height = CGFloat.random(in: -170..<200)
        coins[1].offset.width = CGFloat.random(in: -200..<200)
        coins[1].offset.height = CGFloat.random(in: -170..<200)
        coins[2].offset.width = CGFloat.random(in: -200..<200)
        coins[2].offset.height = CGFloat.random(in: -170..<200)
        coins[3].offset.width = CGFloat.random(in: -200..<200)
        coins[3].offset.height = CGFloat.random(in: -170..<200)
        coins[4].offset.width = CGFloat.random(in: -200..<200)
        coins[4].offset.height = CGFloat.random(in: -170..<200)
        set_coins_location(location: Room_data( name: "12345", coins1_x: Int(coins[0].offset.width), coins1_y: Int(coins[0].offset.height), coins2_x: Int(coins[1].offset.width), coins2_y: Int(coins[1].offset.height), coins3_x: Int(coins[2].offset.width), coins3_y: Int(coins[2].offset.height), coins4_x: Int(coins[3].offset.width), coins4_y:Int(coins[3].offset.height), coins5_x: Int(coins[4].offset.width), coins5_y:Int(coins[4].offset.height)))
        
    }
    func Notify() {

        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Timer Is Completed Successfully In Background !!!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    struct bombView: View {
        @Binding var offset :CGSize
        @Binding var state :String
        var width: CGFloat = 0
        var body: some View {
          Image("\(state)")
            .resizable()
            .scaledToFit()
            .frame(width:width,height:width)
            .offset(offset)
        }
    }
    struct firebase_bomb: View {
        @Binding var name:String
        @Binding var number :Int
        //@Binding var state :String
        @Binding var offset: CGSize
        var width: CGFloat = 0
        var body: some View {
          
          Image("bomb")
            .resizable()
            .scaledToFit()
            .frame(width:width,height:width)
            .offset(offset)
        }
    

        }
    struct GameOverView: View {
        @Binding var Username:String
        @Binding var coins_get:Int
        @Binding var backtoLobby:Bool
        @StateObject var playersData = PlayerData()
        @EnvironmentObject var gameObject: GameObject
        var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color(red: 250/255, green: 243/255, blue: 221/255))
                    .frame(width: 400, height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .stroke(Color("Color"), lineWidth: 6)
                            .shadow(color: Color("Color"), radius: 3, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                            .frame(width: 400, height: 300)
                    )
                VStack{
                    HStack{
                        Text("Time's up")
                            .bold()
                            .font(.system(size: 30))
                            .offset(x: 50, y: 0)
                        Image("time")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .offset(x: 60, y: 0)
                    }
                    //.padding()
                    HStack{
                        Button {
                           //去標題
                            backtoLobby = true
                            withAnimation{
                              //  gameObject.isGameView = false
                            }
                         
                            addToRecordsData()
                            
                        } label: {
                            Text("回到大廳")
                                .fontWeight(.bold)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                   
                    
                }
            }.offset(x: -325, y: -100)
            
        }
        func addToRecordsData(){
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "y/MMM/d HH:mm"
            let newRecord = Player( name: Username, coins_get:  coins_get)
            for index in 0..<playersData.players.count{
                if(Username==playersData.players[index].name){
                    if( coins_get >= playersData.players[index].coins_get){
                            playersData.players.remove(at: index)
                            playersData.players.append(newRecord)
                            playersData.players.sort {
                                $0.coins_get < $1.coins_get
                            }
                        }
                    return
                }
            }
            playersData.players.append(newRecord)
            playersData.players.sort {
                $0.coins_get < $1.coins_get
            }
        }
    }
    
    //timer設定
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let timer2 = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{
          
            Group{
                Image("gamescreen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
            
             VStack{
                 ZStack{
                     Circle()
                         .trim(from: 0, to: 1)
                         .stroke(Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 20, lineCap: .round ))
                        .frame(width: 80, height: 80)
                     Circle()
                         .trim(from: 0, to: self.to)
                         .stroke(Color.red, style: StrokeStyle(lineWidth: 20, lineCap: .round ))
                         .frame(width: 80, height: 80)
                         .rotationEffect(.init(degrees: -90))
                     VStack{
                         Text("\(self.count1)")
                            .foregroundColor(.white)
                             .font(.system(size: 16))
                             .fontWeight(.bold)
                         
                         Text("Of 60")
                            .foregroundColor(.white)
                             .font(.system(size: 16))
                             .padding(.top)
                     }
                 }
                 .padding(.top, 55)
             }
             .offset(x: 340 , y: -140)
            RoundedRectangle(cornerRadius: 10)
            .stroke(Color("Color-4"), lineWidth: 2)
                .background(
                    Color("Color-4")
                )
                .cornerRadius(10)
            .frame(width: 280, height:35)
                .overlay(
                    Text("\(currentUserData.username)  coins: 0")
                        .bold()
                        .font(.system(size: 25))
                        .foregroundColor(.white)
               )
                .offset(x: -290, y: -170)

            coinsView(offset: $coins[0].offset)
            ForEach(0..<5, id: \.self)
            {(item) in
                    
                //print("location: \(gameObject.coins[item].offset)")
                coinsView(offset: $coins[item].offset)
            }
            manView1(direction: $direction1, offset: $offset1)
            manView2(direction: $direction2, offset: $offset2)
            
              ForEach(0..<bomb_offset.count, id: \.self)
               { (item) in
                  
                
                //get_bomb(name: user_and_time, number: item)
                
                bombView(offset: $bomb_offset[item].offset, state: $bomb_offset[item].state, width: 35)
                //bombView(offset: $Offset_bomb, state: $firebase_bomb_state, width: 35)
                        .onReceive(timer) { _ in
                            if bomb_offset[item].timeRemaining > 0 {
                                bomb_offset[item].timeRemaining -= 1
                                      }
                            else if bomb_offset[item].timeRemaining > -1{
                                bomb_offset[item].state = "bomb!"
                                change_bomb_state(name: user_and_time, number: item, state: bomb_offset[item].state, x: 0, y: 0)
                                dingPlayer.playFromStart()
                                bomb_offset[item].timeRemaining -= 1
                            }
                            else{
                                change_bomb_state(name: user_and_time, number: item, state: bomb_offset[item].state, x: 0, y: 0)
                                bomb_offset[item].state = "XXXX"
                            }
                       
                        }
                    
               }
            Controller(offset: $myOffset, direction: $direction, footstep: $footStep, PlayerName: $currentUserData.username)
                .position(x: 100, y: 350)
            
            Group {
                if self.count1 == 60{
                    GameOverView(Username: $Username, coins_get: $coins_get, backtoLobby: $backtoLobby)

                }
                EmptyView().sheet(isPresented: $backtoLobby,content:{
                    LobbyView(roomName: "", creatRoomName: "", SearchRoomName: "")
                    
                })

                JoyStickBackgroundView()
                //按鈕
                Button(action: {
                    //製作炸彈
                    addbomb()
                    number += 1
                }, label: {
                    Circle()
                        .fill(Color.viewbackground)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.5), lineWidth: 3)
                                .blur(radius: 4)
                                .offset(x: 2, y: 2)
                                .mask(Circle())
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.8), lineWidth: 6)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(Circle())
                        )
                        .frame(width: 80, height: 80)
                })
                KnobTopCircles()
                
            }.position(x: 750, y: 350)
           

            
        }.onAppear(perform: {
            
                self.start.toggle()
                flgFormatter.dateFormat = "y MMM dd HH:mm"
                currentDate = Date()
                time = flgFormatter.string(from: currentDate)
            
            let game_db = Firestore.firestore()
            let game_db2 = Firestore.firestore()
            let game_db3 = Firestore.firestore()
            let game_db4 = Firestore.firestore()
            let game_db5 = Firestore.firestore()
            let game_db6 = Firestore.firestore()
            let game_db7 = Firestore.firestore()
            let game_db8 = Firestore.firestore()
            
            //抓取 firebase data _bomb 的位置

           
            
            game_db6.collection("Users_Data").document(Auth.auth().currentUser?.uid ?? "顯示錯誤").addSnapshotListener { snapshot, error in
                        
                                    guard let snapshot = snapshot else { return }
                                    guard let hoster = try? snapshot.data(as: UserData.self) else { return }
                                    currentUserData = hoster
                                    print("gameView名稱抓取：\(hoster.username)")
              
                                }

            //此次遊玩所使用的炸彈
            //bomb_Number = 0
            
                      //  print("開始遊玩的時間~：\(time)")
                   
                        game_db.collection("waitingRoom").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
            
                            guard let snapshot = snapshot else { return }
                            guard let room = try? snapshot.data(as: RoomState.self) else { return }
            
                            PlayerName = String(room.player1)
                            PlayerName2 = String(room.player2)
                            
                            if(PlayerName == "KAIVIOR"){
                                nick_name = "player1"
                            }
                            else{
                                nick_name = "player2"
                            }
                            //抓取 firebase data _player_1 的位置
            
                            game_db2.collection("location").document("\(PlayerName)").addSnapshotListener { snapshot, error in

                                guard let snapshot = snapshot else { return }
                                guard let location = try? snapshot.data(as: Location.self) else { return }
                                offset1 = CGSize(width: location.x, height: location.y)
                                direction1 = location.direction

                            }
                            //抓取 firebase data _player_2 的位置

                            game_db3.collection("location").document("\(PlayerName2)").addSnapshotListener { snapshot, error in

                                guard let snapshot = snapshot else { return }
                                guard let location = try? snapshot.data(as: Location.self) else { return }
                                offset2 = CGSize(width: location.x, height: location.y)
                                direction2 = location.direction
                            }
            
                        }
                        coins_random()
                        //set_bomb_data
                        game_db4.collection("bomb_data").document("\(bomb_number)").addSnapshotListener { snapshot, error in
            
                            guard let snapshot = snapshot else { return }
                            guard let location = try? snapshot.data(as: Location.self) else { return }
                            
                        }
                        game_db5.collection("room_data").document("12345").addSnapshotListener { snapshot, error in
            
                            guard let snapshot = snapshot else { return }
                            guard let location = try? snapshot.data(as: Room_data.self) else { return }
                            coins[0].offset = CGSize(width: location.coins1_x, height: location.coins1_y)
                            coins[1].offset = CGSize(width: location.coins2_x, height: location.coins2_y)
                            coins[2].offset = CGSize(width: location.coins3_x, height: location.coins3_y)
                            coins[3].offset = CGSize(width: location.coins4_x, height: location.coins4_y)
                            coins[4].offset = CGSize(width: location.coins5_x, height: location.coins5_y)
            
                        }
            user_and_time = Username + time
            create_someones_bomb(user: user_and_time, number: bomb_Number, state: bomb_orignal_state, x: 0, y: 0)
            
            
            game_db8.collection("\(user_and_time)").document("\(bomb_Number)").addSnapshotListener { snapshot, error in

                guard let snapshot = snapshot else { return }
                guard let location = try? snapshot.data(as: bomb_Location.self) else { return }
                Offset_bomb = CGSize(width: location.x, height: location.y)
                firebase_bomb_state = location.state
                
            }
                    
        })
        .onReceive(timer2){_ in
            if self.counter % 60 == 0 {
                coins_random()
                            }
            self.counter += 1
                 
            
        }
        .onReceive(self.time_bar){ (_) in
            
            if self.start{
                
                if self.count1 != 60{
                    
                    self.count1 += 1
                    //gameObject.wintime += 1
                  //  print("hello")
                    
                    withAnimation(.default){
                        
                        self.to = CGFloat(self.count1) / 60
                    }
                }
                else{
                    
                        self.start.toggle()
                    
                    
                    self.Notify()
                }
            }
            
        }


    }
    struct manView1: View {
        @Binding var direction: String
        @Binding var offset: CGSize
        var body: some View{
            switch direction {
            case "left":
                Image("player1_left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                    .offset(offset)
            default:
                Image("player1_right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                    .offset(offset)
            }
        }
    }
    struct manView2: View {
        @Binding var direction: String
        @Binding var offset: CGSize
        var body: some View{
            switch direction {
            case "left":
                Image("player2_left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                    .offset(offset)
            default:
                Image("player2_right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50, alignment: .center)
                    .offset(offset)
            }
        }
    }

    struct coinsView: View {
        @Binding var offset: CGSize
        var body: some View{
            Image("coins")
              .resizable()
              .scaledToFit()
              .frame(width: 35,height: 35)
              .offset(offset)
        }
    }
    func set_coins_location(location: Room_data) {//更新狀態 沒用到
        let db = Firestore.firestore()
            
        do {
            try db.collection("room_data").document(location.name).setData(from: location)
        } catch {
            print(error)
        }
    }
}

extension AVPlayer {
    static var bgQueuePlayer = AVQueuePlayer()

    static var bgPlayerLooper: AVPlayerLooper!

    static func setupBgMusic() {
    guard let url = Bundle.main.url(forResource: "bgm", withExtension:
    "mp3") else { fatalError("Failed to find sound file.") }
    let item = AVPlayerItem(url: url)
    bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }

static let sharedDingPlayer: AVPlayer = {
guard let url = Bundle.main.url(forResource: "bomb", withExtension:
"mp3")
    else { fatalError("Failed to find sound file.") }
    
return AVPlayer(url: url)
}()

static let sharedSpinPlayer: AVPlayer = {
    guard let url = Bundle.main.url(forResource: "bgm", withExtension:
"mp3") else { fatalError("Failed to find sound file.") }
return AVPlayer(url: url)
}()

func playFromStart() {
    seek(to: .zero)
    play()
    }
}

struct gameView_Previews: PreviewProvider {
    static var previews: some View {
        gameView(Username: .constant(""), roomDocumentName: .constant(""), position_x: 350.0, position_y: 200.0)
            .previewLayout(.fixed(width: 844, height: 390))
            .environmentObject(GameObject())
    }
}
