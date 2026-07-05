//
//  PortfolioView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI
struct PortfolioView: View {
    @ObservedObject var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantitText = ""
    @State private var showCheckMark = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    CustomSearchBarView(searchTxt: $vm.searchTxt)
                    coinLogoList
                    
                    if selectedCoin != nil{
                        porfolioInputSection
                    }
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
        .onChange(of: vm.searchTxt) { _ in
            if vm.searchTxt == "" {
                removeSelectedCoin()
            }
        }
    }
    
    func getCurrentValue() -> Double {
        if let quantity = Double(quantitText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0.0
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchTxt.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coion: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut) {   // ✅ FIXED
                                updateSelectedCoin(coin:coin)
                                
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : .clear, lineWidth: 1)
                        }
                }
            }
            .frame(height: 120)
            .padding(.trailing)
        }
    }
    
    func updateSelectedCoin(coin:CoinModel)  {
        
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first { $0.id==coin.id },let amount=portfolioCoin.currentHoldings{
            quantitText="\(amount)"
        }else{
            quantitText=""
        }
        
        
    }
    
    private var porfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            HStack {
                Text("Amount in your portfolio:")
                Spacer()
                TextField("EX: 1.4", text: $quantitText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarBTN: some View {
        HStack(spacing: 10) {
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
    
    func saveBTNPressed() {
        guard let coin = selectedCoin,let amount=Double(quantitText) else { return }
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {               // ✅ FIXED
            showCheckMark = true
            removeSelectedCoin()
        }
        hideKeyboard()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {          // ✅ FIXED
                showCheckMark = false
            }
        }
    }
    
    func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchTxt = ""
    }
}
