//

//  MusicView.swift

//  Cultured

//

//  Created by Arina Shah on 2/6/24.

//



import SwiftUI



struct MusicView: View {

    var body: some View {

        VStack{

            Text("Music")

                .frame(maxWidth:325, alignment: .leading)

            Text("Country Name")

                .frame(maxWidth:325, alignment: .leading)

            Spacer()

                .frame(maxHeight: 30)

            Text("Artist Spotlight")

            

            HStack{

                Button {

                    

                } label: {

                    Text("Artist 1")

                    

                        .foregroundStyle(.white)

                        .padding()

                }

                .frame(height: 70)

                .background(Color.cGreen)

                .clipShape(.circle)

                

                

                Button {

                    

                } label: {

                    Text("Artist 2")

                        .foregroundStyle(.white)

                        .padding()

                }

                .frame(height:70

                )

                .background(Color.cGreen)

                .clipShape(.circle)

                Button {

                    

                } label: {

                    Text("Artist 3")

                        .foregroundStyle(.white)

                        .padding()

                }

                .frame(height:70

                )

                .background(Color.cGreen)

                .clipShape(.circle)

                

                

            }

            Spacer()

                .frame(maxHeight: 25)

            Text("Trending Songs")

            VStack{

                Button {

                    

                } label: {

                    HStack{

                        VStack{

                            Text("First song")

                                .foregroundStyle(.white)

                            Text("Artists")

                        }

                        .padding()

                        Image("Landscape")

                    }

                }

                .frame(width: 300)

                .background(Color.red)

                .clipShape(.rect(cornerRadius: 25))

                Button {

                    

                } label: {

                    HStack{

                        VStack{

                            Text("Second song")

                                .foregroundStyle(.white)

                            Text("Artists")

                        }

                        .padding()

                        Image("Landscape")

                    }

                }

                .frame(width:300)

                .background(Color.red)

                .clipShape(.rect(cornerRadius: 25))

                Button {

                    

                } label: {

                    HStack{

                        VStack{

                            Text("Third song")

                                .foregroundStyle(.white)

                            Text("Artists")

                        }

                        .padding()

                        Image("Landscape")

                    }

                }

                .frame(width: 300)

                .background(Color.red)

                .clipShape(.rect(cornerRadius: 25))

            

            }

            

        }

            

        }

    }







#Preview {

    MusicView()

}

