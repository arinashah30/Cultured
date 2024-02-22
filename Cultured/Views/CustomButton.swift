//
//  CustomButton.swift
//  Cultured
//
//  Created by Ryan O’Meara on 2/13/24.
//

import SwiftUI

struct CustomButton: View {
    let text: String
    let function: () -> Void
    let color: Color
    
    var body: some View {
        Button {
        function()
        } label: {
            Text(text)
                .font(Font.custom("Quicksand-Bold", size: 20))
                .foregroundStyle(.white)
                .padding()
        }
            .frame(maxWidth: 160)
            .background(color)
            .clipShape(.rect(cornerRadius: 14.0))
    }
}

#Preview {
    CustomButton(text: "Food",function: {}, color: Color.cBlue)
}
