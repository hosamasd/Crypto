//
//  CircleBTNAnimationView.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct CircleBTNAnimationView: View {
    @Binding  var animate:Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeInOut(duration: 1) : .none, value: animate) // modern way
            
    }
}

