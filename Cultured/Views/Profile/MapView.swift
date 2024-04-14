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
    var completedCountries: [String]

    
    init(vm: ViewModel, showFullMap: Binding<Bool>, completedCountries: [String]) {
        self.vm = vm
//        self.locations = [
//            Location(name: "Mexico", coordinate: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), flag: UIImage(imageLiteralResourceName: "MXFlag")),
//            Location(name: "France", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), flag: UIImage(imageLiteralResourceName: "USFlag"))
//        ]
        self.completedCountries = completedCountries

        self._showFullMap = showFullMap
        
        self._position = State<MapCameraPosition>(initialValue: MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        ))
        
        self.locations = []
        
        self.locations = populateLocations()
        
        if !locations.isEmpty {
            // Camera position defaults to first location
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: locations[0].coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                )
            )
        }

    }
    
    // Returns an array of Locations from current_user's completed and current countries
    func populateLocations() -> [Location] {
        var countries: [String] = []
        countries.append(vm.current_user?.country ?? "null")
        if !(completedCountries.isEmpty) {
            countries += completedCountries
        }
        
        
        
        var locations: [Location] = []
        if !countries.isEmpty && countries[0] != "null" {
            for country in countries {
//                print(country)
                vm.getLatitudeLongitude(countryName: country) { coords in
                    if let coords = coords {
                        // for testing
                        print(coords["latitude"])
                        print(coords["longitude"])
                        
                        locations.append(Location(name: country, coordinate: CLLocationCoordinate2D(latitude: coords["latitude"] ?? 0, longitude: coords["latitude"] ?? 0)))
                        //for testing
                        print("locations: \(locations)")
                    } else {
                        print("Error in populating locations")
                    }
                }
            }
            print("locations is empty: " + String(locations.isEmpty))
            return locations
        }
        //for testing
        print("locations is still empty: " + String(locations.isEmpty))

        return []
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
        }.onAppear()
    }
}





#Preview {
    MapView(vm: ViewModel(), showFullMap: Binding.constant(false), completedCountries: ["France"])
}
