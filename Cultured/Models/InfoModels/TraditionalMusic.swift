//
//  TraditionalMusic.swift
//  Cultured
//
//  Created by Rik Roy on 4/2/24.
//

import Foundation

struct Music: Equatable {
    var title: [String]
    var artist: [String]
    var link: [String]
    var styles: [String: String]
    
    init() {
        self.title = []
        self.artist = []
        self.link = []
        self.styles = [:]
    }
    init(title: [String], artist: [String], link: [String], styles: [String: String]) {
        self.title = title
        self.artist = artist
        self.link = link
        self.styles = styles
    }
    
    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.title == rhs.title && lhs.artist == rhs.artist && lhs.link == rhs.link && lhs.styles == rhs.styles
    }
}
