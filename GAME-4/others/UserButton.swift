//
//  UserButton.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/14.
//

import SwiftUI
import Kingfisher
import FirebaseAuth
struct UserButton: View {
    @StateObject var myUserData = MyUserData()
    @State private var userPhotoURL = URL(string: "")
    @State private var showContentView = false
    @State private var currentUserData = UserData(id: "",username: "", userGender: "", age: 16, userBD: "", userFirstLogin: "",userPhotoURL: "")
    var buttonText = "My Burron"
    var buttonColor = Color("Color-6")
    @State var userviewpage = false
    var body: some View {
        ZStack{
          
            if myUserData.currentUser?.photoURL != nil {
                Button(action: {
                    userviewpage = true
                }, label: {
                    KFImage(myUserData.currentUser?.photoURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(70)
                })
                .fullScreenCover(isPresented: $userviewpage, content: {
                    
                })
            }
            else{
                Button(action: {
                    userviewpage = true
                }, label: {
                    Image("me")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120, alignment: .center)
                })
                .fullScreenCover(isPresented: $userviewpage, content: {
                    
                })
            }
        }
    }
}

struct UserButton_Previews: PreviewProvider {
    static var previews: some View {
        UserButton()
    }
}
