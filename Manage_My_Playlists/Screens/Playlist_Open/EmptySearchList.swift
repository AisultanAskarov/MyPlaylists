//
//  EmptySearchList.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 9.01.2023.
//

import SwiftUI

struct EmptySearchList: View {
        
    var body: some View {
        Text("No Result")
            .foregroundColor(.gray.opacity(0.65))
            .font(.system(size: 20.0, weight: .semibold, design: .rounded))
    }
}

struct EmptySearchList_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchList()
    }
}
