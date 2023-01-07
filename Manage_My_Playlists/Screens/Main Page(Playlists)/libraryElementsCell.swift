//
//  libraryElementsCell.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 23.10.2022.
//

import Foundation
import UIKit

class libraryElementsCell: UICollectionViewCell {
    
    let elementsIcon: UIImageView = {
       
        let image = UIImageView()
        image.backgroundColor = UIColor.white
        image.clipsToBounds = true
        image.tintColor = .systemPink
        image.contentMode = .center
        
        return image
    }()
    
    let elementsTitleLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "Artists"
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .regular)
        
        return label
    }()
    
    let underline: UIView = {
       
        let view = UIView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        
        return view
    }()
    
    let arrowIcon: UIImageView = {
       
        let image = UIImageView()
        image.backgroundColor = UIColor.white
        image.clipsToBounds = true
        image.contentMode = .center
        image.image = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17.0, weight: .bold))
        image.tintColor = UIColor.lightGray
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        addSubview(elementsIcon)
        addSubview(elementsTitleLabel)
        addSubview(arrowIcon)
        addSubview(underline)
        
        elementsIcon.translatesAutoresizingMaskIntoConstraints = false
        elementsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
        
    }
    
    func setConstraints() {
        
        elementsIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        elementsIcon.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        elementsIcon.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        elementsIcon.widthAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
        arrowIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        arrowIcon.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        arrowIcon.widthAnchor.constraint(equalToConstant: self.frame.height - 5).isActive = true
        arrowIcon.heightAnchor.constraint(equalToConstant: self.frame.height - 5).isActive = true

        underline.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        underline.leadingAnchor.constraint(equalTo: elementsIcon.trailingAnchor, constant: 5).isActive = true
        underline.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        underline.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        elementsTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        elementsTitleLabel.leadingAnchor.constraint(equalTo: elementsIcon.trailingAnchor, constant: 5).isActive = true
        elementsTitleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -5).isActive = true
        elementsTitleLabel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
