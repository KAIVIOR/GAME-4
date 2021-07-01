//
//  settingfaceView.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/12.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct monView: View {
    var type: String
    var number: Int
    var body: some View{
        Image("\(type)_\(number)")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120,alignment: .center)
            .offset(x: 0, y: 0)
            .frame(width: 116.8, height: 86.4)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}
struct eyeView: View {
    var type: String
    var number: Int
    var body: some View{
        Image("\(type)_\(number)")
            .resizable()
            .scaledToFit()
            .frame(width: 180, height: 180,alignment: .center)
            .offset(x: 10, y: 0)
            .frame(width: 116.8, height: 86.4)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}
struct clothView: View {
    var type: String
    var number: Int
    var body: some View{
        Image("\(type)_\(number)")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150,alignment: .center)
            .offset(x: -5, y: -40)
            .frame(width: 116.8, height: 86.4)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}
struct mouthView: View {
    var type: String
    var number: Int
    var body: some View{
        Image("\(type)_\(number)")
            .resizable()
            .scaledToFit()
            .frame(width: 250, height: 250,alignment: .center)
            .offset(x: 0, y: -30)
            .frame(width: 116.8, height: 86.4)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

struct settingfaceView: View {
    @Binding var showface: Bool
    @State private var myAlert = Alert(title: Text(""))
    @State private var alertMsg = ""
    @State private var showAlert = false
    @State var skin = 1
    @State var hair = 1
    @State var eye = 1
    @State var mouth = 1
    @State var nose = 1
    @State var cloth = 1
    @State var screen = 1
    @State private var select = 5
    @State private var userPhotoURL = URL(string: "")
    @Binding var ulr: String
    @Binding var newUser1 : UserData
    @StateObject var myUserData = MyUserData()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var settingdullView: some View {
        ZStack{
            Image("screen_\(screen)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                
            Image("skin_\(skin)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
            Image("hair_\(hair)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
            
            Image("eye_\(eye)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                
            Image("mouth_\(mouth)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                
            Image("nose_\(nose)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                
            Image("cloth_\(cloth)")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
            
        }
    }
    var body: some View {
        ZStack(content: {
           
            Color("Color").edgesIgnoringSafeArea(.all)
            settingdullView
            Button(action: {
                showface = false
                uploadDollPhoto()
            }, label: {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.black), lineWidth: 2)
                    .background(
                        Color(.black)
                    )
                    .cornerRadius(10)
                .frame(width: 93, height:35)
                    .overlay(
                        Text("完成頭像")
                            .bold()
                            .foregroundColor(.white)
                   )
            }).offset(x: 0, y: 167)
           
            HStack(alignment: .center, spacing: 310, content: {
                VStack(alignment: .center, spacing: 20, content: {
                    Button(action: {
                        select = 0
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("頭髮")
                                    .bold()
                                    .foregroundColor(.white)
                           )

                    })
                    Button(action: {
                        select = 1
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("皮膚")
                                    .bold()
                                    .foregroundColor(.white)
                           )

                        
                    }).offset(x: -30, y: 0)
                    Button(action: {
                        select = 2
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("眼睛")
                                    .bold()
                                    .foregroundColor(.white)
                           )

                    }).offset(x: -60, y: 0)
                    Button(action: {
                        select = 3
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("鼻子")
                                    .bold()
                                    .foregroundColor(.white)
                           )

                    }).offset(x: -90, y: 0)
                    Button(action: {
                        select = 4
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("衣裝")
                                    .bold()
                                    .foregroundColor(.white)
                           )

                    }).offset(x: -60, y: 0)
                    Button(action: {
                        select = 5
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("嘴巴")
                                    .bold()
                                    .foregroundColor(.white)
                           )

                    }).offset(x: -30, y: 0)
                    Button(action: {
                        select = 6
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color-4"), lineWidth: 2)
                            .background(
                                Color("Color-4")
                            )
                            .cornerRadius(10)
                        .frame(width: 93, height:35)
                            .overlay(
                                Text("背景")
                                    .bold()
                                    .foregroundColor(.white)
                           )

                    })

                })
                VStack(alignment: .center, spacing: nil, content: {
                    ScrollView(showsIndicators: false){
                        switch select{
                        case 0:
                            ForEach(0..<8){i in
                                Button(action: {
                                    hair = i
                                }, label: {
                                    monView(type: "hair", number: i)
                                })
                            }//k
                        case 1:
                            ForEach(0..<8){i in
                                Button(action: {
                                    skin = i
                                }, label: {
                                    monView(type: "skin", number: i)
                                })
                            }//k

                        case 2:
                            ForEach(0..<3){i in
                                Button(action: {
                                    eye = i
                                }, label: {
                                    eyeView(type: "eye", number: i)
                                })
                            }

                        case 3:
                            ForEach(0..<2){i in
                                Button(action: {
                                    nose = i
                                }, label: {
                                    monView(type: "nose", number: i)
                                })
                            }

                        case 4:
                            ForEach(0..<6){i in
                                Button(action: {
                                    cloth = i
                                }, label: {
                                    clothView(type: "cloth", number: i)
                                })
                            }
                        case 5:
                            ForEach(0..<6){i in
                                Button(action: {
                                    mouth = i
                                }, label: {
                                    mouthView(type: "mouth", number: i)
                                })
                            }
                        default:
                            ForEach(0..<4){i in
                                Button(action: {
                                    screen = i
                                }, label: {
                                    monView(type: "screen", number: i)
                                })
                            }
                        }
                   
                    }
                }).offset(x: 60, y: 0)
               
                
 
            })
        })
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
    func uploadDollPhoto() -> Void {
        let image = settingdullView.snapshot()
        FireBase.shared.uploadPhoto(image: image) { result in
            switch result {
            case .success(let url):
                print("上傳照片成功")
                FireBase.shared.setUserPhoto(url: url) { result in
                    switch result {
                    case .success(let msg):
                        let newUser = newUser1
                        FireBase.shared.createUserData(ud: newUser, uid: myUserData.currentUser!.uid) {
                            (result) in
                            switch result {
                            case .success(let sucmsg):
                                print(sucmsg)
                                print("myUserData設定")
                            case .failure(_):
                                print("上傳錯誤")
                                showAlertMsg(msg: "發生不明錯誤，請重新嘗試")
                            }
                        }
                        print(msg)
                        print("我已經成功上傳")
                        ulr = url.absoluteString
                        
                    case .failure(_):
                        print("設置頭像錯誤")
                    }
                }
            case .failure(let error):
               print(error)
                }
            }
        }
}
struct settingfaceView_Previews: PreviewProvider {
    static var previews: some View {
        settingfaceView(showface: .constant(true), ulr: .constant(""), newUser1:.constant(UserData(id: "dd", username: "KAIVIOR", userGender: "dd", age: 16, userBD: "dd", userFirstLogin: "dd", userPhotoURL: "")))
            .previewLayout(.fixed(width: 844, height: 390))
    }
}
