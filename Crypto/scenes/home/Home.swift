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
    @State private var editPorifilo=false
    @State var isShowDetail=false
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            
                .sheet(isPresented: $editPorifilo,content: {
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
        .background(EmptyView()
            .fullScreenCover(isPresented: $isShowDetail, content: {
                DetailScene(coin: $vm.selectedCoin)
            }))
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
                .onTapGesture {
                    withAnimation(.spring) {
                        self.editPorifilo.toggle()
                    }
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
                    .onTapGesture {
                        withAnimation(.default){
                            vm.selectedCoin=coin
                            isShowDetail=true
                        }
                    }
                
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
            HStack{
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPorifilo{
                HStack{
                    Text("Hoildays")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack{
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
                
            }
            .frame(width: getFrameSize().width/3,alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
