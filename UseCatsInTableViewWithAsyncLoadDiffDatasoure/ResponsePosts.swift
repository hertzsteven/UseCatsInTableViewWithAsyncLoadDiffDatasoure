
    //
    //  ResponsePosts.swift
    //  LearnCollectionVCWithAsyncImages
    //
    //  Created by Steven Hertz on 5/31/22.
    //

import Foundation

enum Section {
    case main
}

struct PostUserProfileImage: Codable {
    let medium: String
}

struct PostUser: Codable {
    let profile_image: PostUserProfileImage
}

struct PostUrls: Codable {
    let regular: String
}

class Post: Codable, Hashable {
    var identifier = UUID()
    let id: String
    let description: String?
    let user: PostUser
    let urls: PostUrls
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct APIResponse: Codable {
    var results: [Post] = []
}
