//
//  CustomSearchBarView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct CustomSearchBarView: View {
    @Binding var searchTxt:String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchTxt.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            TextField("Search by name or symbol", text: $searchTxt)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled()
                .overlay (
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x:10)
                        .foregroundStyle( Color.theme.accent)
                        .opacity(searchTxt.isEmpty ? 0 : 1)
                        .onTapGesture(perform: {
                            withAnimation {
                                hideKeyboard()
                                searchTxt=""
                            }
                        })
                    ,alignment: .trailing)
        }
        .font(.headline)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color:Color.theme.background,radius: 10,x:0,y:0)
        }
        .padding()
    }
}


