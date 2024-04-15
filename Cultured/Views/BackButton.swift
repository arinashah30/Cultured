//
//  BackButton.swift
//  Cultured
//
//  Created by Ryan O’Meara on 3/28/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button {
            dismiss()
        } label: {
            
            ZStack {
                Circle()
                    .frame(width: 50, height: 50)
                    .padding(.top, 50)
                    .padding(.leading, 20)
                    .foregroundColor(Color.cPopover.opacity(0.8))
                Image("Arrow")
                    .padding(.top, 50)
                    .padding(.leading, 18)
            }
        }
    }
}

#Preview {
    BackButton()
}
