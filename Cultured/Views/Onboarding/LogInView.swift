//
//  LogInView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct LogInView: View {
    @ObservedObject var vm: ViewModel
    @State var isChecked = false
    @State var email = ""
    @State var password = ""
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    @State var navigateToHome: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack{
                    Image("SignInBanner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: screenWidth, height: screenHeight / 4)
                        .padding(.top, -8)
                    Image("CulturedTitle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:screenWidth * 2/3, height: screenHeight / 1/5)
                    
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
                        TextField("", text: $email, prompt: Text("Email Address")                .foregroundColor(.cMedGray)).foregroundColor(.black)
                            .textInputAutocapitalization(.never)
                            .textContentType(.emailAddress)
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
                        SecureField("", text: $password, prompt: Text("Password")                .foregroundColor(.cMedGray))
                            .textInputAutocapitalization(.never)
                            .textContentType(.password)
                    }
                    .frame(maxWidth: .infinity, minHeight:52)
                    .background(Color.cLightGray)
                    .clipShape(.rect(cornerRadius: 14.0))
                    
                    
                    if let errorText = vm.errorText {
                        Text(errorText).foregroundStyle(Color.red)
                    } else {
                        Text(" ")
                    }
                    
                    Button{
                        vm.errorText = nil
                        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        if !email.isEmpty && !password.isEmpty {
                            vm.fireBaseSignIn(email: email, password: password) { completed in
                                if completed {
                                    navigateToHome = true
                                }
                            }
                        } else {
                            vm.errorText = "You must fill out all fields"
                        }
                    } label: {
                        Text("Sign In")
                            .foregroundColor(.black)
                            .font(.system(size: 19))
                    }.navigationDestination(isPresented: $navigateToHome, destination: {MainView(selectedView: .home, vm: vm)})
                    .frame(maxWidth: .infinity, minHeight:45)
                    .background(Color.cOrange)
                    .clipShape(.rect(cornerRadius: 60))
                    
                }
                .padding([.leading, .trailing], 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                HStack{
                    Text("Don't have an account?")
                        .foregroundStyle(Color.cDarkGray)
                    Spacer()
                    NavigationLink{
                        SignUpView(vm: vm)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Sign Up")
                            .foregroundStyle(Color.cDarkGray)
                            .underline()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 25)
                .padding([.leading, .trailing], 57)
            }
            .ignoresSafeArea()
        }
    }
}


//#Preview {
//    LogInView(vm: ViewModel())
//}
