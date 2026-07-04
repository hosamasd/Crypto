//
//  PortfolioView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject var vm:HomeViewModel
    @State private var selectedCoin:CoinModel?=nil
    @State private var quantitText=""
    @State private var showCheckMark=false
    
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading,spacing: 0){
                    CustomSearchBarView(searchTxt: $vm.searchTxt)
                    coinLogoList
                    
                    porfolioInputSection
                    
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarBTN
                }
            }
        }
    }
    
    func getCurrentValue() ->Double {
        if let qunatity=Double(quantitText){
            return qunatity*(selectedCoin?.currentPrice ?? 0)
        }
        return 0.0
    }
}

#Preview {
    PortfolioView(vm: HomeViewModel())
}
extension PortfolioView{
    private var coinLogoList: some View{
        ScrollView(.horizontal,showsIndicators: false){
            LazyHStack(spacing:10){
                ForEach(vm.allCoins){coin in
                    CoinLogoView(coion: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedCoin=coin
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id==coin.id ? Color.theme.green : .clear,lineWidth:1)
                        }
                }
            }
            .frame(height:120)
            .padding(.trailing)
        }
    }
    
    private var porfolioInputSection: some View{
        
            VStack(spacing:20){
                HStack{
                    Text("Current Price of \(selectedCoin?.symbol.uppercased()):")
                    Spacer()
                    Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
                }
                
                Divider()
                HStack{
                    Text("Amount in your portfolio:")
                    Spacer()
                    TextField("EX: 1.4", text: $quantitText)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                Divider()
                HStack{
                    Text("Current Value:")
                    Spacer()
                    Text(getCurrentValue().asCurrencyWith2Decimals())
                }
                
            }
            .animation(.none)
            .padding()
            .font(.headline)
        
    }
    
    private var trailingNavBarBTN: some View{
        
        HStack(spacing:10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button {
                saveBTNPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantitText)) ? 1.0 : 0.0)
            
        }
        .font(.headline)
    }
    
    func saveBTNPressed()  {
        guard let coin = selectedCoin else { return  }
        
        
        withAnimation(.easeIn) {
            showCheckMark=true
            removeSelectedCoin()
        }
        hideKeyboard()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.0, execute: {
            withAnimation(.easeOut) {
                showCheckMark=false
            }
        })
    }
    
    func removeSelectedCoin()  {
        selectedCoin=nil
        vm.searchTxt = ""
    }
}
