//
//  CircleBTN.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct CircleBTN: View {
    let iconName:String
    
    var body: some View {
        Image(systemName:iconName )
            .font(.headline)
            .foregroundStyle(.accent)
            .frame(width: 50,height: 50)
            .background {
                Circle()
                    .foregroundStyle(Color.theme.background)
            }
            .shadow(color:Color.theme.accent.opacity(0.25),radius: 10,x: 0,y: 0)
            .padding()
    }
}

#Preview {
    Group {
        CircleBTN(iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
        
        CircleBTN(iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
}
