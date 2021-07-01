//
//  cloudData.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/8.
//
//

import Foundation
import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift
import FirebaseFirestoreSwift
import FirebaseFirestore
class MyUserData: ObservableObject {
    @Published var currentUser: User?
    @Published var currentUserData: UserData
    init() {
        self.currentUser = Auth.auth().currentUser
        self.currentUserData = UserData(id: "", username: "", userGender: "", age: 0, userBD: "", userFirstLogin: "", userPhotoURL: "")
    }
}
class FireBase{
    static let shared = FireBase()
    //建立帳號
    func createUser(userEmail: String, pw: String, completion: @escaping((Result<String, RegError>) -> Void)) {
        Auth.auth().createUser(withEmail: userEmail, password: pw) { result, error in
             guard let user = result?.user,
                   error == nil else {
                if (error?.localizedDescription == "The email address is badly formatted."){
                    completion(.failure(RegError.emailFormat))
                }
                else if(error?.localizedDescription == "The password must be 6 characters long or more."){
                    completion(.failure(RegError.pwtooShort))
                }
                else if(error?.localizedDescription == "The email address is already in use by another account."){
                    completion(.failure(RegError.emailUsed))
                }
                else {
                    completion(.failure(RegError.others))
                }
                return
             }
            print(user.email, user.uid)
            completion(.success(user.uid))
        }
    }

    //帳密登入
    func userSingIn(userEmail: String, pw: String, completion: @escaping((Result<String, LoginError>) -> Void)) {
        Auth.auth().signIn(withEmail: userEmail, password: pw) { result, error in
             guard error == nil else {
                print(error?.localizedDescription)
                if (error?.localizedDescription == "The password is invalid or the user does not have a password.") {
                    completion(.failure(LoginError.pwInvalid))
                }
                else if (error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted.") {
                    completion(.failure(LoginError.noAccount))
                }
                else {
                    completion(.failure(LoginError.others))
                }
                return
             }
            completion(.success("Success"))
        }
    }
    
    //登出
    func userSingOut() -> Void {
        do {
            try Auth.auth().signOut()
            if Auth.auth().currentUser == nil {
                print("登出成功")
            }
        }
        catch {
            print("登出錯誤")
        }
    }
    
    //上傳相片
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".png")
        if let data = image.pngData() {
            
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success(_):
                    fileReference.downloadURL { result in
                        switch result {
                        case .success(let url):
                            completion(.success(url))
                            print(url)
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    //將檔案設成使用者的個人頭像
    func setUserPhoto(url: URL, completion: @escaping((Result<String, NormalErr>) -> Void)) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        completion(.success("頭像修改成功"))
        changeRequest?.commitChanges(completion: { error in
           guard error == nil else {
               print(error?.localizedDescription)
                completion(.failure(NormalErr.error))
               return
           }
        })
    }
    
    //上傳user基本資料
    func createUserData(ud: UserData, uid: String, completion: @escaping((Result<String, NormalErr>) -> Void)) {
        let db = Firestore.firestore()
        do {
            try db.collection("Users_Data").document(uid).setData(from: ud)
            completion(.success("建立資料成功"))
        } catch {
            completion(.failure(NormalErr.error))
            print(error)
        }
    }
    
    //修改user display name
    func setUserDisplayName(userDisplayName: String) -> Void {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userDisplayName
        changeRequest?.commitChanges(completion: { error in
           guard error == nil else {
                print(error?.localizedDescription)
                print("修改user display name出錯")
                return
           }
        })
    }
    
    //讀取某個collection下全部的 documents
    func fetchUsers (completion: @escaping((Result<[UserData], NormalErr>) -> Void)) {
        let db = Firestore.firestore()
        db.collection("Users_Data").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let users = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: UserData.self)
                
            }
            //print(users)
            completion(.success(users))
            if error?.localizedDescription != nil {
                completion(.failure(NormalErr.error))
            }
        }
    }
    //讀取某個collection下全部的 documents
    func fetchRooms (completion: @escaping((Result<[RoomData], NormalErr>) -> Void)) {
        let db = Firestore.firestore()
        db.collection("game_room").getDocuments { snapshot, error in
            guard let snapshot = snapshot else { return }
            let rooms = snapshot.documents.compactMap { snapshot in
                try? snapshot.data(as: RoomData.self)
                
            }
            //print(users)
            completion(.success(rooms))
            if error?.localizedDescription != nil {
                completion(.failure(NormalErr.error))
            }
        }
    }
    //創建房間
//    func createRoom(ud: [UserData], rid_str: String, completion: @escaping((Result<String, NormalErr>) -> Void)) {
//        let db = Firestore.firestore()
//        do {
//            let rid = [Int.random(in: 0...9), Int.random(in: 0...9), Int.random(in: 0...9), Int.random(in: 0...9)]
//            //創建房間
//            if rid_str == "-1" {
//                //做了隨機房號
//                //房間資料
//                try db.collection("game_room").document(String(rid[0]) + String(rid[1]) + String(rid[2]) + String(rid[3])).setData(from: RoomData(id: "", user0: ud[0], user0ready: false, user1: ud[1], user1ready: false, startPlayer: 0))
//                completion(.success(String(rid[0]) + String(rid[1]) + String(rid[2]) + String(rid[3])))
//            }
//            //加入房間
//            else {
//                let user1: [String: Any] = [
//                    "userBD": ud[0].userBD,
//                    "userFirstLogin": ud[0].userFirstLogin,
//                    "userGender": ud[0].userGender,
//                    "username": ud[0].username,
//                    "userPhotoURL": ud[0].userPhotoURL ]
//                try db.collection("game_room").document(rid_str).setData(["user1": user1], merge: true)
//                completion(.success(rid_str))
//            }
//
//
//        } catch {
//            completion(.failure(NormalErr.error))
//            print(error)
//        }
//    }

    
}
enum RegError: Error {
    case emailFormat
    case pwtooShort
    case emailUsed
    case others
}

enum LoginError: Error {
    case pwInvalid
    case noAccount
    case others
}

enum NormalErr: Error {
    case error
}

struct UserData: Codable, Identifiable {
    @DocumentID var id: String?
    var username: String
    var userGender: String
    var age: Int
    var userBD: String
    var userFirstLogin: String
    var userPhotoURL: String
    
}
struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var RoomInfo: RoomInfo
    var auth_id: String
}


struct RoomInfo: Codable, Identifiable {
    @DocumentID var id: String?
    var roomID:Int
    var createTime:Date
    var peopleInRoom:Int
    var readyCount: Int
    var playersInRoom:[PlayerInRoom]
    var isGameCreated:Bool
    var gameID:String
}
struct PlayerInRoom: Codable{
    var playerID: String //eUomXrQcMwUDuJVEW4ZAUhIED003
    var nanick_name: String
    var Avatar: String
    //var record:Record
    var isHost: Bool
    var isReady:Bool
    
}
