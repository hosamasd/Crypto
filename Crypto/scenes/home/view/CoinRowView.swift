//
//  CoinRowView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct CoinRowView: View {
    let coin:CoinModel
    let showHoldingColumn:Bool
    
    var body: some View {
        HStack(spacing:0){
            leftView
            
            Spacer()
            if showHoldingColumn{
                centerView
                
            }
            
            rightView
            
            
        }
        .frame(height: 70)

    }
}

struct CoinRowViewPreview:PreviewProvider {
    static var previews: some View{
        CoinRowView(coin:dev.coin, showHoldingColumn: true )
    }
    
    
}

extension CoinRowView{
    private var leftView: some View{
        HStack(spacing:0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageScene(coin: coin)
                .frame(width: 35,height: 35)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    private var centerView: some View{
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
            
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightView: some View{
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            if let price=coin.priceChangePercentage24H{
                Text(price.asPercentString())
                    .foregroundStyle(coin.priceChangePercentage24H! >= 0 ? Color.theme.green : Color.theme.red )
            }
        }
        .frame(width: getFrameSize().width/3.5,alignment: .trailing)
    }
}
