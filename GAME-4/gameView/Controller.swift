//
//  Controller.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/8.
//

//
//  Controller.swift
//  FinalProject
//
//  Created by 吳庭愷 on 2021/6/5.
//

import SwiftUI
import Firebase
struct Controller: View {
    @Binding var offset :CGSize
    @Binding var direction : String
    @Binding var footstep:CGFloat
    //抓操作者名字
    @Binding var PlayerName: String
    func setLocation(location: Location) {//更新狀態 沒用到
        let db = Firestore.firestore()
            
        do {
            try db.collection("location").document(location.name).setData(from: location)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        ZStack (alignment: .center) {
            Rectangle().fill(Color.clear)
            HStack (alignment: .center){
                VStack(alignment: .center, spacing: 3, content: {
                    //udown
                    Button(action:  {
                        offset.height -= footstep
                        direction = "down"
                        setLocation(location: Location(name: "\(PlayerName)", direction: direction, x: Int(offset.width), y: Int(offset.height)))
                        
                        print("(\(offset.width),\(offset.height))")
                    }, label: {
                        Text("⌂")
                            .font(.system(.largeTitle))
                            .foregroundColor(Color.white)
                            .frame(width: 35, height: 30)
                            .padding(.bottom,4)
                            
                            
                            

                    })
                    
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    HStack(alignment: .center, spacing: 30, content: {
                        //左
                        Button(action:  {
                            offset.width -= footstep
                            direction = "left"
                            setLocation(location: Location(name: "\(PlayerName)", direction: direction, x: Int(offset.width), y: Int(offset.height)))
                            print("(\(offset.width),\(offset.height))")
                        }, label: {
                            Text("⌂")
                                .font(.system(.largeTitle))
                                .foregroundColor(Color.white)
                                .frame(width: 35, height: 30)
                                .padding(.bottom,4)
                           
                                

                        })
                        .rotationEffect(.degrees(270))
                            .background(Color.black)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3),
                                    radius: 3,
                                    x: 3,
                                    y: 3)
                        Button(action:  {
                            offset.width += footstep
                            direction = "right"
                            setLocation(location: Location(name: "\(PlayerName)", direction: direction, x: Int(offset.width), y: Int(offset.height)))
                            print("(\(offset.width),\(offset.height))")
                        }, label: {
                            Text("⌂")
                                .font(.system(.largeTitle))
                                .foregroundColor(Color.white)
                                .frame(width: 35, height: 30)
                                .padding(.bottom,4)
                                
                                

                        })
                        .rotationEffect(.degrees(90))
                        
                            .background(Color.black)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3),
                                    radius: 3,
                                    x: 3,
                                    y: 3)
                    })
                    //up
                    Button(action:  {
                        offset.height += footstep
                        direction = "up"
                        setLocation(location: Location(name: "\(PlayerName)", direction: direction, x: Int(offset.width), y: Int(offset.height)))
                        print("(\(offset.width),\(offset.height))")
                    }, label: {
                        Text("⌂")
                            .font(.system(.largeTitle))
                            .foregroundColor(Color.white)
                            .frame(width: 35, height: 30)
                            .padding(.bottom,4)
                            .rotationEffect(.degrees(180))


                    })
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)

                })

            }
        }

        
    }
   
}
//struct Controller_Previews: PreviewProvider {
//    static var previews: some View {
//        Controller(offset: .constant(CGSize.zero), direction: .constant(""), footstep: .constant(0), PlayerName: .constant(""))
//    }
//}


struct fireView: View {
//    @Binding var position_x:CGFloat
//    @Binding var position_y:CGFloat
    var body: some View {
        
        ZStack{
            Text("d")
        }
        
    }
}
struct fireView_Previews: PreviewProvider {
    static var previews: some View {
        fireView()
    }
}

