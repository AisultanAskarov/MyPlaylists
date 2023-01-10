//
//  ImageModifiers.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 8.01.2023.
//

import SwiftUI

extension Image {
    
    func navBtnModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .foregroundColor(.gray.opacity(0.25))
    }
    
    func trackCoverImageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 7.5))
            .frame(width: 45, height: 45)
    }
    
    func trackCoverPlaceholderModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 7.5))
            .frame(width: 45, height: 45)
            .foregroundColor(.gray.opacity(0.35))
    }
    
    func trackCellEllipseModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 15, alignment: .center)
            .foregroundColor(.black)
    }
    
}
