//
//  DetailScene.swift
//  Crypto
//
//  Created by hosam on 05/07/2026.
//

import SwiftUI

struct DetailScene: View {
    @Binding var coin:CoinModel
    @StateObject var vm:DetailViewModel
    let columns:[GridItem] = [
        .init(.flexible()),
        .init(.flexible())
    ]
    
    init(coin: Binding<CoinModel>) {
        self._coin = coin
        _vm=StateObject(wrappedValue: DetailViewModel(coin: coin.wrappedValue))
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing:20){
                Text("")
                    .frame(height:150)
                
                overviewTitle
                Divider()
                overviewGrid
                
                
                additionalTitle
                Divider()
                
                additionalGrid
            }
            .padding()
        }
    }
}

struct CoinRowssViewPreview:PreviewProvider {
    static var previews: some View{
        DetailScene(coin: .constant(dev.coin))
    }
    
}

extension DetailScene{
    private var additionalTitle:some View{
        
        Text("Additional Details:")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    private var overviewTitle:some View{
        
        Text("Pverview Details:")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    private var overviewGrid:some View{
        LazyVGrid(columns: columns,alignment: .leading,spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.overviewStatistic){stat in
                StatisticsView(stat:stat)
            }
        }
    }
    
    private var additionalGrid:some View{
        LazyVGrid(columns: columns,alignment: .leading,spacing: 30,
                  pinnedViews: []) {
            ForEach(vm.additionalStatistic){stat in
                StatisticsView(stat:stat)
            }
        }
    }
}
