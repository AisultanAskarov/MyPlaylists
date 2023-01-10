//
//  PlaylistView.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 8.01.2023.
//

import SwiftUI

struct PlaylistView: View {
    
    //MARK: -PROPERTY
    
    @StateObject var viewModel = MediaContentManager.shared
    
    @State var songsAreFetched: Bool = false
    @State var showActivityIndicator: Bool = true
    @State var isSearching: Bool = false
    @State var query = ""
    
    var body: some View {
        
        ZStack {
            
            if songsAreFetched == true {
                
                List(isSearching ? viewModel.currentPlaylistsSongs: viewModel.filteredSongs) { song in
                    TrackCell(coverImageUrl: song.artwork?.url(width: 256, height: 256)?.absoluteString ?? "", numberInOrder: String(song.trackNumber ?? 0), title: song.title, artistName: song.artistName)
                }
                .listStyle(.plain)
                
            }
            
            if showActivityIndicator == true {
                ProgressView()
                    .progressViewStyle(.circular)
                    .foregroundColor(.black.opacity(0.15))
                    .scaleEffect(1.75)
                    .ignoresSafeArea(.all)
                    .padding(0)
            }
            
            if viewModel.filteredSongs.isEmpty, isSearching == true {
                EmptySearchList()
            }
            
        }//: ZSTACK
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic))
        .toolbar {
            HStack(alignment: .center, spacing: 7.5) {
                Button {
                    print("")
                } label: {
                    Circle()
                        .fill(.gray.opacity(0.15))
                        .frame(width: 30, height: 30)
                        .overlay {
                            Image(systemName: "arrow.down")
                                .font(.system(size: 13.0, weight: .semibold))
                                .foregroundColor(.pink)
                                .padding()
                        }
                }
                
                Button {
                    print("")
                } label: {
                    Circle()
                        .fill(.gray.opacity(0.15))
                        .frame(width: 30, height: 30)
                        .overlay {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 13.0, weight: .semibold))
                                .foregroundColor(.pink)
                                .padding()
                        }
                }

            }
        } //: TOOLBAR
        .onSubmit(of: .search, {
            viewModel.search()
        })
        .onChange(of: query, perform: { newValue in
            viewModel.search()
            if newValue == "" {
                isSearching = false
            } else {
                isSearching = true
            }
        })//: ONCANGE
        .onAppear {
            viewModel.getMusicForPlaylist { result in
                print(result)
                if result == .SUCCESS {
                    songsAreFetched = true
                    showActivityIndicator = false
                    viewModel.search()
                    print(viewModel.currentPlaylistsSongs)
                } else {
                    songsAreFetched = false
                    showActivityIndicator = false
                }
            }
        }//: ONAPPEAR
        .overlay {
            
        }//:OVERLAY
        
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
