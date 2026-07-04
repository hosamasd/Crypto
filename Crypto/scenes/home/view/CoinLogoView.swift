//
//  CoinLogoView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct CoinLogoView: View {
    let coion:CoinModel
    
    var body: some View {
        VStack{
            CoinImageScene(coin: coion)
                .frame(width: 50,height: 50)
            
            Text(coion.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coion.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .multilineTextAlignment(.center)
        }
    }
}
