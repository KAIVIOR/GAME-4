//
//  GotoroomView.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/12.
//

import SwiftUI
import SwiftUIPullToRefresh

struct GotoroomView: View {
    @State var currentUserData: UserData
    @Binding var showsearch: Bool
    @State private var roomNum = ""
    @State private var intoWaitingView: Int? = 0
    @State private var roomAlert = false
    @State private var alertMsg = ""
    @State private var search = ""
    @StateObject var roomList = MyRoomList()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var test = ""
    var mRN: String
    var body: some View {
        NavigationView {
        ZStack {
            VStack {
                Spacer()
                SearchBar(text: $search)
                    .frame(width: 408)
                List(roomList.roomList.filter({ search.isEmpty ? true : $0.id!.contains(search) })) { item in
                    Button(action:{
                        findRoom(rn: item.id!)
                    }){
                        
                        HStack(alignment: .center, spacing: nil, content: {
                            
                            
                            Text("房號:" + item.id! + " ")
                            Text("主持人:" + item.user0.username)
                        Spacer()
                            if item.user1.username == "" {
                                Image(systemName: "person")
                                Text("1/2")
                                                       }
                        })
//                        HStack{

//                            if item.user1.userName == "" {
//                                Image(systemName: "person")
//                                Text("1/2")
//                            } else {
//                                Image(systemName: "person.fill")
//                                Text("2/2")
//                            }
//                            Text("進入 >")
//                        }.foregroundColor(Color.primary)
                    }
                }.listStyle(InsetGroupedListStyle())
             }
            .onAppear{
                roomList.updateRoomList()
            }
            .alert(isPresented: $roomAlert, content: {
                Alert(title: Text("錯誤"), message: Text(alertMsg), dismissButton: .cancel())
            })
            .foregroundColor(.black)
            .background(Image("bg2").blur(radius: 10).contrast(0.69))
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("搜尋遊戲房間")
            .navigationBarItems(leading: Button(action:{self.presentationMode.wrappedValue.dismiss()}){
                HStack {
                    Image(systemName: "chevron.left")
                    Text("返回")
                }.foregroundColor(.black)
            })
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    func findRoom(rn: String) {
        roomNum = rn
        var findRoom = false
        var fullRoom = false
        FireBase.shared.fetchRooms { result in
            switch result {
            case .success(let rArray):
                for r in rArray {
                    if r.id! == rn {
                        findRoom = true
                        if r.user1.username != "" && r.user0.username != "" {
                            fullRoom = true
                        }
                        break
                    }
                }
                if findRoom == false {
                    alertMsg = "找不到該房間，請重新確認房號"
                    roomAlert = true
                } else {
                    if fullRoom {
                        alertMsg = "房間已滿人，請稍後再試"
                        roomAlert = true
                    } else {
                        intoWaitingView = 1
                    }
                }
            case .failure(_):
                print("進入失敗請重新嘗試")
                
            }
        }
    }
}

struct GotoroomView_Previews: PreviewProvider {
    static var previews: some View {
        GotoroomView(currentUserData: UserData(id: "", username: "", userGender: "", age: 0, userBD: "", userFirstLogin: "", userPhotoURL: ""), showsearch: .constant(true), mRN: "1320")
            .previewLayout(.fixed(width: 844, height: 390))
        
    }
}
struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    var body: some View {
        HStack {
            TextField("輸入房號...", text: $text)
                .foregroundColor(.black)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .padding(10)
                .padding(.vertical, 2)
                .padding(.horizontal, 25)
                .background(Color(red: 1, green: 247/255, blue: 235/255, opacity: 0.5))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .keyboardType(.numberPad)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 15)
                            
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.black)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                )
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("取消")
                }.foregroundColor(.black)
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
