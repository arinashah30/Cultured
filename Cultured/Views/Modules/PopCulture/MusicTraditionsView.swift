//  MusicView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//
import SwiftUI
struct MusicTraditionsView: View {
    var body: some View {
        ZStack{
            VStack{
                Image("MusicImage")
                    .resizable()
                    .frame(width:575, height:323)
                
                Spacer()
                    .frame(height:555)
            }
            VStack{
                Spacer()
                    .frame(height:290)
                ScrollView(.vertical) {
                    VStack{
                        Spacer()
                            .frame(height: 20)
                        Text("Music")
                            .frame(maxWidth:350, alignment: .leading)
                            .font(Font.custom("Quicksand-Medium", size: 32))
                            .foregroundColor(Color(red:252/255, green:64/255, blue:64/255))
                        
                        Text("Mexico")
                            .frame(maxWidth:325, alignment: .leading)
                            .font(Font.custom("Quicksand-Light", size: 15))
                        
                        
                        Text("Styles")
                            .font(Font.custom("Quicksand-Medium", size:20))
                            .frame(maxWidth:350, alignment: .leading)
                        
                        Button{
    
             } label: {
        VStack{
            Image("Mariachi")
               .resizable()
                        .frame(width:145, height:185, alignment: .leading)
               .cornerRadius(14)
                        VStack{
                            Text("Mariachi Information")
                                .font(Font.custom("Quicksand-Regular", size : 20))
                                      Spacer()
                                 }
                             }
                        Spacer()
                            .frame(height: 25)
                        Text("Classics")
                            .font(Font.custom("Quicksand-Regular", size: 20))
                            .frame(maxWidth: 340, alignment: .leading)
//                        VStack{
//                            Button {
//
//                            } label: {
//                                HStack{
//                                    Image("FirstLoveIcon")
//                                        .resizable()
//                                        .frame(width:58, height:58, alignment: .leading)
//                                        .cornerRadius(5)
//                                    Spacer()
//                                        .frame(width:10)
//                                    VStack{
//                                        Text("First song")
//                                            .foregroundStyle(.black)
//                                        Text("Artists")
//                                    }
//                                    .padding()
//                                    Image("SpotifyIcon")
//                                        .resizable()
//                                        .frame(width:30, height:30)
//                                    Image("AppleMusicIcon")
//                                        .resizable()
//                                        .frame(width:30, height: 30)
//                                }
//                            }
//                            .frame(width: 324, height:76)
//                            .background(Color.cLightGray)
//                            .clipShape(.rect(cornerRadius: 14))
//                            Button {
//
//                            } label: {
//                                HStack{
//                                    Image("FirstLoveIcon")
//                                        .resizable()
//                                        .frame(width:58, height:58)
//                                        .cornerRadius(5)
//                                    Spacer()
//                                        .frame(width:10)
//                                    VStack{
//                                        Text("First song")
//                                            .foregroundStyle(.black)
//                                        Text("Artists")
//                                    }
//                                    .padding()
//                                    Image("AppleMusicIcon")
//                                        .resizable()
//                                        .frame(width:30, height:30)
//                                    Image("YTMusicIcon")
//                                        .resizable()
//                                        .frame(width:30, height: 21)
//                                }
//                            }
//                            .frame(width: 324, height:76)
//                            .background(Color.cLightGray)
//                            .clipShape(.rect(cornerRadius: 14))
//                            Button {
//
//                            } label: {
//                                HStack{
//                                    Image("FirstLoveIcon")
//                                        .resizable()
//                                        .frame(width:58, height:58)
//                                        .cornerRadius(5)
//                                    Spacer()
//                                        .frame(width:10)
//                                    VStack{
//                                        Text("First song")
//                                            .foregroundStyle(.black)
//                                        Text("Artists")
//                                    }
//                                    .padding()
//                                    Image("SpotifyIcon")
//                                        .resizable()
//                                        .frame(width:30, height:30)
//                                    Image("YTMusicIcon")
//                                        .resizable()
//                                        .frame(width:30, height: 21)
//                                }
//                            }
//                            .frame(width: 324, height:76)
//                            .background(Color.cLightGray)
//                            .clipShape(.rect(cornerRadius: 14))
//
//                        }
                        
                    }
                    .frame(width: 400.0, height: 500.0)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 50))
                }
            }
        }
        }
    }
                       }
#Preview {
    MusicTraditionsView()
}




