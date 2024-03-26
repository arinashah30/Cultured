//
//  EditSelfProfileView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct EditSelfProfileView: View {
    @ObservedObject var vm: ViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isOn = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(){
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .padding([.leading, .top])
                        .font(.system(size: 24))
                        .foregroundColor(.cDarkGray)
                }
                Spacer()
            }
            Text("Settings")
                .padding()
                .font(Font.custom("Quicksand-semibold", size: 32))
                .foregroundColor(.cDarkGray)
            Text("Account")
                .padding([.leading, .bottom])
                .font(Font.custom("Quicksand-medium", size: 24))
                .foregroundColor(.cDarkGray)
            HStack(){
                Text("Name")
                    .padding(.leading)
                    .padding(.trailing, 60)
                    .font(.system(size: 20))
                    .foregroundColor(.cDarkGray)
                Text("First Last")
                    .font(.system(size: 20))
                    .foregroundColor(.cMedGray)
            }
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.cLightGray)
                .padding([.trailing, .leading], 21)
            Text("Change Password")
                .padding(.leading)
                .padding(.bottom)
                .padding(.top, 5)
                .font(.system(size: 20))
                .foregroundColor(.cMedGray)
            Text("Notifications")
                .padding(.leading)
                .padding(.bottom, 10)
                .font(Font.custom("Quicksand-medium", size: 24))
                .foregroundColor(.cDarkGray)
            HStack(){
                Text("Push Notifications")
                    .padding([.leading, .bottom])
                    .font(.system(size: 20))
                    .foregroundColor(.cDarkGray)
                Spacer()
                Toggle("", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: .cGreen))
                        .frame(width: 63, height: 30)
                        .padding(.trailing, 22)
                .frame(maxWidth: 80, maxHeight: 30)
                .background(.white)
                .clipShape(.rect(cornerRadius: 14.0))
                .offset(y: -5)
            }
            Button {
                vm.firebase_sign_out()
//                print(vm.auth.currentUser ?? "No current user")
            } label: {
                Text("Log Out")
                    .padding()
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 247/255, green: 64/255,blue: 64/255))
            }
            Spacer()
        }
    }
}

#Preview {
    EditSelfProfileView(vm: ViewModel())
}
