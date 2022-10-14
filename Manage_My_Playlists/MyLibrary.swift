//
//  ViewController.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.10.2022.
//

import UIKit
import StoreKit
import MediaPlayer
import MusicKit

class MyLibrary: UIViewController {

    let activityIndicator: UIActivityIndicatorView = {
       
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.style = UIActivityIndicatorView.Style.large
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.35)
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    let serviceController = SKCloudServiceController()
    var storeFrontId: String? = ""
    
    var fetchedPlaylists: [PlaylistWithMusicStructure] = []
    var selectedPlaylist: [PlaylistWithMusicStructure] = []
    var selectedPlaylistIndex: [IndexPath] = []
    
    var usersPlaylistCollectionView: UICollectionView!
    var usersPlaylistCollectionViewCellID = "PlaylistCell"
    
    var playlistsAreFetched: Bool = false
    var numberOfPlaylists: Int = 0 {
        didSet {
            playlistsAreFetched = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationItem.title = "Running Section"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor.white
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        SKCloudServiceController.requestAuthorization { _ in
            
            self.checkIfAppleMusicIsAvailable()
            
        }
        
    }
    
    func setPlaylistsCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        usersPlaylistCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        usersPlaylistCollectionView.register(usersPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: usersPlaylistCollectionViewCellID)
        usersPlaylistCollectionView.showsVerticalScrollIndicator = false
        usersPlaylistCollectionView.showsHorizontalScrollIndicator = true
        usersPlaylistCollectionView.backgroundColor = UIColor.clear
        usersPlaylistCollectionView.indicatorStyle = .default
        usersPlaylistCollectionView.isPagingEnabled = false
        usersPlaylistCollectionView.bounces = false
        usersPlaylistCollectionView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
        usersPlaylistCollectionView.delegate = self
        usersPlaylistCollectionView.dataSource = self
        
        view.addSubview(usersPlaylistCollectionView)
        
        usersPlaylistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        usersPlaylistCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        usersPlaylistCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        usersPlaylistCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        usersPlaylistCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }

}


//MARK: -Apple music requests

extension MyLibrary: SKCloudServiceSetupViewControllerDelegate {
    
    @available(iOS 15.0, *)
    func appleMusicFetchUsersPlaylists(storeFrontId: String) {
        
        Task {
        
            if let url = URL(string: "https://api.music.apple.com/v1/me/library/playlists?") {
                        
                do {
                    let dataRequest = MusicDataRequest(urlRequest: URLRequest(url: url))
                    let playlistsResponse = try await dataRequest.response()
                    
                    let decoder = JSONDecoder()
                    
                    let playlists = try? decoder.decode(MusicItemCollection<Playlist>.self, from: playlistsResponse.data)
                    
                    for playlist in playlists! {
                        appleMusicFetchMusicFromPlaylist(playlistId: playlist.id.rawValue, storeFrontId: storeFrontId, playlist: playlist, lastPlaylistsId: (playlists?.last!.id)!.rawValue, numberOfPlaylists: playlists!.count)
                    }
                    self.activityIndicator.stopAnimating()
                    self.numberOfPlaylists = playlists?.count ?? 0
                    
                    //MARK: -Enabling music controls
                    self.setPlaylistsCollectionView()
                    self.usersPlaylistCollectionView.reloadData()
                    
                } catch { print("Error Occured When fetching users playlists") }
        
            }
        }
    }
    
    @available(iOS 15.0, *)
    func appleMusicFetchMusicFromPlaylist(playlistId: String, storeFrontId: String, playlist: Playlist, lastPlaylistsId: String, numberOfPlaylists: Int) {
        
        fetchedPlaylists.removeAll()
        
        Task {
        
            var playlistTracksRequestURLComponents = URLComponents()
            playlistTracksRequestURLComponents.scheme = "https"
            playlistTracksRequestURLComponents.host = "api.music.apple.com"
            playlistTracksRequestURLComponents.path = "/v1/me/library/playlists/\(playlistId)/tracks"
            //https://api.music.apple.com/v1/catalog/{STOREFRONT}/playlists/{PLAYLIST ID}?include=tracks,albums
            playlistTracksRequestURLComponents.queryItems = [URLQueryItem(name: "include", value: "catalog")]

            do {
            
                let playlistTracksRequestURL = playlistTracksRequestURLComponents.url!
                let playlistTracksRequest = MusicDataRequest(urlRequest: URLRequest(url: playlistTracksRequestURL))
                let playlistTracksResponse = try await playlistTracksRequest.response()

                let decoder = JSONDecoder()
                let playlistTracks = try decoder.decode(MusicItemCollection<Song>.self, from: playlistTracksResponse.data)
                                
                var tracks: [Song] = []
                
                for track in playlistTracks {
                    
                    tracks.append(track)
                    
                }
                
                DispatchQueue.main.async { [self] in
                    //setCollectionView()
                    fetchedPlaylists.append(PlaylistWithMusicStructure(id: playlist.id, Playlist: playlist, Tracks: tracks))
                    self.usersPlaylistCollectionView.reloadData()
//                    selectedPlaylistIndex.removeAll()
//                    selectedPlaylistIndex.append(IndexPath(row: 0, section: 0))
//                    selectedPlaylist.removeAll()
//                    selectedPlaylist.append(fetchedPlaylists.reversed().first!)
                    
                }
                
            } catch { print("Error Occured When fetching users playlists") }

        }
    }
    
