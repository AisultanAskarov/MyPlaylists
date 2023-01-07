//
//  AppleMusicAPI.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 6.01.2023.
//

import UIKit
import StoreKit
import MusicKit

class AppleMusicAPI {
    
    static let shared = AppleMusicAPI()
    let mediaServiceController = SKCloudServiceController()
    
    private init() {}
    
    func appleMusicFetchStorefrontRegion(onCompletion: @escaping (FetchResults, String?) -> Void) {
        
        mediaServiceController.requestStorefrontIdentifier { storefrontId, error in
          
            DispatchQueue.global(qos: .background).async {
                guard error == nil else {
                    print("An error occured. Handle it here.")
                    //self.activityIndicator.stopAnimating()
                    onCompletion(.FAILED, nil)
                    return
                }
                
                guard let storefrontId = storefrontId else {
                    print("Handle the error - the callback didn't contain a storefront ID.")
                    //self.activityIndicator.stopAnimating()
                    //self.checkIfAppleMusicIsAvailable()
                    return
                }
                
                let trimmedId = String(storefrontId.prefix(5))
                onCompletion(.SUCCESS, trimmedId)
                //self.storeFrontId = String(trimmedId)
                
                //self.appleMusicFetchUsersPlaylists(storeFrontId: String(trimmedId))
                
                print("Success! The Storefront ID fetched was: \(trimmedId)")
            }
        }
        
    }
    
    func appleMusicFetchUsersPlaylists(storeFrontId: String, onCompletion: @escaping (FetchResults, MusicItemCollection<Playlist>?) -> Void) {
        
        //fetchedPlaylists.removeAll()
        
        Task {
        
            if let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists?") {
                        
                do {
                    let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
                    let playlistsResponse = try await dataRequest.response()
                    
                    let decoder = JSONDecoder()
                    
                    let playlists = try? decoder.decode(MusicItemCollection<Playlist>.self, from: playlistsResponse.data)
                    
                    onCompletion(.SUCCESS, playlists)
//                    for playlist in playlists! {
//                        appleMusicFetchMusicFromPlaylist(playlistId: playlist.id.rawValue, storeFrontId: storeFrontId, playlist: playlist, lastPlaylistsId: (playlists?.last!.id)!.rawValue, numberOfPlaylists: playlists!.count)
//                    }
                    //self.activityIndicator.stopAnimating()
                    //self.numberOfPlaylists = playlists?.count ?? 0
                    
                    //self.usersPlaylistCollectionView.reloadData()
                    
                } catch {
                    print("Error Occured When fetching users playlists")
                    onCompletion(.FAILED, nil)
                }
        
            }
        }
    }
    
    func appleMusicFetchMusicFromPlaylist(playlistId: String, storeFrontId: String, playlist: Playlist, onCompletion: @escaping (FetchResults, MusicItemCollection<Song>?) -> Void) {
        
        Task {
        
            var playlistTracksRequestURLComponents = URLComponents()
            playlistTracksRequestURLComponents.scheme = "https"
            playlistTracksRequestURLComponents.host = "api.music.apple.com"
            playlistTracksRequestURLComponents.path = "/v1/me/library/playlists/\(playlistId)/tracks"
            playlistTracksRequestURLComponents.queryItems = [URLQueryItem(name: "include", value: "catalog")]

            do {
            
                let playlistTracksRequestURL = playlistTracksRequestURLComponents.url!
                let playlistTracksRequest = MusicDataRequest(urlRequest: URLRequest(url: playlistTracksRequestURL))
                let playlistTracksResponse = try await playlistTracksRequest.response()

                let decoder = JSONDecoder()
                let playlistTracks = try decoder.decode(MusicItemCollection<Song>.self, from: playlistTracksResponse.data)
                                
//                var tracks: [Song] = []
//
//                for track in playlistTracks {
//
//                    tracks.append(track)
//
//                }
                
                
                DispatchQueue.main.async {
//                    //fetchedPlaylists.append(PlaylistWithMusicStructure(id: playlist.id, Playlist: playlist, Tracks: tracks))
//                    //self.usersPlaylistCollectionView.reloadData()
                    onCompletion(.SUCCESS, playlistTracks)
                }
                
            } catch {
                print("Error Occured When fetching users playlists")
                onCompletion(.FAILED, nil)
            }

        }
    }
    
    func checkIfAppleMusicIsAvailable(onCompletion: @escaping (MediaRequestResultReferences?) -> Void) {
                
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
            onCompletion(.authorized)
            
        } else if SKCloudServiceController.authorizationStatus() == .denied {
            
            onCompletion(.denied)
            
        } else if SKCloudServiceController.authorizationStatus() == .notDetermined {
            
            onCompletion(.notDetermined)
            
        } else if SKCloudServiceController.authorizationStatus() == .restricted {
            
            onCompletion(.restricted)
            
        }
        
    }
    
    func checkIfUserHasAppleMusicSubscription(onCompletion: @escaping (FetchResults?) -> Void) {
        
        mediaServiceController.requestCapabilities { capabilities, error in
            DispatchQueue.global(qos: .background).async {
                if capabilities.contains(.musicCatalogPlayback) {
                    // User has Apple Music account
                    onCompletion(.SUCCESS)
                }
                else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                    // User can sign up to Apple Music
                    onCompletion(.FAILED)
                }
            }
        }
        
    }
    
}
