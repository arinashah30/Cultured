//
//  SignUpView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var vm: ViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword = ""
    @State private var username: String = ""
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
                
                Text("Create Account")
                    .font(Font.custom("Quicksand-Medium", size: 32))
                    .foregroundColor(.cDarkGray)
                    .padding(25)
                
                VStack{
                    HStack{
                        Text("Name")
                            .foregroundColor(.cDarkGray)
                            .font(.system(size: 16))
                            .padding(.bottom, -5)
                        Spacer()
                    }
                    HStack{
                        Image("User")
                            .resizable()
                            .frame(width:16, height:20)
                            .padding([.leading, .trailing], 18.5)
                        TextField("", text: $username, prompt: Text("Name")                .foregroundColor(.cMedGray)).foregroundColor(.black)
                            .textInputAutocapitalization(.never)
                            .textContentType(.name)
                    }
                    .frame(maxWidth: .infinity, minHeight:52)
                    .background(Color.cLightGray)
                    .clipShape(.rect(cornerRadius: 14.0))
                    .padding(.bottom, 10)
                
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
                    .padding(.bottom, 10)
                    
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
                            .textContentType(.newPassword)
                    }
                    .frame(maxWidth: .infinity, minHeight:52)
                    .background(Color.cLightGray)
                    .clipShape(.rect(cornerRadius: 14.0))
                    .padding(.bottom, 10)
                    
                    HStack{
                        Text("Confirm Password")
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
                        SecureField("", text: $repeatPassword, prompt: Text("Confirm Password") .foregroundColor(.cMedGray))
                            .textInputAutocapitalization(.never)
                            .textContentType(.newPassword)
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
                        
                        if !email.isEmpty && !username.isEmpty &&  !password.isEmpty && password == repeatPassword {
                            vm.firebase_email_password_sign_up_(
                                email: self.email,
                                password: self.password,
                                username: self.username
                            ) { completed in
                                navigateToHome = completed
                            }
                        }
                        else {
                            vm.errorText = "You must fill out all fields"
                        }
                    } label: {
                        Text("Sign Up")
                            .foregroundColor(.black)
                            .font(.system(size: 19))
                    }
                    .navigationDestination(isPresented: $navigateToHome, destination: {MainView(selectedView: .home, vm: vm)})
                    .frame(maxWidth: .infinity, minHeight:45)
                    .background(Color.cOrange)
                    .clipShape(.rect(cornerRadius: 60))
                    
                }
                .padding([.leading, .trailing], 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 70)
                
                HStack{
                    Text("Already have an account?")
                        .foregroundStyle(Color.cDarkGray)
                    Spacer()
                    NavigationLink{
                        LogInView(vm: vm)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Log In")
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

#Preview {
    SignUpView(vm: ViewModel())
}
