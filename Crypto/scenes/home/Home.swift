//
//  ContentView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct Home: View {
    @State private var showPorifilo=false
    @StateObject var vm=HomeViewModel()
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            
                .sheet(isPresented: $showPorifilo,content: {
                    PortfolioView(vm:vm)
                })
            
            VStack{
                headerView
                HomeStatView(vm: vm, showPortforlio: $showPorifilo)
                
                CustomSearchBarView(searchTxt: $vm.searchTxt)
                
                columnTitlesView
                
                if !showPorifilo{
                    allCoinView
                        .transition(.move(edge: .leading))
                }else{
                    portfolioCoinView
                        .transition(.move(edge: .trailing))
                    
                }
                Spacer()
            }
            
        }
    }
}

#Preview {
    NavigationStack{
        Home()
            .toolbar(.hidden)
    }
}

extension Home{
    private var headerView:some View{
        HStack{
            CircleBTN(iconName:showPorifilo ? "plus":"info")
                .background {
                    CircleBTNAnimationView(animate: $showPorifilo)
                }
            
            Spacer()
            Text(showPorifilo ? "Portfolio":"BitCoin")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
            
            Spacer()
            CircleBTN(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPorifilo ? 180:0))
                .onTapGesture {
                    withAnimation(.spring) {
                        self.showPorifilo.toggle()
                    }
                }
        }
    }
    
    private var allCoinView:some View{
        List{
            ForEach(vm.allCoins){coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10))
            }
            
        }
        .listStyle(PlainListStyle())
    }
    private var portfolioCoinView:some View{
        List{
            ForEach(vm.portfolioCoins){coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 10))
            }
            
        }
        .listStyle(PlainListStyle())
    }
    private var columnTitlesView:some View{
        
        HStack{
            Text("Coin")
            Spacer()
            if showPorifilo{
                Text("Hoildays")
            }
            Text("Price")
                .frame(width: getFrameSize().width/3,alignment: .trailing)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
