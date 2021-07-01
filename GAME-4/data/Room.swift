


import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
//
//func set_bomb_position(user:String,state:String,x:CGFloat,y:CGFloat) {
//            let db = Firestore.firestore()
//
//    let location = bomb_Location(name:user ,state: state,x:Int(x),y:Int(y))
//
//            do {
//                try db.collection("bomb_data").document("\(location.state)").setData(from: location)
//            } catch {
//                print(error)
//            }
//}
func start(room:String) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("waitingRoom").document("\(room)")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var room = try? document.data(as: RoomState.self)
          else {
                    return
          }
            room.start = true
          do {
             try documentReference.setData(from: room)
          } catch {
             print(error)
          }
                        
        }
}

func no_start(room:String) {
    let db = Firestore.firestore()
    let documentReference =
        db.collection("waitingRoom").document("\(room)")
    documentReference.getDocument { document, error in
                    
      guard let document = document,
            document.exists,
            var room = try? document.data(as: RoomState.self)
      else {
                return
      }
        room.start = false
      do {
         try documentReference.setData(from: room)
      } catch {
         print(error)
      }
                    
    }
}
func create_someones_bomb(user:String,number:Int,state:String,x:CGFloat,y:CGFloat) {
        let db = Firestore.firestore()
        
    let bomb = bomb_Location( state:state, x: Int(x), y: Int(y))
        do {
            
            try db.collection("\(user)").document("\(number)").setData(from: bomb)
            //時間、數字（may...,0）
        } catch {
            print(error)
        }
}
//製造炸彈
func create_bomb(name:String,number:Int,state:String,x:CGFloat,y:CGFloat) {
        let db = Firestore.firestore()
        
        let bomb = bomb_Location(state: state, x: Int(x), y: Int(y))
        do {
            try db.collection("\(name)").document("\(number)").setData(from: bomb)
        } catch {
            print(error)
        }
}
//改變炸彈狀態
func change_bomb_state(name:String,number:Int,state:String,x:CGFloat,y:CGFloat) {
        let db = Firestore.firestore()
        
        let bomb = bomb_Location(state: state, x: Int(x), y: Int(y))
        do {
            try db.collection("\(name)").document("\(number)").setData(from: bomb)
        } catch {
            print(error)
        }
}
func createCharacterPositon(name:String,direction:String,x:CGFloat,y:CGFloat) {
            let db = Firestore.firestore()
            
    let location = Location(name: name,direction:direction ,x:Int(x),y:Int(y))
        
            do {
                try db.collection("location").document("\(location.name)").setData(from: location)
            } catch {
                print(error)
            }
}
func createRoom(room_number:String, start:Bool,player1:String, player2:String,URL_player1 :String,URL_player2 :String,quantity: Int,preparedQuantity:Int) {
            let db = Firestore.firestore()
   
    let creatingRoom = RoomState( room_number:"\(room_number)", start: false, player1: player1, player2: player2, quantity: quantity, preparequantity: preparedQuantity, URL_player1: URL_player1, URL_player2: URL_player2)
            do {
                try db.collection("waitingRoom").document("\(room_number)").setData(from: creatingRoom)
            } catch {
                print(error)
            }
}
func addprepare(room:String) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("waitingRoom").document("\(room)")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var room = try? document.data(as: RoomState.self)
          else {
                    return
          }
            room.preparequantity+=1
          do {
             try documentReference.setData(from: room)
          } catch {
             print(error)
          }
                        
        }
}

func minusprepare(room:String) {
    let db = Firestore.firestore()
    let documentReference =
        db.collection("waitingRoom").document("\(room)")
    documentReference.getDocument { document, error in
                    
      guard let document = document,
            document.exists,
            var room = try? document.data(as: RoomState.self)
      else {
                return
      }
        room.preparequantity-=1
      do {
         try documentReference.setData(from: room)
      } catch {
         print(error)
      }
                    
    }
}
func ModifyChararcterName(roomName:String,name:String,URLSting:String) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("waitingRoom").document("\(roomName)")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var modifyChararcter = try? document.data(as: RoomState.self)
          else {
                    return
          }
            //存url
            if modifyChararcter.player2==""{
                
                modifyChararcter.URL_player2 = "\(URLSting)"
            }
            //存名字
            if modifyChararcter.player2==""{
                
                modifyChararcter.player2 = "\(name)"
            }
            modifyChararcter.quantity += 1
            
            
          do {
             try documentReference.setData(from: modifyChararcter)
          } catch {
             print(error)
          }
                        
        }
}


class MyRoomList: ObservableObject {
    @Published var roomList: [RoomData]
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    init() {
        roomList = [RoomData(id: "", user0: UserData(id: "",username: "" ,userGender: "", age: 0, userBD: "", userFirstLogin: "",userPhotoURL: ""), user0ready: false, user1: UserData(id: "", username: "", userGender: "", age: 0, userBD: "", userFirstLogin: "", userPhotoURL: ""), user1ready: false, startPlayer: 0)]
    }
    
    func updateRoomList() -> Void {
        FireBase.shared.fetchRooms { result in
            switch result {
            case .success(let rArray):
                self.roomList = rArray
            case .failure(_):
                print("Update Room List Failed.")
            }
        }
    }
    
}

struct RoomData: Codable, Identifiable {
    @DocumentID var id: String?
    let user0: UserData
    var user0ready: Bool
    let user1: UserData
    var user1ready: Bool
    var startPlayer: Int
}
