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
}
