//
//  launchView.swift
//  Crypto
//
//  Created by hosam on 05/07/2026.
//

import SwiftUI

struct launchView: View {
    @State private var loodingText:[String]="Looding your portfolio".map{String($0)}
    @State private var showLoodingText=false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter=0
    @State private var loops=0
    @Binding var showLaunchView:Bool
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100,height: 100)
            
            ZStack{
                if showLoodingText{
                    HStack(spacing: 0){
                        ForEach(loodingText.indices) {index in
                            Text(loodingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.theme.accent)
                                .offset(y:counter == index ? -5 : 0)
                            
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            .offset(y:70)
        }
        .onAppear {
            showLoodingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring){
                let lastIndex = loodingText.count - 1
                if counter == lastIndex{
                    counter = 0
                    loops += 1
                    
                    if loops >= 2{
                        showLaunchView=false
                    }
                }else{
                    
                    counter += 1
                }
            }
        }
    }
    
}

struct CoinRoswssViewPreview:PreviewProvider {
    static var previews: some View{
        launchView(showLaunchView: .constant(true))
    }
    
}
