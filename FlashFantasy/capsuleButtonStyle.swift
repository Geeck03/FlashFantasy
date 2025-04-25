//
//  capsuleButtonModifier.swift
//  FlashFantasy
//
//  Created by Sewell, Aramaea on 4/25/25.
//

import SwiftUI

struct CapsuleButtonStyle: ViewModifier {
    var backGroundColor: Color = .black
    var horizontalPadding: CGFloat = 24
    var verticalPadding: CGFloat = 12
    
    
    
    func body(content: Content) -> some View {
        content
        //.font(.custom("Paypyrus", size: 25))
            .padding(.horizontal,horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(
                Capsule().fill(backGroundColor)
            )
            .foregroundColor(.white)
    }
}

extension View {
    func capsuleButtonStyle(color: Color = .black, hPadding: CGFloat = 24, vPadding: CGFloat = 12) -> some View {
        self.modifier(CapsuleButtonStyle(backGroundColor: color, horizontalPadding: hPadding, verticalPadding: vPadding))
    }
    
    
}
            
