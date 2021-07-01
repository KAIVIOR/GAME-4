//
//  GateView.swift
//  FinalProject
//
//  Created by 吳庭愷 on 2021/6/6.
//

import SwiftUI
import FirebaseAuth
struct GateView: View {
    @State  var showSecondPage = false
    @State  var mail = ""
    @State  var pass = ""
    @State private var succed = false
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State private var showView = false
    @StateObject var pageObject = PageObject()
    @StateObject var gameObject = GameObject()
        var body: some View {
            ZStack{

                Image("createscreen")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                Text("Bomb Man")
                    .foregroundColor(.white)
                    .bold()
                    .font(.system(size: 50))
                    .offset(x: 0.0, y: -130.0)
                VStack{
                    
                    VStack(alignment: .center, spacing: 0, content: {
                        
                        HStack(alignment: .center, spacing: 0, content: {
                            Spacer(minLength: 200)
                            
                                HStack{
                                    Image(systemName: "person.fill").resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                                    TextField("email", text: $mail).padding(.leading, 12).font(.system(size: 20))
                                }
                            .padding(12)
                            .background(Color("Color-2"))
                            .cornerRadius(20)
                            
                            Spacer(minLength: 200)
                        })
                        .padding(10)
                        HStack(alignment: .center, spacing: 0, content: {
                            Spacer(minLength: 200)
                            
                                HStack{
                                    
                            Image(systemName: "lock.fill").resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                                    
                            TextField("Password", text: $pass).padding(.leading, 12).font(.system(size: 20))
                                    
                                }
                            .padding(12)
                            .background(Color("Color-2"))
                            .cornerRadius(20)
                            
                            Spacer(minLength: 200)
                        })
                        .padding(10)
                        HStack(alignment: .center, spacing: nil, content: {
                            Text("你有帳號嗎？若是沒有請")
                                .foregroundColor(.white)
                               .bold()
                               .font(.system(size: 20))
                               Button(action: {
                                
                                showSecondPage = true
                                
                               }, label: {
                                   Text("註冊")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.system(size: 20))
                               }) .sheet(isPresented: $showSecondPage, content: {
                                RegisterView(showSecondPage:$showSecondPage)
                                        })
                              
                        })
                        HStack(alignment: .bottom, spacing: 50, content: {
                            Button(action:{
                                FireBase.shared.userSingIn(userEmail: mail, pw: pass){
                                    (result) in
                                    switch result {
                                    case .success( _):
                                        if let user = Auth.auth().currentUser {
                                            print("\(user.uid) 登入成功")
                                            FireBase.shared.fetchUsers(){
                                                (result) in
                                                switch result {
                                                case .success(let udArray):
                                                    print("使用者資料抓取成功")
                                                    for u in udArray {
                                                        if u.id == user.uid {

                                                            succed  = true
                                                            //登入成功
                                                        }
                                                    }
                                                    showView = true
                                                    
                                                case .failure(_):
                                                    print("使用者資料抓取失敗")
                                                    
                                                    showView = false
                                                    //showView = true
                                                }
                                            }
                                        } else {
                                            print("登入失敗")
                                        }
                                    case .failure(let errormsg):
                                        switch errormsg {
                                        case .pwInvalid:
                                            alertMsg = "密碼錯誤"
                                            showAlert = true
                                        case .noAccount:
                                            alertMsg = "帳號不存在，請註冊或使用其他帳號"
                                            showAlert = true
                                        case .others:
                                            alertMsg = "不明原因錯誤，請重新登入"
                                            showAlert = true
                                        }
                                    }
                                }
                            }){
                                Text("Email 登入")
                                    .foregroundColor(.white)
                                    .bold()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                            .frame(width: 93, height:40))
                                    
                            }
                            
                            if  succed{
                                EmptyView().fullScreenCover(isPresented: $succed)
                                    {
                                    LobbyView(roomName: "", creatRoomName: "", SearchRoomName: "")
                                }
                            }
                            else {
                                EmptyView().fullScreenCover(isPresented: $showView)
                                    {
                                    settingView()
                                }
                                }
                            //succed == true 代表一定是成功的 但不知道是否有個資

                            Button(action: {
                                
                            }, label: {
                                            Text("Facebook")
                                                .foregroundColor(.white)
                                                .bold()
                                                .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 2)
                                                .frame(width: 93, height:40))
                            })

                        }).offset(x: 0, y: 50)
                          
                        
                    })
                                  

                }
            }
    }
    struct RegisterView: View {
        @State  var user = ""
        @State  var pass = ""
        @State  var check_pass = ""
        @State  var pass_not_same = false
        @State  var pass_same = false
        @StateObject var pageObject = PageObject()
        @Binding var showSecondPage : Bool
        var body: some View {
            ZStack{
                Color("Color").edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: nil, content: {
                    HStack(alignment: .center, spacing: 0, content: {
                        Spacer(minLength: 200)
                        
                        HStack{
                            Image(systemName: "person.fill").resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                            
                            TextField("Email", text: $user).padding(.leading, 12).font(.system(size: 20))

                        }
                    .padding(12)
                    .background(Color("Color-2"))
                    .cornerRadius(20)
                        
                        Spacer(minLength: 200)
                    })
                    .padding(10)
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        Spacer(minLength: 200)
                        HStack{
                            Image(systemName: "lock.fill").resizable().frame(width: 20, height: 20).padding(.bottom, 0)
                            
                            TextField("Password", text: $pass).padding(.leading, 12).font(.system(size: 20))

                        }
                    .padding(12)
                    .background(Color("Color-2"))
                    .cornerRadius(20)
                     
                        
                        Spacer(minLength: 200)
                    })
                    .padding(10)
                    
  
                                VStack{
                                    
                                    HStack(alignment: .center, spacing: 50, content: {
                                        Button(action: {
                                            showSecondPage = false
                                            print("註冊介面取消")
                                        }, label: {
                                                        Text("取消")
                                                            .bold()
                                                            .overlay(                        RoundedRectangle(cornerRadius: 10)
                                                                        .stroke(Color.black, lineWidth: 2)
                                                                        .frame(width: 63, height:40)
                                                                )
                                                    
                                        }).padding()
                                        
                                        Button(action: {
                                            
                                            showSecondPage = false
                                                Auth.auth().createUser(withEmail: user, password: pass) { result, error in

                                                    guard let user = result?.user,
                                                    error == nil else {
                                                    print(error?.localizedDescription)
                                                            return
                                                                        }
                                                    print("成功帳號")
                                                    print(user.email, user.uid)
                                                                        }
                                                
                                        }, label: {
                                                        Text("註冊")
                                                            .bold()
                                                            .overlay(                        RoundedRectangle(cornerRadius: 10)
                                                                        .stroke(Color.black, lineWidth: 2)
                                                                        .frame(width: 63, height:40)
                            )
                                                    
                                        }).padding()

                                                   
                                    })
                           
                                    }
                          
                })            }
           
         
        }
        
    }
    
}

struct GateView_Previews: PreviewProvider {
    static var previews: some View {
        GateView()
            .previewLayout(.fixed(width: 844, height: 390))
    }
}
