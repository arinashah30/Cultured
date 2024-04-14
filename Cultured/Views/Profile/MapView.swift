//
//  MapView.swift
//  Cultured
//
//  Created by Shaunak Karnik on 3/12/24.
//

import SwiftUI
import MapKit


let countryflags: [String:String] = ["Mexico": "🇲🇽", "France": "🇫🇷", "India": "🇮🇳", "Italy": "🇮🇹"]

struct MapView: View {
    @ObservedObject var vm: ViewModel
    @State private var position: MapCameraPosition
    @Binding var showFullMap: Bool
    @State var locations: [Location]
    @Binding var completedCountries: [String]
    
    
    init(vm: ViewModel, showFullMap: Binding<Bool>, completedCountries: Binding<[String]>) {
        self.vm = vm
        self._completedCountries = completedCountries
        
        self._showFullMap = showFullMap
        
        self._position = State<MapCameraPosition>(initialValue: MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
            )
        ))
        
        self.locations = []
        
    }
    
    
    
    
    var body: some View {
        ZStack {
            Map(position: $position) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        
                        Circle()
                            .fill(Color.white) // You can change the color as needed
                            .frame(width: 60, height: 60) // Adjust size as needed
                            .overlay(
                                Text(countryflags[location.name] ?? "🇲🇽")
                                    .font(.system(size: 50)) // Adjust font size as needed
                                    .foregroundColor(.white)
                            )
                        
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
        }.onChange(of: completedCountries) {
            populateLocations { coords in
                locations = coords
            }
            print("Locations in on change of \(locations)")
            
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
        .onAppear {
            populateLocations { coords in
                locations = coords
            }
            
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
    }
    
    
    
    func populateLocations(completion: @escaping ([Location]) -> Void) {
        var countries: [String] = []
        countries.append(vm.current_user?.country ?? "null")
        if !completedCountries.isEmpty {
            countries += completedCountries
        }
        
        var locations: [Location] = []
        
        let group = DispatchGroup() // Create a dispatch group
        
        for country in countries {
            group.enter() // Enter the group before starting each asynchronous task
            
            vm.getLatitudeLongitude(country: country) { coords in
                defer {
                    group.leave() // Leave the group after the asynchronous task completes
                }
                if let coords = coords {
                    let latitude = coords["latitude"] ?? 0
                    let longitude = coords["longitude"] ?? 0
                    locations.append(Location(name: country, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
                } else {
                    print("Error in populating locations")
                }
            }
        }
        
        group.notify(queue: .main) {
            // This closure is called when all tasks in the group have completed
            if !locations.isEmpty {
                // Camera position defaults to first location
                position = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: locations[0].coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                    )
                )
            }
            completion(locations)
        }
    }
}



#Preview {
    MapView(vm: ViewModel(), showFullMap: Binding.constant(false), completedCountries: Binding.constant([]))
}
