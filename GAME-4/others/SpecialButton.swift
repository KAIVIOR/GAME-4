//
//  SpecialButton.swift
//  GAME-4
//
//  Created by 吳庭愷 on 2021/6/14.
//

import SwiftUI

struct SpecialButton: View {
    var buttonText = "My Burron"
    var buttonColor = Color("Color-6")
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 150, height: 55, alignment: .center)
                .foregroundColor(Color("Color-5"))
            Text(buttonText).bold()
            LeftCorner()
                .trim(from: 0.41, to: 0.59)
                .fill( buttonColor)
                .frame(width: 150, height: 55)
        }
    }
}
struct LeftCorner: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: 5, height: 5))
        return path
    }
    
}
struct SpecialButton_Previews: PreviewProvider {
    static var previews: some View {
        SpecialButton()
    }
}
