//
//  usersPlaylistCollectionViewCell.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 14.10.2022.
//

import UIKit

class usersPlaylistCollectionViewCell: UICollectionViewCell {
    
    let imageViewMusic: UIImageView = {
       
        let image = UIImageView()
        image.backgroundColor = UIColor.white
        image.clipsToBounds = true
        image.image = UIImage(named: "music cover")
        image.layer.cornerRadius = 7.5
        
        return image
    }()
    
    let playlistNameLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Fake"
        label.font = UIFont.systemFont(ofSize: 16.5, weight: .regular)
        label.clipsToBounds = false
        label.layer.shadowColor = UIColor.black.withAlphaComponent(1.0).cgColor
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 6
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return label
    }()
    
    let playlistsCuratorName: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.systemGray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "The Tech Thieves"
        label.font = UIFont.systemFont(ofSize: 16.5, weight: .regular)
        label.clipsToBounds = false
        label.layer.shadowColor = UIColor.black.withAlphaComponent(1.0).cgColor
        label.layer.shadowOpacity = 0.65
        label.layer.shadowRadius = 6
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        addSubview(imageViewMusic)
        addSubview(playlistNameLabel)
        addSubview(playlistsCuratorName)
        
        imageViewMusic.translatesAutoresizingMaskIntoConstraints = false
        playlistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playlistsCuratorName.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
        
    }
    
    func setConstraints() {
        
        imageViewMusic.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        imageViewMusic.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        imageViewMusic.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageViewMusic.heightAnchor.constraint(equalToConstant: self.frame.width - 10).isActive = true
        
        playlistNameLabel.topAnchor.constraint(equalTo: imageViewMusic.bottomAnchor, constant: 10).isActive = true
        playlistNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        playlistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        playlistNameLabel.sizeToFit()
        
        playlistsCuratorName.topAnchor.constraint(equalTo: playlistNameLabel.bottomAnchor, constant: 3.5).isActive = true
        playlistsCuratorName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        playlistsCuratorName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        playlistsCuratorName.sizeToFit()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
