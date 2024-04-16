//
//  MovieView.swift
//  Cultured
//
//  Created by Datta Kansal on 3/29/24.
//

import SwiftUI

struct MovieView: View {
    //    var actors = [(String, String] = [("")]
    //    @State var actors = [Actor]()
    @State var viewModel : MovieViewModel
    @ObservedObject var vm: ViewModel
    
    init(actors: [String], classicMovies: [String], vm: ViewModel) {
        self.viewModel = MovieViewModel(actorNames: actors, classicMovieNames: classicMovies)
        self.vm = vm
    }
    
    var body: some View {
        ZStack(alignment:.topLeading) {
            Image("MovieBg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea()
                .offset(y:-screenWidth * 0.75)
            BackButton()
                .offset(x:10, y:30)

            VStack {

                Text("Movies/TV")
                    .frame(maxWidth: UIScreen.main.bounds.width * (8/9), alignment: .leading)
                    .font(Font.custom("Quicksand-SemiBold", size: 32))
                    .foregroundColor(Color(red: 19/255, green: 145/255, blue: 234/255))
                    .padding(.top, 20)
                Text(vm.current_user?.country ?? "Mexico")
                    .frame(maxWidth: UIScreen.main.bounds.width * (8/9), alignment: .leading)
                    .font(Font.custom("Sf-pro-display", size: 16))
                    .foregroundColor(Color(red: 148/255, green: 148/255, blue: 148/255))
                    .padding(.bottom, 15)
                ScrollView(.vertical) {
                Text("Actor Spotlight")
                    .frame(maxWidth: UIScreen.main.bounds.width * (8/9), alignment: .leading)
                    .font(Font.custom("Quicksand-Mediium", size: 24))
                    .foregroundColor(.cDarkGray)
                
                VStack {
                    if viewModel.actors.isEmpty {
                        Text("No Results")
                    } else {
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(viewModel.actors, id: \.id) { actor in
                                    VStack {
                                        AsyncImage(url: actor.actorProfile) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 90)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.black)

                                        .frame(width: 100, height: 90)
                                        .background(Color.cGreen)
                                        .clipShape(.circle)

                                        .padding(.trailing, 15)
                                        Text("\(actor.name)")
                                            .font(.system(size: 18))
                                            .frame(width: 100, height: 50)
                                            .lineLimit(6)
                                            .minimumScaleFactor(0.8)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.cDarkGray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                        .scrollIndicators(.hidden)
                    }
                }
                
                Text("In Theaters")
                    .frame(maxWidth: UIScreen.main.bounds.width * (8/9), alignment: .leading)
                    .font(Font.custom("Quicksand-Mediium", size: 24))
                    .foregroundColor(Color.cDarkGray)
                    .padding(.top,15)
                
                VStack {
                    if viewModel.theatermovies.isEmpty {
                        Text("No Results")
                    } else {
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(viewModel.theatermovies, id: \.id) { movie in
                                    VStack {
                                        AsyncImage(url: movie.moviePoster) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 150, height: 207)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.black)


                                        .frame(width: 150, height: 207)
                                        .background(Color.cGreen)
                                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                                        Text("\(movie.title)")
                                            .font(.system(size: 18))
                                            .frame(width: 150, height: 50)
                                            .lineLimit(6)
                                            .minimumScaleFactor(0.8)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.cDarkGray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                        .scrollIndicators(.hidden)

                    }
                }
                
                Text("Classics")
                    .frame(maxWidth: UIScreen.main.bounds.width * (8/9), alignment: .leading)
                    .font(Font.custom("Quicksand-Mediium", size: 24))
                    .foregroundColor(Color.cDarkGray)
                    .padding(.top,15)
                
                VStack {
                    if viewModel.classicmovies.isEmpty {
                        Text("No Results")
                    } else {
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(viewModel.classicmovies, id: \.id) { movie in
                                    VStack {
                                        AsyncImage(url: movie.moviePoster) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 150, height: 207)
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.black)


                                        .frame(width: 150, height: 207)
                                        .background(Color.cGreen)
                                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                                        Text("\(movie.title)")
                                            .font(.system(size: 18))
                                            .frame(width: 150, height: 50)
                                            .lineLimit(6)
                                            .minimumScaleFactor(0.8)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.cDarkGray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                        .scrollIndicators(.hidden)
                    }
                }
                    Spacer()
                        .frame(height:300)


            }
                .scrollIndicators(.hidden)
        }
                .frame(width:screenWidth, height:screenHeight)
                .background(Color.cPopover)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .offset(y:screenHeight * 0.25)
                
        }
        .onAppear {
//            vm.getInfoTvMovie(countryName: vm.current_user?.country ?? "Mexico") {movies in
//                viewModel = MovieViewModel(actorNames: movies.actors, classicMovieNames: movies.classics)
//
//            }
            viewModel.loadMovies()
            viewModel.loadActors()

        }
    }
}
//#Preview {
//    MovieView(actors:[], classicMovies: [], vm: ViewModel())
//}