    @available(iOS 15.0, *)
    func appleMusicFetchStorefrontRegion() {
        
        serviceController.requestStorefrontIdentifier { storefrontId, error in
          
            DispatchQueue.global(qos: .background).async {
                guard error == nil else {
                    print("An error occured. Handle it here.")
                    self.activityIndicator.stopAnimating()
                    self.checkIfAppleMusicIsAvailable()
                    return
                }
                
                guard let storefrontId = storefrontId else {
                    print("Handle the error - the callback didn't contain a storefront ID.")
                    self.activityIndicator.stopAnimating()
                    self.checkIfAppleMusicIsAvailable()
                    return
                }
                
                let trimmedId = storefrontId.prefix(5)
                self.storeFrontId = String(trimmedId)
                
                self.appleMusicFetchUsersPlaylists(storeFrontId: String(trimmedId))
                
                print("Success! The Storefront ID fetched was: \(trimmedId)")
            }
        }
        
    }
    
    @available(iOS 15.0, *)
    func checkIfAppleMusicIsAvailable() {
        
        if SKCloudServiceController.authorizationStatus() == .authorized {

            self.activityIndicator.startAnimating()
            
            serviceController.requestCapabilities { capabilities, error in
                DispatchQueue.global(qos: .background).async {
                    if capabilities.contains(.musicCatalogPlayback) {
                        // User has Apple Music account
                        print("fe")
                        self.appleMusicFetchStorefrontRegion()
                    }
                    else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                        // User can sign up to Apple Music
                        self.activityIndicator.stopAnimating()
                        self.showAppleMusicSignup()
//                        self.backGroundButtonForMusicContainer.addTarget(self, action: #selector(self.showAppleMusicSignup), for: .touchUpInside)
//                        self.activityIndicator.stopAnimating()
//                        self.activityIndicator.removeFromSuperview()
//                        self.backGroundButtonForMusicContainer.isUserInteractionEnabled = true
//                        self.containerViewForCurrentPlayingMusicController.isUserInteractionEnabled = true
                    }
                }
            }
            
        } else if SKCloudServiceController.authorizationStatus() == .denied {
            
            let alertController = UIAlertController(title: "To Play Music, You Have To Allow 'RebFit' to Access Your Music Library.", message: "RebFit requires your music library to let you to listen to music while you do your cardio session.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true)
            
        } else if SKCloudServiceController.authorizationStatus() == .notDetermined {

            SKCloudServiceController.requestAuthorization { _ in
                
                self.checkIfAppleMusicIsAvailable()
                
            }
            
        } else if SKCloudServiceController.authorizationStatus() == .restricted {
            
            let alertController = UIAlertController(title: "To Play Music, You Have To Allow 'RebFit' to Access Your Music Library.", message: "RebFit requires your music library to let you to listen to music while you do your cardio session.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
                if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true)
            
        }
        
    }
    
    @objc func showAppleMusicSignup() {
        
            let vc = SKCloudServiceSetupViewController()
            vc.delegate = self

            let options: [SKCloudServiceSetupOptionsKey: Any] = [.action: SKCloudServiceSetupAction.subscribe, .messageIdentifier: SKCloudServiceSetupMessageIdentifier.playMusic]
                
            vc.load(options: options) { success, error in
                if success {
                    self.present(vc, animated: true)
                }
            }

        }
    
}

extension MyLibrary: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedPlaylists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usersPlaylistCollectionViewCellID, for: indexPath) as! usersPlaylistCollectionViewCell
        cell.playlistNameLabel.text = fetchedPlaylists.reversed()[indexPath.row].Playlist.name
        DispatchQueue.main.async { [self] in
            
            URLSession.shared.dataTask(with: (fetchedPlaylists.reversed()[indexPath.row].Playlist.artwork?.url(width: 100, height: 100))!) { (data, response, error) in
                
                //Download hit error returning out
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.imageViewMusic.image = UIImage(data: data!)
                }
                
            }.resume()
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.view.frame.width / 2) - 30, height: (self.view.frame.width / 2) + 30)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //MARK: -ActionForCustomCells
        
        if let _ = collectionView.cellForItem(at: indexPath) as? usersPlaylistCollectionViewCell {
            
            
            
        }
        
    }
    
}

struct PlaylistWithMusicStructure: MusicItem {
    
    var id: MusicItemID
    var Playlist: Playlist
    var Tracks: [Song]
    
}
