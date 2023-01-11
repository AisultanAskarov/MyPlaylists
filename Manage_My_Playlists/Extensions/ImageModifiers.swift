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
    
    func playlistArtworkImageModifier(width: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 6.5))
            .frame(width: width - 140, height: width - 140, alignment: .center)
    }
    
    func playlistsPlayShuffleBtnsImageModifiers() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 10, height: 10, alignment: .center)
            .foregroundColor(.pink)
    }
    
    func trackCoverImageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 6.5))
            .frame(width: 47.5, height: 47.5)
    }
    
    func trackCoverPlaceholderModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 6.5))
            .frame(width: 47.5, height: 47.5)
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
