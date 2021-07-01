//
//  class.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/8.
//


//
//  class.swift
//  FinalProject
//
//  Created by 吳庭愷 on 2021/5/26.
//
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
struct Player: Identifiable, Codable {
    var id = UUID()
    var name: String
    var coins_get: Int
    
    
}


struct Location: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    var direction: String
    var x: Int
    var y: Int
    
}
struct bomb_Location: Codable, Identifiable {
    @DocumentID var id: String?
    var state: String
    var x: Int
    var y: Int
    
}
struct Room_data: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    var coins1_x: Int
    var coins1_y: Int
    var coins2_x: Int
    var coins2_y: Int
    var coins3_x: Int
    var coins3_y: Int
    var coins4_x: Int
    var coins4_y: Int
    var coins5_x: Int
    var coins5_y: Int
}
class GameObject: ObservableObject{
    @Published var x = 0
    @Published var y  = 0
    @Published var userdata = UserData( username: "", userGender: "", age: 15, userBD: "", userFirstLogin: "", userPhotoURL: "")
    
}

//struct Player: Identifiable, Codable {
//    var id = UUID()
//    var  x = 0
//    var  y = 0
//}
class PageObject: ObservableObject{
   
    //@Published var turn: Int = 0
    @Published var setting = false
    @Published var register_page = false
    @Published var dull_page = false

}

struct RoomState: Codable, Identifiable {
    @DocumentID var id: String?
    var room_number: String
    var start: Bool
    var player1:String
    var player2:String
    var quantity:Int
    var preparequantity: Int
    var URL_player1 :String
    var URL_player2:String
 
    
}
