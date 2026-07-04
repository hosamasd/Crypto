//
//  XMarkButton.swift
//  Crypto
//
//  Created by hosam on 04/07/2026.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }

    }
}

#Preview {
    XMarkButton()
}
