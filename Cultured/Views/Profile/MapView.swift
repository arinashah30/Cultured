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
    let locations = [
        Location(name: "Mexico", coordinate: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), flag: UIImage(imageLiteralResourceName: "MXFlag")),
        Location(name: "India", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), flag: UIImage(imageLiteralResourceName: "USFlag"))
    ]
    @State private var centerLongitutde: Double = 0
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    
//    @State private var position: MapCameraPosition = .automatic

    
    var body: some View {
        
        Map(position: $position) {
            ForEach(locations) { location in
//                Marker(location.name, coordinate: location.coordinate)
                Annotation(location.name, coordinate: location.coordinate) {
                    Image(uiImage: location.flag)
                        .clipShape(Circle())
                }
                .annotationTitles(.hidden)
            }
        }
    }
}

#Preview {
    MapView()
}
