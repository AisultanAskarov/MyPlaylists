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
import SwiftUI

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
    
    let dimmingBgView: UIView = {
       
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.clipsToBounds = true
        
        return view
    }()
    
    let dimmingNavView: UIView = {
       
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
        button.addTarget(self, action: #selector(closePopUpRequestView), for: .touchUpInside)
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
        imageView.contentMode = .center
        imageView.image = UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 150, weight: .medium))
        imageView.tintColor = .systemPink
        
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
        button.addTarget(self, action: #selector(closePopUpRequestView), for: .touchUpInside) //Sends user to apps settings
        button.clipsToBounds = true
        
        return button
    }()
    
    public func hideRequestElements(_ hide: Bool) {
        
        self.dimmingBgView.isHidden = hide
        self.dimmingNavView.isHidden = hide
        self.containerForPopUpRequestView.isHidden = hide
        self.popUpRequestView.isHidden = hide
        self.closeRequestButton.isHidden = hide
        self.requestImageView.isHidden = hide
        self.requestTitleLabel.isHidden = hide
        self.notNowButton.isHidden = hide
        self.allowAccessButton.isHidden = hide
        
    }
    
    let libraryElementsArray: [LibraryElementsStructure] = [LibraryElementsStructure(title: "Artists", icon: "music.mic"), LibraryElementsStructure(title: "Albums", icon: "square.stack"), LibraryElementsStructure(title: "Songs", icon: "music.note"), LibraryElementsStructure(title: "Genres", icon: "guitars"), LibraryElementsStructure(title: "Compilations", icon: "person.2.crop.square.stack"), LibraryElementsStructure(title: "Composers", icon: "music.quarternote.3"), LibraryElementsStructure(title: "Downloaded", icon: "arrow.down.circle")]
    
    let headerId = "playlistsHeader"
    let libraryElementsCellId = "libraryElementsCellId"
    
    var usersPlaylistCollectionView: UICollectionView!
    var usersPlaylistCollectionViewCellID = "PlaylistCell"
    
    var playlistsAreFetched: Bool = false
    var numberOfPlaylists: Int = 0 {
        didSet {
            if numberOfPlaylists > 0 {
                playlistsAreFetched = true
            }
        }
    }
    
    private var viewModel = MediaContentManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Playlists"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true

        view.addSubview(activityIndicator)
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        self.activityIndicator.startAnimating()
        
        getPlaylists()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func getPlaylists() {
        
        viewModel.getPlaylists { [self] result  in
            DispatchQueue.main.async { [self] in
                setPlaylistsCollectionView()
                activityIndicator.stopAnimating()
            }
            
            switch result {
                
            case .SUCCESS:
                DispatchQueue.main.async { [self] in
                    usersPlaylistCollectionView.reloadData()
                }
            case .FAILED:
                //Show Try again Popup
                print("failed")
            case .USERHASNOSUBSCRIPTION:
                showAppleMusicSignup()
            case .denied:
                showPopUpRequestView()
            case .restricted:
                showPopUpRequestView()
            case .notDetermined:
                showPopUpRequestView()
            }
            
        }
    }
    
    func setUpRequestView() {
        
        navigationController?.navigationBar.addSubview(dimmingNavView)
        view.addSubview(dimmingBgView)
        view.addSubview(containerForPopUpRequestView)
        containerForPopUpRequestView.addSubview(popUpRequestView)
        containerForPopUpRequestView.addSubview(closeRequestButton)
        popUpRequestView.addSubview(requestImageView)
        popUpRequestView.addSubview(requestTitleLabel)
        popUpRequestView.addSubview(notNowButton)
        popUpRequestView.addSubview(allowAccessButton)
        
        dimmingNavView.translatesAutoresizingMaskIntoConstraints = false
        
        dimmingNavView.topAnchor.constraint(equalTo: (navigationController?.navigationBar.topAnchor)!).isActive = true
        dimmingNavView.bottomAnchor.constraint(equalTo: (navigationController?.navigationBar.bottomAnchor)!).isActive = true
        dimmingNavView.leadingAnchor.constraint(equalTo: (navigationController?.navigationBar.leadingAnchor)!).isActive = true
        dimmingNavView.trailingAnchor.constraint(equalTo: (navigationController?.navigationBar.trailingAnchor)!).isActive = true

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
        
        requestTitleLabel.topAnchor.constraint(equalTo: requestImageView.bottomAnchor, constant: 20).isActive = true
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
        usersPlaylistCollectionView.register(libraryElementsCell.self, forCellWithReuseIdentifier: libraryElementsCellId)
        usersPlaylistCollectionView.register(usersPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: usersPlaylistCollectionViewCellID)
        usersPlaylistCollectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        usersPlaylistCollectionView.showsVerticalScrollIndicator = true
        usersPlaylistCollectionView.showsHorizontalScrollIndicator = false
        usersPlaylistCollectionView.backgroundColor = UIColor.clear
        usersPlaylistCollectionView.indicatorStyle = .default
        usersPlaylistCollectionView.isPagingEnabled = false
        usersPlaylistCollectionView.bounces = true
        usersPlaylistCollectionView.delegate = self
        usersPlaylistCollectionView.dataSource = self
        usersPlaylistCollectionView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
        view.insertSubview(usersPlaylistCollectionView, at: 0)
        
        usersPlaylistCollectionView.translatesAutoresizingMaskIntoConstraints = false
        usersPlaylistCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        usersPlaylistCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        usersPlaylistCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        usersPlaylistCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }

    func showPopUpRequestView() {
        
        setUpRequestView()
        hideRequestElements(false)
        
        containerForPopUpRequestView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        dimmingNavView.alpha = 0
        dimmingBgView.alpha = 0
        popUpRequestView.alpha = 0
        closeRequestButton.alpha = 0
        
        UIView.animate(withDuration: 0.2) { [self] in
            dimmingNavView.alpha = 1
            dimmingBgView.alpha = 1
            popUpRequestView.alpha = 1
            closeRequestButton.alpha = 1
            containerForPopUpRequestView.transform = CGAffineTransform.identity
        }
                
    }
    
    @objc func closePopUpRequestView() {
        
        UIView.animate(withDuration: 0.2, animations: { [self] in
            
            containerForPopUpRequestView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            dimmingNavView.alpha = 0
            popUpRequestView.alpha = 0
            dimmingBgView.alpha = 0
            closeRequestButton.alpha = 0

        }) { (success: Bool) in
            
            self.navigationController?.navigationBar.isHidden = false
            self.hideRequestElements(true)
            self.dimmingBgView.removeFromSuperview()
            self.containerForPopUpRequestView.removeFromSuperview()
            
        }
        
    }
        
    @objc func allowAccess() {
        
        if SKCloudServiceController.authorizationStatus() == .notDetermined {

            SKCloudServiceController.requestAuthorization { _ in

                self.getPlaylists()

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
    
}


//MARK: -Apple music requests

extension MyLibrary: SKCloudServiceSetupViewControllerDelegate {
    
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var numberOfItems: Int? = nil

        if section == 0 {
            numberOfItems = libraryElementsArray.count
        } else if section == 1 {
            numberOfItems = viewModel.playlists.count
        }

        return numberOfItems ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var insets: UIEdgeInsets? = nil
        
        if section == 0 {
            insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        } else if section == 1 {
            insets = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        }
        
        return insets ?? UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var headerSize: CGSize? = nil
        
        if section == 0 {
            headerSize = CGSize(width: collectionView.bounds.width, height: 0)
        } else if section == 1 {
            headerSize = CGSize(width: collectionView.bounds.width, height: 60)
        }
        
        return headerSize ?? CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! HeaderView

        if indexPath.section == 0 {
            headerView.titleLabel.removeFromSuperview()
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: libraryElementsCellId, for: indexPath) as! libraryElementsCell
            cell.elementsTitleLabel.text = libraryElementsArray[indexPath.row].title
            cell.elementsIcon.image = UIImage(systemName: libraryElementsArray[indexPath.row].icon, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24.0, weight: .medium))
            
            return cell
            
        } else if indexPath.section == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usersPlaylistCollectionViewCellID, for: indexPath) as! usersPlaylistCollectionViewCell
            cell.playlistNameLabel.text = viewModel.playlists[indexPath.row]?.Playlist?.name
            DispatchQueue.main.async { [self] in
                
                if viewModel.playlists[indexPath.row]?.Playlist?.artwork != nil {
                    
                    URLSession.shared.dataTask(with: (viewModel.playlists[indexPath.row]?.Playlist?.artwork?.url(width: 500, height: 500))!) { (data, response, error) in
                        
                        //Download hit error returning out
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            cell.imageViewMusic.image = UIImage(data: data!)
                        }
                        
                    }.resume()
                    
                } else {
                    cell.imageViewMusic.image = UIImage(named: "playlist_artwork_placeholder")
                }
                
            }
            
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        var cellSize: CGSize? = nil
        
        if indexPath.section == 0 {
            cellSize = CGSize(width: (self.view.frame.width - 20), height: 45)
        } else if indexPath.section == 1 {
            cellSize = CGSize(width: (self.view.frame.width / 2) - 20, height: (self.view.frame.width / 2) + 50)
        }
        
        return cellSize ?? CGSize(width: (self.view.frame.width / 2) - 20, height: (self.view.frame.width / 2) + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //MARK: -ActionForCustomCells
        
        if let _ = collectionView.cellForItem(at: indexPath) as? usersPlaylistCollectionViewCell {
            
            //Moving To Playlist View
            
            let host = UIHostingController(rootView: PlaylistView())
            self.navigationController?.pushViewController(host, animated: true)
            
        } else if let _ = collectionView.cellForItem(at: indexPath) as? libraryElementsCell {
            
        }
        
    }
    
}

struct LibraryElementsStructure {
    
    var title: String
    var icon: String
    
}

struct PlaylistWithMusicStructure {
        
    var Playlist: Playlist?
    var Tracks: MusicItemCollection<Song>?
    
}
