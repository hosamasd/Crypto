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
    @State var showFullDesc:Bool=false

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
            
            VStack{
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing:20){
                   
                    overviewTitle
                    Divider()
                    
                   descSection
                    
                    overviewGrid
                    
                    
                    additionalTitle
                    Divider()
                    
                    additionalGrid
                    
                   websiteSection
                }
                .padding()
            }
        }
        .toolbar {
            
            ToolbarItem(placement: .topBarTrailing) {
                trailingNavBarBTN
            }
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
    private var trailingNavBarBTN:some View{
        HStack{
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinRowView(coin: vm.coin, showHoldingColumn: false)
                .frame(width: 25,height: 25)
        }
    }
    
    private var descSection:some View{
        ZStack{
            if let coinDesc=vm.coinDesc,!coinDesc.isEmpty{
                VStack{
                    Text(coinDesc)
                        .lineLimit(showFullDesc ? .none : 3)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut){
                            showFullDesc.toggle()
                        }
                    } label: {
                        Text(showFullDesc ? "Less More" : "Read More")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                        
                    }
                    .accentColor(.blue)
                    
                }
//                .frame(minWidth: .infinity,  alignment: .leading)
            }
        }
    }
    
    private var websiteSection:some View{
        VStack(alignment: .leading,spacing: 20) {
            if let websiteUrl=vm.websiteUrl,!websiteUrl.isEmpty,let url = URL(string: websiteUrl){
                
                Link("Website", destination: url)
                
            }
            
            if let redditString=vm.redditUrl,!redditString.isEmpty,let url = URL(string: redditString){
                Link("Reddit", destination: url)
                
            }
            
        }
        .accentColor(.blue)
        .frame(maxWidth:.infinity,alignment: .leading)
        .font(.headline)
    }
}
