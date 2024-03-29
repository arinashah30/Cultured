//
//  Location.swift
//  Cultured
//
//  Created by Shaunak Karnik on 3/29/24.
//

import Foundation
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
    let flag: UIImage
}
