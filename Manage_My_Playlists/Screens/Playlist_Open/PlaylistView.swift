//
//  PlaylistView.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 8.01.2023.
//

import SwiftUI

struct PlaylistView: View {
    
    //MARK: -PROPERTY
    
    //arrow.down
    //ellipsis
    
    var body: some View {
        
        VStack {
            Text("2")
        }
        .navigationTitle("")
        .toolbar {
            HStack(alignment: .center, spacing: 7.5) {
                Button {
                    print("")
                } label: {
                    Circle()
                        .fill(.gray.opacity(0.25))
                        .frame(width: 27.5, height: 27.5)
                        .overlay {
                            Image(systemName: "arrow.down")
                                .frame(maxWidth: 20, maxHeight: 20)
                                .foregroundColor(.pink)
                                .padding()
                        }
                }

            }
        }
    }
    
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
