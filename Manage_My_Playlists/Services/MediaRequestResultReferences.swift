//
//  MediaRequestResultCases.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.10.2022.
//

import Foundation

enum MediaRequestResultReferences: String {
    
    case authorized
    case denied
    case restricted
    case notDetermined
    
}

enum FetchResults {
    
    case SUCCESS
    case FAILED
    
}

enum GetPlaylistsResults {

    case SUCCESS
    case FAILED
    case USERHASNOSUBSCRIPTION
    case denied
    case restricted
    case notDetermined
}
