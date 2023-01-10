//
//  ImageView.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 10.01.2023.
//

import SwiftUI

struct ImageView: View {
    
    let url: String
    let placeholder: String
    
    @ObservedObject var imageLoader = ImageLoader()
    
    init(url: String, placeholder: String = "playlist_artwork_placeholder") {
        self.url = url
        self.placeholder = placeholder
        self.imageLoader.downloadImage(url: url)
    }
    
    var body: some View {
        
        if let data = self.imageLoader.downloadedData {
            return AnyView(Image(uiImage: (UIImage(data: data) ?? UIImage(named: "playlist_artwork_placeholder"))!).trackCoverImageModifier())
        } else {
            return AnyView(Image("playlist_artwork_placeholder").trackCoverPlaceholderModifier())
        }
        
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(url: "")
    }
}
