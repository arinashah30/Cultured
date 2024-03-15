//  MusicView.swift

//  Cultured

//

//  Created by Arina Shah on 2/6/24.

//



import SwiftUI



struct MusicView: View {
    @ObservedObject var vm: ViewModel
    @State var songs = [Song]()
    @State var artists = [Artist]()
    
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
                        
                        Text("Artist Spotlight")
                            .font(Font.custom("Quicksand-Medium", size:20))
                            .frame(maxWidth:350, alignment: .leading)
                        
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(artists, id: \.name) { artist in
                                    VStack{
                                        Link(destination: artist.spotifyURL!) {
                                            AsyncImage(url: artist.imageURL) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width:80, height:80)
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundStyle(.black)
                                            .padding()
                                            
                                            .frame(width: 80, height: 80)
                                            .background(Color.cGreen)
                                            .clipShape(.circle)
                                        }
                                        
                                        Text("\(artist.name)")
                                            .minimumScaleFactor(0.8)
                                    }
                                    .frame(width: 90)
                                }
                                .scrollIndicators(.hidden)
                            }
                            .scrollIndicators(.hidden)
                            
                        }
                        .scrollIndicators(.hidden)
                        .padding(.horizontal, 30)
                        .frame(height: 110)
                        /*
                        HStack{
                            VStack{
                                Button {

                                    

                                } label: {

                                    Image("KaliUchis")

                                        .resizable().frame(width:80, height:80)

                                        .aspectRatio(contentMode: .fit)

                                    

                                        .foregroundStyle(.black)

                                        .padding()

                                }

                                .frame(width: 80, height: 80)

                                .background(Color.cGreen)

                                .clipShape(.circle)

                               Text("Kali Uchis")

                            }

                            Spacer()

                                .frame(width:40)

                            VStack {

                                Button {

                                    

                                } label: {

                                    Text("Artist 2")

                                        .foregroundStyle(.black)

                                        .padding()

                                }

                                .frame(width: 80, height: 80)

                                .background(Color.cGreen)

                                .clipShape(.circle)

                                Text("Xavi")

                            }

                            Spacer()

                                .frame(width:40)

                            VStack{

                                Button {

                                    

                                } label: {

                                    Text("Artist 3")

                                        .foregroundStyle(.black)

                                        .padding()

                                }

                                .frame(width: 80, height: 80)

                                .background(Color.cGreen)

                                .clipShape(.circle)

                            Text("Yame")

                            }

                            

                        }
                         */
                        Spacer()
                            .frame(height: 25)

                        Text("Trending Songs")

                            .font(Font.custom("Quicksand-Regular", size: 20))

                            .frame(maxWidth: 340, alignment: .leading)

                        ScrollView {
                            LazyVStack {
                                ForEach(songs, id: \.name) { song in
                                    Link(destination: song.spotifyURL!) {
                                        HStack {
                                            AsyncImage(url: song.albumImageURL) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width:58, height:58, alignment: .leading)
                                            .cornerRadius(5)
                                            .aspectRatio(contentMode: .fit)
                                            
                                            Spacer()
                                            
                                            VStack{
                                                Text("\(song.name)")
                                                    .foregroundStyle(.black)
                                                Text("\(song.artistNames)")
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.8)
                                            }
                                            
                                            
                                            Spacer()
                                            
                                            Image("SpotifyIcon")
                                                .resizable()
                                                .frame(width:30, height:30)
                                        }
                                        .padding(.horizontal, 15)
                                    }
                                    .frame(width: 324, height:76)
                                    .background(Color.cLightGray)
                                    .clipShape(.rect(cornerRadius: 14))
                                    
                                }
                            }
                        }
                        /*
                        VStack{

                            Button {

                                

                            } label: {

                                HStack{

                                    Image("FirstLoveIcon")

                                        .resizable()

                                        .frame(width:58, height:58, alignment: .leading)

                                        .cornerRadius(5)

                                    Spacer()

                                        .frame(width:10)

                                    VStack{

                                        Text("First song")

                                            .foregroundStyle(.black)

                                        Text("Artists")

                                    }

                                    .padding()

                                    Image("SpotifyIcon")

                                        .resizable()

                                        .frame(width:30, height:30)

                                    Image("AppleMusicIcon")

                                        .resizable()

                                        .frame(width:30, height: 30)

                                }

                            }

                            .frame(width: 324, height:76)

                            .background(Color.cLightGray)

                            .clipShape(.rect(cornerRadius: 14))

                            Button {

                                

                            } label: {

                                HStack{

                                    Image("FirstLoveIcon")

                                        .resizable()

                                        .frame(width:58, height:58)

                                        .cornerRadius(5)

                                    Spacer()

                                        .frame(width:10)

                                    VStack{

                                        Text("First song")

                                            .foregroundStyle(.black)

                                        Text("Artists")

                                    }

                                    .padding()

                                    Image("AppleMusicIcon")

                                        .resizable()

                                        .frame(width:30, height:30)

                                    Image("YTMusicIcon")

                                        .resizable()

                                        .frame(width:30, height: 21)

                                }

                            }

                            .frame(width: 324, height:76)

                            .background(Color.cLightGray)

                            .clipShape(.rect(cornerRadius: 14))

                            Button {

                                

                            } label: {

                                HStack{

                                    Image("FirstLoveIcon")

                                        .resizable()

                                        .frame(width:58, height:58)

                                        .cornerRadius(5)

                                    Spacer()

                                        .frame(width:10)

                                    VStack{

                                        Text("First song")

                                            .foregroundStyle(.black)

                                        Text("Artists")

                                    }

                                    .padding()

                                    Image("SpotifyIcon")

                                        .resizable()

                                        .frame(width:30, height:30)

                                    Image("YTMusicIcon")

                                        .resizable()

                                        .frame(width:30, height: 21)

                                }

                            }

                            .frame(width: 324, height:76)

                            .background(Color.cLightGray)

                            .clipShape(.rect(cornerRadius: 14))

                            

                        }
                         */
                    }

                    .frame(width: 400.0, height: 600.0)

                    .background(Color.white)

                    .clipShape(.rect(cornerRadius: 50))

                }

            }
            // TODO: add dark mode? (this fix works for both light & dark modes)
            .foregroundStyle(.black)

        }
        .task {
            // TODO: dynamically assign country to view; use that information to retrieve Spotify API data.
            let demoModule = Module(title: "", information: "", country: "MEXICO", completed: false)
            let (songs, artists) = await vm.getMusicData(for: Country(name: "MEXICO", music: demoModule, food: demoModule, customs: demoModule), songCount: 20, artistCount: 5)
            
            self.songs = songs
            self.artists = artists
        }
        }

    }







#Preview {

    MusicView(vm: ViewModel())

}
