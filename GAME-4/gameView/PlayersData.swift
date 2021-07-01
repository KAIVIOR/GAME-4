import SwiftUI
class PlayerData: ObservableObject{
    @AppStorage("players") var playersData: Data?
    
    init(){
        if let playersData = playersData{
            let decoder = JSONDecoder()
            do{
                players = try decoder.decode([Player].self, from: playersData)
            } catch{
                print(error)
            }
        }
    }
    
    
    @Published var players = [Player](){
        didSet{
            let encoder = JSONEncoder()
            do{
                let data = try encoder.encode(players)
                playersData = data
            } catch{
                print(error)
            }
        }
    }
    
    
}
