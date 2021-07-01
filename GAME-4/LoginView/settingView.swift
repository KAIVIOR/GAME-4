//
//  settingView.swift
//  FinalProject
//
//  Created by 吳庭愷 on 2021/6/7.
//

import SwiftUI
import Firebase
struct settingView: View {

    //dull set
    @EnvironmentObject  var gameObject : GameObject
    @StateObject var myUserData = MyUserData()
    @State var ulr = ""
    @State private var myAlert = Alert(title: Text(""))
    @State private var newUser = UserData(id: "", username: "", userGender: "", age: 16, userBD: "", userFirstLogin: "", userPhotoURL: "")
    @State private var birthday = Date()
    @State private var age: CGFloat = 18
    var gender = ["男", "女"]
    @State private var genderSelect = 0
    let myDateFormatter = DateFormatter()
    let flgFormatter = DateFormatter()
    @State private var userBD = Date()
    @State private var currentDate = Date()
    @State private var usernick_name = ""
    @State private var userFirstLoginStr = "12"
    @State private var lobby_number = false
    @State  var showface = false
    @State private var go_personal = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State  var currentUserData = UserData(id: "", username: "", userGender: "女", age: 16, userBD: "", userFirstLogin: "", userPhotoURL: "")
    
    var body: some View {
        ZStack{
            
            Color("Color").edgesIgnoringSafeArea(.all)
           
            
            RoundedRectangle(cornerRadius: 10)
            .stroke(Color.black, lineWidth: 5)
            .frame(width: 500, height:380)
                .background(Color("Color-3"))
                   .cornerRadius(10)
                .overlay(
                    Image("screen2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 495, height:574)
                        .offset(x: 0, y: -6.6)
                )
                .overlay(
                    Text("個人設定")
                        .foregroundColor(.white)
                        .bold()
                        .font(.system(size: 35))
                        .frame(width: 495, height: 48, alignment: .center)
                        .background(RoundedCorners(tl: 8, tr: 9, bl: 0, br: 0).fill(Color("Color-1")))
                        .offset(x: 0.0, y: -164.3)
                )
                //.padding()
            VStack(alignment: .center, spacing: 10, content: {
                
                Text("")
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer(minLength: 200)
                    
                    HStack{
                        Image(systemName: "person.fill")
                            .resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                        
                        TextField("輸入暱稱", text: $usernick_name)
                     .padding(.leading, 12).font(.system(size: 20))

                    }
                .padding(12)
                .background(Color("Color-2"))
                .cornerRadius(20)
                    
                    Spacer(minLength: 200)
                })
                
                
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer(minLength: 200)
                    
                    HStack{
                        Image(systemName: "person.crop.rectangle")
                            .resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                        Text("年紀: \(Int(age))")
                                 Slider(value: $age, in: 16...65, step: 1, minimumValueLabel: Text("16"), maximumValueLabel: Text("65")) {
                                    Text("age")
                                 }

                    }
                .padding(12)
                .background(Color("Color-2"))
                .cornerRadius(20)
                    
                    Spacer(minLength: 200)
                })
                
                
                HStack(alignment: .center, spacing: 0, content: {
                    Spacer(minLength: 200)
                    
                    HStack{
                        Image(systemName: "g.circle")
                            .resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                        Text("性別:")
                        Spacer()
                        Picker(selection: $genderSelect, label: Text("性別")) {
                            Text(gender[0]).tag(0)
                            Text(gender[1]).tag(1)
                        }.pickerStyle(SegmentedPickerStyle())
                        .frame(width: 100)
                        .shadow(radius: 5)
                    }
                .padding(12)
                .background(Color("Color-2"))
                .cornerRadius(20)
                    
                    Spacer(minLength: 200)
                })
                

                HStack(alignment: .center, spacing: 0, content: {
                    Spacer(minLength: 200)
                    
                    HStack{
                        Image(systemName: "calendar")
                            .resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                        Text("生日")
                        Spacer()
                        DatePicker("", selection: $birthday, displayedComponents: .date)
                             
                    }
                .padding(12)
                .background(Color("Color-2"))
                .cornerRadius(20)
                    
                    Spacer(minLength: 200)
                })
                HStack(alignment: .center, spacing: nil, content: {
                    Button(action: {
                   
                        
               
                        modifySong()
                        lobby_number = true
//                        gameObject.userdata.age = Int(age)
//                        gameObject.userdata.username = usernick_name
//                        gameObject.userdata.userBD = myDateFormatter.string(from: userBD)
//                        gameObject.userdata.userFirstLogin = flgFormatter.string(from: currentDate)
//                        gameObject.userdata.userGender = gender[genderSelect]
//                        gameObject.userdata.userPhotoURL = ulr

                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("完成設定")
                                    .bold()
                                    .foregroundColor(.white)
                           )
                            
                    })
                    .buttonStyle(PlainButtonStyle())
                    .offset(x: 0, y: 20)
                    .fullScreenCover(isPresented: $lobby_number, content: {
                        LobbyView(roomName: "", creatRoomName: "", SearchRoomName: "")
                    })
                    Button(action: {
                 showface = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("頭像設定")
                                    .bold()
                                    .foregroundColor(.white)
                           )
                            
                    })
                    .buttonStyle(PlainButtonStyle())
                    .offset(x: 0, y: 20)
                    .fullScreenCover(isPresented: $showface, content: {
                        settingfaceView( showface: $showface, ulr: $ulr, newUser1: $currentUserData)
                    })
                })
                           
                            
                                
                      
            })
            .onAppear(perform: {
                self.userFirstLoginStr = flgFormatter.string(from: currentDate)
                
                flgFormatter.dateFormat = "y MMM dd HH:mm"
                myDateFormatter.dateFormat = "y MMM dd"
                //記錄第一次登入時間
                //userPhotoURL = (Auth.auth().currentUser?.photoURL)
                    
            })

                      }
        

    }
    func modifySong() {
        
        let db = Firestore.firestore()
        let newUser = UserData( username: usernick_name, userGender:  gender[genderSelect], age: Int(age), userBD: myDateFormatter.string(from: userBD), userFirstLogin: userFirstLoginStr, userPhotoURL: ulr)
            let documentReference =
                db.collection("Users_Data").document(Auth.auth().currentUser!.uid)
            documentReference.getDocument { document, error in
                            
              guard let document = document,
                    document.exists,
                    var user_data = try? document.data(as: UserData.self)
              else {
                        return
              }
                
                print("進行修改Firebase中的資料")
                user_data.username = usernick_name
                user_data.userBD = myDateFormatter.string(from: userBD)
                user_data.age = Int(age)
                user_data.userFirstLogin = flgFormatter.string(from: currentDate)
                user_data.userGender = gender[genderSelect]
                user_data.userPhotoURL = ulr
                
              do {
                 try documentReference.setData(from: user_data)
              } catch {
                 print(error)
              }
                            
            }
    }
    func showAlertMsg(msg: String) -> Void {
        self.alertMsg = msg
        if alertMsg == "設置基本資料成功" {
            self.myAlert = Alert(title: Text("成功"), message: Text(alertMsg), dismissButton: .default(Text("請重新登入"), action: {
                //FireBase.shared.userSingOut()
                self.presentationMode.wrappedValue.dismiss()}))
            self.showAlert = true
        }
        else {
            self.myAlert = Alert(title: Text("錯誤"), message: Text(alertMsg), dismissButton:
                .cancel(Text("重新輸入")))
            self.showAlert = true
        }
    }
  

}

struct settingView_Previews: PreviewProvider {
    static var previews: some View {
        settingView()
            .previewLayout(.fixed(width: 844, height: 390))
            .environmentObject(GameObject())
    }
}
