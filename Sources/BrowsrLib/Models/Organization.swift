//
//  Organization.swift
//  
//
//  Created by Vitor Dinis on 24/10/2022.
//

import Foundation

public struct Organization: Codable {
    public let login: String
    public let id: Int
    public let nodeID: String
    public let url, reposURL, eventsURL, hooksURL: String
    public let issuesURL: String
    public let membersURL, publicMembersURL: String
    public let avatarURL: String
    public let organizationDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case url
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case hooksURL = "hooks_url"
        case issuesURL = "issues_url"
        case membersURL = "members_url"
        case publicMembersURL = "public_members_url"
        case avatarURL = "avatar_url"
        case organizationDescription = "description"
    }
}
