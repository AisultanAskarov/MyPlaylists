//
//  Apple Media Content Manager.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.10.2022.
//

import Foundation
import UIKit
import MediaPlayer
import MusicKit
import StoreKit
import SwiftUI

class MediaContentManager: ObservableObject {
    
    static let shared = MediaContentManager()
    private let appleMusicAPI = AppleMusicAPI.shared
    
    var storeFrontId: String = ""
    var playlists = [PlaylistWithMusicStructure?]()
    
    @Published var currentPlaylistsId: String = ""
    @Published var currentPlaylistsSongs = [Track]()
    @Published var filteredSongs = [Track]()

    private init() {}
    
    //SEARCH BAR METHODS
    
    func search(with query: String = "") {
        filteredSongs = query.isEmpty ? currentPlaylistsSongs : currentPlaylistsSongs.filter { $0.title.contains(query) }
    }
    
    //GET PLAYLISTS API CALLS
    
    func getPlaylists(onCompletion: @escaping (GetPlaylistsResults) -> Void) {
        
        appleMusicAPI.checkIfAppleMusicIsAvailable { [self] result in
            
            switch result {
                
            case .authorized:
                //AUTHORIZED. Check if user has an apple music subscription
                appleMusicAPI.checkIfUserHasAppleMusicSubscription { [self] result in
                    
                    switch result {
                        
                    case .SUCCESS:
                        //USER HAS AN ACTIVE APPLE MUSIC SUBSCRIPTION
                        //FETCH STOREFRONTID
                        appleMusicAPI.appleMusicFetchStorefrontRegion { [self] result, storefrontId in
                            
                            if result == .SUCCESS, storefrontId != nil {
                                //Fetch Playlists
                                storeFrontId = storefrontId!
                                appleMusicAPI.appleMusicFetchUsersPlaylists() { [self] result, playlistsIds in
                                    
                                    if result == .SUCCESS {
                                        
                                        
                                        appleMusicAPI.appleMusicFetchPlaylistParameters(playlist_ids: playlistsIds!) { result, playlists in
                                            
                                            self.playlists.append(contentsOf: playlists ?? [PlaylistWithMusicStructure]())
                                            onCompletion(.SUCCESS)
                                            
                                        }
                                                                                
                                    } else {
                                        //Something Went Wrong. Ask user to try again.
                                        onCompletion(.FAILED)
                                    }
                                    
                                }
                                
                            } else {
                                //ERROR. Tell user to try again
                                onCompletion(.FAILED)
                            }
                            
                        }
                        
                    case .FAILED:
                        //USER DOESNT HAVE AN ACTIVE APPLE MUSIC SUBSCRIPTION. SHOW APPLE MUSIC PAYWALL
                        onCompletion(.USERHASNOSUBSCRIPTION)

                    case .none:
                        //USER DOESNT HAVE AN ACTIVE APPLE MUSIC SUBSCRIPTION. SHOW APPLE MUSIC PAYWALL
                        onCompletion(.USERHASNOSUBSCRIPTION)

                    }
                    
                }
                
            case .restricted:
                //RESTRICTED
                onCompletion(.restricted)

            case .denied:
                //DENIED
                onCompletion(.denied)

            case .notDetermined:
                //NOTDETERMINED
                onCompletion(.notDetermined)

            case .none:
                //Request Authorization as in NOTDETERMINED
                onCompletion(.notDetermined)

            }
            
        }
        
    }
    
    func getMusicForPlaylist(onCompletion: @escaping (FetchResults, MusicItemCollection<Track>?) -> Void) {
        
        appleMusicAPI.appleMusicFetchMusicFromPlaylist(playlistId: currentPlaylistsId) { [self] result, music in
            
            if result == .SUCCESS, music != nil {
                
                for track in music! {
                    currentPlaylistsSongs.append(track)
                }
                onCompletion(.SUCCESS, music)
                
            } else {
                //Couldnt get music. Ask user to try again
                onCompletion(.FAILED, nil)
            }
            
        }
        
    }
    
}
