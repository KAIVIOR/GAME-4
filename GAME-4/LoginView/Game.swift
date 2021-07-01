//
//  Game.swift
//  
//
//  Created by 吳庭愷 on 2021/6/13.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class MyGame: ObservableObject {
    @Published var myGameData: GameData
    private var listener: ListenerRegistration?
    let db = Firestore.firestore()
    let changePlayer = NotificationCenter.default.publisher(for: Notification.Name("changePlayer"))
    let skipP0 = NotificationCenter.default.publisher(for: Notification.Name("skipP0"))
    let skipP1 = NotificationCenter.default.publisher(for: Notification.Name("skipP1"))
    let gameOver = NotificationCenter.default.publisher(for: Notification.Name("gameOver"))
    init() {
        self.myGameData = GameData(roomData: RoomData(id: "", user0: UserData(id: "", username: "", userGender: "", age: 0, userBD: "", userFirstLogin: "", userPhotoURL: ""), user0ready: false, user1: UserData(id: "", username: "", userGender: "", age: 0, userBD: "", userFirstLogin: "", userPhotoURL: ""), user1ready: false, startPlayer: 0), nowPlayer: 0, user0Skipped: false, user1Skipped: false)
    }
    
    func copyGame(newGame: GameData) -> Void {
        self.myGameData = newGame
    }
    func addGameListener() -> Void {
        self.listener = self.db.collection("gaming_room").document(self.myGameData.roomData.id ?? "").addSnapshotListener{
            snapshot, error in
            guard let snapshot = snapshot else { return }
            guard let game = try? snapshot.data(as: GameData.self) else { return }
            self.copyGame(newGame: game)
            print("Game data update!")
            if(self.myGameData.nowPlayer != game.nowPlayer) {
                NotificationCenter.default.post(name: Notification.Name("changePlayer"), object: nil)
            }
            
            //SKIP & GAME OVER RULE
          
            
        }
            
    }
    
}

struct GameData: Codable, Identifiable {
    @DocumentID var id: String?
    var roomData: RoomData
    var nowPlayer: Int
    var user0Skipped: Bool
    var user1Skipped: Bool
    var checkerboard = ["0": [-1, -1, -1, -1, -1, -1, -1, -1],
                        "1": [-1, -1, -1, -1, -1, -1, -1, -1],
                        "2": [-1, -1, -1,  0, -1, -1, -1, -1],
                        "3": [-1, -1,  0,  2,  1, -1, -1, -1],
                        "4": [-1, -1, -1,  1,  2,  0, -1, -1],
                        "5": [-1, -1, -1, -1,  0, -1, -1, -1],
                        "6": [-1, -1, -1, -1, -1, -1, -1, -1],
                        "7": [-1, -1, -1, -1, -1, -1, -1, -1]]
    //-1代表不能下 0代表當前player可下位置 1代表Player1的棋子 2代表Player2的棋子
}
