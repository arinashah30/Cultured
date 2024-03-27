//
//  User.swift
//  Cultured
//
//  Created by Arina Shah on 2/4/24.
//

import Foundation

struct User: Identifiable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.id == rhs.id)
    }

    // REQUIRED PROPERTIES
    var id: String // username
    var name: String // display name
    var profilePicture: String // url of profile picture
    var email: String // email address
    
    
    // OPTIONAL PROPERTIES (could be empty arrays)
    //var friends: [String] // array of userIDs (usernames)
    var points: Int
    var streak: Int
    var completedChallenges: [String] // array of IDs for completed challenges or name of challenge
    var badges: [String] // array of IDs for badges or name of badges
    var savedArtists: [String] //array of saved music artists
    var country: String
}
