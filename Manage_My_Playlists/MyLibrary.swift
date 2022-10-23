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
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        view.color = .black
        
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
    
    let dimmingBgView: UIView = {
       
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.clipsToBounds = true
        
        return view
    }()
    
    let containerForPopUpRequestView: UIView = {
       
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        
        return view
    }()
    
    let popUpRequestView: UIView = {
       
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7.5
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var closeRequestButton: UIButton = { //declare as lazy var to prevent 'self' warning
       
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15.0, weight: .semibold)), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeRequest), for: .touchUpInside)
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5 //Play with this setting to adjust intensity of the shadows (Changes the opacity of color)
        button.layer.shadowRadius = 3 //Play with this setting to adjust intensity of the shadows (Increases the shadow)
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return button
    }()
    
    let requestImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        //imageView.image = UIImage(named: <#T##String#>)
        
        return imageView
    }()
    
    let requestTitleLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 19.0, weight: .bold)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingMiddle
        label.textAlignment = .center
        label.clipsToBounds = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.3 //Play with this setting to adjust intensity of the shadows (Changes the opacity of color)
        label.layer.shadowRadius = 2.5 //Play with this setting to adjust intensity of the shadows (Increases the shadow)
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.text = "'MyLibrary' needs access to Apple Music to let you play your music"
        
        return label
    }()
    
    lazy var allowAccessButton: UIButton = { //declare as lazy var to prevent 'self' warning
       
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .systemPink //rgb(252, 60, 68)
        configuration.baseForegroundColor = .white
        configuration.title = "ALLOW ACCESS"
        
        let button = UIButton(configuration: configuration)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(allowAccess), for: .touchUpInside) //Sends user to apps settings
        
        button.clipsToBounds = false
        button.layer.shadowColor = UIColor.systemPink.cgColor
        button.layer.shadowOpacity = 0.75 //Play with this setting to adjust intensity of the shadows (Changes the opacity of color)
        button.layer.shadowRadius = 4 //Play with this setting to adjust intensity of the shadows (Increases the shadow)
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return button
    }()
    
    lazy var notNowButton: UIButton = { //declare as lazy var to prevent 'self' warning
       
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .lightGray.withAlphaComponent(0.75)
        configuration.baseForegroundColor = .darkGray
        configuration.title = "NOT NOW"
        
        let button = UIButton(configuration: configuration)
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(closeRequest), for: .touchUpInside) //Sends user to apps settings
        button.clipsToBounds = true
        
        return button
    }()
    
    public func showRequestElements(_ show: Bool) {
        
        self.dimmingBgView.isHidden = show ? true : false
        self.containerForPopUpRequestView.isHidden = show ? true : false
        self.popUpRequestView.isHidden = show ? true : false
        self.closeRequestButton.isHidden = show ? true : false
        self.requestImageView.isHidden = show ? true : false
        self.requestTitleLabel.isHidden = show ? true : false
        self.notNowButton.isHidden = show ? true : false
        self.allowAccessButton.isHidden = show ? true : false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = "Playlists"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        
        self.checkIfAppleMusicIsAvailable()
        
        view.addSubview(dimmingBgView)
        view.addSubview(containerForPopUpRequestView)
        containerForPopUpRequestView.addSubview(popUpRequestView)
        containerForPopUpRequestView.addSubview(closeRequestButton)
        popUpRequestView.addSubview(requestImageView)
        popUpRequestView.addSubview(requestTitleLabel)
        popUpRequestView.addSubview(notNowButton)
        popUpRequestView.addSubview(allowAccessButton)
        showRequestElements(false)
        setUpConstraints()
        
    }
    
    func setUpConstraints() {
        
        dimmingBgView.translatesAutoresizingMaskIntoConstraints = false
        
        dimmingBgView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimmingBgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dimmingBgView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dimmingBgView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        containerForPopUpRequestView.translatesAutoresizingMaskIntoConstraints = false
        
        containerForPopUpRequestView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        containerForPopUpRequestView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        containerForPopUpRequestView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 1.5).isActive = true
        containerForPopUpRequestView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        popUpRequestView.translatesAutoresizingMaskIntoConstraints = false
        
        popUpRequestView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        popUpRequestView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        popUpRequestView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 1.75).isActive = true
        popUpRequestView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        closeRequestButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeRequestButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeRequestButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeRequestButton.rightAnchor.constraint(equalTo: popUpRequestView.rightAnchor, constant: 15).isActive = true
        closeRequestButton.topAnchor.constraint(equalTo: popUpRequestView.topAnchor, constant: -15).isActive = true
        closeRequestButton.layer.cornerRadius = 20

        requestImageView.translatesAutoresizingMaskIntoConstraints = false
        
        requestImageView.topAnchor.constraint(equalTo: popUpRequestView.topAnchor, constant: 25).isActive = true
        requestImageView.leadingAnchor.constraint(equalTo: popUpRequestView.leadingAnchor, constant: 25).isActive = true
        requestImageView.trailingAnchor.constraint(equalTo: popUpRequestView.trailingAnchor, constant: -25).isActive = true
        requestImageView.bottomAnchor.constraint(equalTo: popUpRequestView.centerYAnchor, constant: -20).isActive = true
        
        requestTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        requestTitleLabel.topAnchor.constraint(equalTo: requestImageView.bottomAnchor, constant: 15).isActive = true
        requestTitleLabel.leadingAnchor.constraint(equalTo: popUpRequestView.leadingAnchor, constant: 30).isActive = true
        requestTitleLabel.trailingAnchor.constraint(equalTo: popUpRequestView.trailingAnchor, constant: -30).isActive = true
        requestTitleLabel.sizeToFit()
        
        notNowButton.translatesAutoresizingMaskIntoConstraints = false
        
        notNowButton.bottomAnchor.constraint(equalTo: popUpRequestView.bottomAnchor, constant: -20).isActive = true
        notNowButton.leadingAnchor.constraint(equalTo: popUpRequestView.leadingAnchor, constant: 20).isActive = true
        notNowButton.trailingAnchor.constraint(equalTo: popUpRequestView.trailingAnchor, constant: -20).isActive = true
        notNowButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        allowAccessButton.translatesAutoresizingMaskIntoConstraints = false
        
        allowAccessButton.bottomAnchor.constraint(equalTo: notNowButton.topAnchor, constant: -10).isActive = true
        allowAccessButton.leadingAnchor.constraint(equalTo: popUpRequestView.leadingAnchor, constant: 20).isActive = true
        allowAccessButton.trailingAnchor.constraint(equalTo: popUpRequestView.trailingAnchor, constant: -20).isActive = true
        allowAccessButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
    }
    
    func setPlaylistsCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        usersPlaylistCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        usersPlaylistCollectionView.register(usersPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: usersPlaylistCollectionViewCellID)
        usersPlaylistCollectionView.showsVerticalScrollIndicator = true
        usersPlaylistCollectionView.showsHorizontalScrollIndicator = false
        usersPlaylistCollectionView.backgroundColor = UIColor.clear
        usersPlaylistCollectionView.indicatorStyle = .default
        usersPlaylistCollectionView.isPagingEnabled = false
        usersPlaylistCollectionView.bounces = true
        //usersPlaylistCollectionView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
        usersPlaylistCollectionView.delegate = self
        usersPlaylistCollectionView.dataSource = self
        
        view.addSubview(usersPlaylistCollectionView)
        
        usersPlaylistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        usersPlaylistCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        usersPlaylistCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        usersPlaylistCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        usersPlaylistCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }

    func showPopUpRequestView() {
        
        showRequestElements(true)
        navigationController?.navigationBar.isHidden = true
        
        containerForPopUpRequestView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        //closeRequestButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        dimmingBgView.alpha = 0
        popUpRequestView.alpha = 0
        closeRequestButton.alpha = 0
        
        UIView.animate(withDuration: 0.2) { [self] in
            dimmingBgView.alpha = 1
            popUpRequestView.alpha = 1
            closeRequestButton.alpha = 1
            containerForPopUpRequestView.transform = CGAffineTransform.identity
            //closeRequestButton.transform = CGAffineTransform.identity
        }
                
    }
        
    @objc func allowAccess() {
        
        if SKCloudServiceController.authorizationStatus() == .notDetermined {

            SKCloudServiceController.requestAuthorization { _ in

                self.checkIfAppleMusicIsAvailable()

            }

        } else if SKCloudServiceController.authorizationStatus() == .restricted {

            //Sending user to apps settings
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
            
        } else if SKCloudServiceController.authorizationStatus() == .denied {
            
            //Sending user to apps settings
            if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
            
        }
        
    }
    
    @objc func closeRequest() {
        
        UIView.animate(withDuration: 0.2, animations: { [self] in
            
            containerForPopUpRequestView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            //closeRequestButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            popUpRequestView.alpha = 0
            dimmingBgView.alpha = 0
            closeRequestButton.alpha = 0

        }) { (success: Bool) in
            
            self.navigationController?.navigationBar.isHidden = false
            self.showRequestElements(false)
            
        }
        
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
                    fetchedPlaylists.append(PlaylistWithMusicStructure(id: playlist.id, Playlist: playlist, Tracks: tracks))
                    self.usersPlaylistCollectionView.reloadData()
                    
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

            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            self.activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            self.activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            self.activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
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
                    }
                }
            }
            
        } else if SKCloudServiceController.authorizationStatus() == .denied {
            
//            let alertController = UIAlertController(title: "To Play Music, You Have To Allow 'RebFit' to Access Your Music Library.", message: "RebFit requires your music library to let you to listen to music while you do your cardio session.", preferredStyle: .alert)
//
//            let settingsAction = UIAlertAction(title: "OK", style: .default) { (_) -> Void in
//                if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
//                    UIApplication.shared.open(appSettings)
//                }
//            }
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
//
//            alertController.addAction(cancelAction)
//            alertController.addAction(settingsAction)
//            self.present(alertController, animated: true)
            self.showPopUpRequestView()
            
        } else if SKCloudServiceController.authorizationStatus() == .notDetermined {

            self.showPopUpRequestView()
            
        } else if SKCloudServiceController.authorizationStatus() == .restricted {
            
            self.showPopUpRequestView()
            
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
        
        return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usersPlaylistCollectionViewCellID, for: indexPath) as! usersPlaylistCollectionViewCell
        cell.playlistNameLabel.text = fetchedPlaylists.reversed()[indexPath.row].Playlist.name
        DispatchQueue.main.async { [self] in
            
            URLSession.shared.dataTask(with: (fetchedPlaylists.reversed()[indexPath.row].Tracks.first?.artwork?.url(width: 500, height: 500))!) { (data, response, error) in
                
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
                
        return CGSize(width: (self.view.frame.width / 2) - 20, height: (self.view.frame.width / 2) + 50)
        
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
