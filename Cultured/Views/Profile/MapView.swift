//
//  MapView.swift
//  Cultured
//
//  Created by Shaunak Karnik on 3/12/24.
//

import SwiftUI
import MapKit



struct MapView: View {
    @ObservedObject var vm: ViewModel
    @State private var position: MapCameraPosition
    @Binding var showFullMap: Bool
    var locations: [Location]
    
    init(vm: ViewModel, locations: [Location], showFullMap: Binding<Bool>) {
        self.vm = vm
        self.locations = locations
        
        // Camera position defaults to first location
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
            Map(position: $position) {
                    ForEach(locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(uiImage: location.flag)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                
                        }
                        .annotationTitles(.hidden)
                    }
            }
            // Back button
            VStack {
                HStack {
                    if (showFullMap) {
                        Button(action: {
                            self.showFullMap.toggle()
                        }, label: {
                            Image(systemName: "chevron.backward.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                                .padding()
                                .foregroundColor(.black)
                        })
                    }
                    Spacer()
                }.padding(.horizontal, 7)
                Spacer()
            }
        }
    }
}





#Preview {
    MapView(vm: ViewModel(), locations: [
        Location(name: "Mexico", coordinate: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), flag: UIImage(imageLiteralResourceName: "MXFlag")),
        Location(name: "France", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), flag: UIImage(imageLiteralResourceName: "USFlag"))
    ], showFullMap: Binding.constant(false))
}
