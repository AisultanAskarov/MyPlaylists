//
//  HeaderView.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 23.10.2022.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    let titleLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = "Your Playlists"
        label.font = UIFont.systemFont(ofSize: 25.0, weight: .bold)

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        titleLabel.sizeToFit()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


