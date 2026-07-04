//
//  HomeStatView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct HomeStatView: View {
    @ObservedObject var vm:HomeViewModel
    
    @Binding var showPortforlio:Bool
    var body: some View {
        HStack{
            ForEach(vm.statistics){stat in
            StatisticsView(stat: stat)}
            .frame(width: getFrameSize().width/3)
        }
        .frame(width: getFrameSize().width,alignment: showPortforlio ? .trailing: .leading)
    }
}

#Preview {
    HomeStatView(vm: HomeViewModel(), showPortforlio: .constant(false))
}
