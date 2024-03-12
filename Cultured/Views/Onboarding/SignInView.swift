//
//  SignInView.swift
//  Cultured
//
//  Created by Ryan O’Meara on 2/29/24.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var vm: ViewModel
    @State var isChecked = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            ZStack{
                Image("SignInBanner")
                    .resizable()
                    .frame(width: 393, height: 200)
                Image("CulturedTitle")
                    .resizable()
                    .frame(width:126, height:29)
                
            }

            Text("Sign In")
                .font(Font.custom("Quicksand-Medium", size: 32))
                .foregroundColor(.cDarkGray)
                .padding(36)
            
            VStack{
                HStack{
                    Text("Email Address")
                        .foregroundColor(.cDarkGray)
                        .font(.system(size: 16))
                        .padding(.bottom, -5)
                    Spacer()
                }
                HStack{
                    Image("Mail")
                        .resizable()
                        .frame(width:21, height:17)
                        .padding([.leading, .trailing], 16)
                    TextField("", text: $email, prompt: Text("Email Address")                .foregroundColor(.cMedGray))
                        .textInputAutocapitalization(.never)
                }
                .frame(maxWidth: .infinity, minHeight:52)
                .background(Color.cLightGray)
                .clipShape(.rect(cornerRadius: 14.0))
                .padding(.bottom, 15)
                
                HStack{
                    Text("Password")
                        .foregroundColor(.cDarkGray)
                        .font(.system(size: 16))
                        .padding(.bottom, -5)
                    Spacer()
                }
        
                HStack{
                    Image("Lock")
                        .resizable()
                        .frame(width:15, height:17)
                        .padding([.leading, .trailing], 19)
                    TextField("", text: $password, prompt: Text("Password")                .foregroundColor(.cMedGray))
                        .textInputAutocapitalization(.never)
                }
                .frame(maxWidth: .infinity, minHeight:52)
                .background(Color.cLightGray)
                .clipShape(.rect(cornerRadius: 14.0))
                
                Button{} label: {
                    Text("Sign In")
                        .foregroundColor(.black)
                        .font(.system(size: 19))
                }
                .frame(maxWidth: .infinity, minHeight:45)
                .background(Color.cOrange)
                .clipShape(.rect(cornerRadius: 60))
                .padding(.top, 20)
                
            }
            .padding([.leading, .trailing], 20)
//            .background(Color.cBlue)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack{
                Text("Don't have an account?")
                Text("Sign in")
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SignInView(vm: ViewModel())
}
