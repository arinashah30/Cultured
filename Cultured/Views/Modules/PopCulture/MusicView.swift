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
                ZStack(alignment: .topLeading){
                    Image("MusicImage")
                        .resizable()
                        .frame(width:575, height:323)
                    BackButton()
                        .offset(x:80, y:20)
                }
                
                
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
                        
                        Text(vm.current_user?.country ?? "Mexico")
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
                                            
                                            
                                            
                                            VStack (alignment: .leading){
                                                Text("\(song.name)")
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.8)
                                                    .foregroundStyle(.cDarkGray)
                                                Text("\(song.artistNames)")
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.8)
                                                    .foregroundStyle(Color.cLightGray)
                                            }
                                            
                                            
                                            Spacer()
                                            
                                            Image("SpotifyIcon")
                                                .resizable()
                                                .frame(width:30, height:30)
                                        }
                                        .padding(.horizontal, 15)
                                    }
                                    .frame(width: 324, height:76)
                                    .background(Color("cBarColor"))
                                    .clipShape(.rect(cornerRadius: 14))
                                    
                                }
                            }
                            .padding(.bottom, 100)
                        }
                        
                    }
                    
                    .frame(width: 400.0, height: 600.0)
                    
                    .background(Color.cPopover)
                    
                    .clipShape(.rect(cornerRadius: 50))
                    
                }
                
            }
            // TODO: add dark mode? (this fix works for both light & dark modes)
            //.foregroundStyle(.black)
            
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
