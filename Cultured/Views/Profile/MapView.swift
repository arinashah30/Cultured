//
//  MapView.swift
//  Cultured
//
//  Created by Shaunak Karnik on 3/12/24.
//

import SwiftUI
import MapKit


struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    let flag: UIImage
}


struct MapView: View {
    
    var locations: [Location]
    @State private var position: MapCameraPosition
    @Binding var showFullMap: Bool
    
    init(locations: [Location], showFullMap: Binding<Bool>) {
        self.locations = locations
        self._position = State<MapCameraPosition>(initialValue: MapCameraPosition.region(
            MKCoordinateRegion(
                center: locations[0].coordinate,
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        ))
        self._showFullMap = showFullMap
    }
    
    
    var body: some View {
        ZStack {
//            HStack {

//                Spacer()
//            }.padding(.horizontal, 20)
            Map(position: $position) {
                    ForEach(locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(uiImage: location.flag)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 65, height: 65)
                                .clipShape(Circle())
                                
                        }
                        .annotationTitles(.hidden)
                    }
            }
            VStack {
                HStack {
                    Button(action: {
                        self.showFullMap.toggle()
                    }, label: {
                        Image(systemName: "chevron.backward.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                            .padding()
                    })
                    Spacer()
                }.padding(.horizontal, 5)
                Spacer()
            }
        }
    }
}





#Preview {
    MapView(locations: [
        Location(name: "Mexico", coordinate: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), flag: UIImage(imageLiteralResourceName: "MXFlag")),
        Location(name: "France", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), flag: UIImage(imageLiteralResourceName: "USFlag"))
    ], showFullMap: Binding.constant(false))
}
