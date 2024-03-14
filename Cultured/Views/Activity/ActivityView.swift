//
//  ActivityView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var vm: ViewModel
    //@State var badgePopUp: Bool = true
    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                ZStack (alignment: .leading) {
                    VStack {
                        Image("ShieldBadge")
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                    }
                    HStack {
                        Spacer()
                        Text("Badge Title")
                            .font(Font.custom("Quicksand-medium", size: 24))
                        Spacer()
                    }
                }
                
                Text("Date...")
                    .font(Font.custom("Quicksand-medium", size: 20))
                Text("Badge Information...")
                    .font(Font.custom("Quicksand-medium", size: 16))
            }
            .padding(20)
            .frame(maxWidth: 303, maxHeight: 151, alignment: .leading)
            .background(Color.cOrange)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .foregroundColor(.cDarkGray)
            
            
            
            GeometryReader { geometry in
                Button(action: {
                    //badgePopUp = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.cDarkGray)
                        .frame(width: 12, height: 12)
                }.position(x: geometry.size.width - ((geometry.size.width - 303) / 2) - 12 - 12, y: ((geometry.size.height - 151) / 2) + 12 + 12)
            }
        }
    }
}

#Preview {
    ActivityView(vm: ViewModel())
}
