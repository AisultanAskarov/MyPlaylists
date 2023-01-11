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
                
                GeometryReader { geo in
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        
                        VStack(spacing: 5) {
                            
                            //Playlist Arwork
                            Image(uiImage: viewModel.currentPlaylistsArtwork)
                                .playlistArtworkImageModifier(width: geo.size.width)
                            
                            //Playlist title
                            Text(viewModel.currentPlaylistsTitle)
                                .foregroundColor(.black)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                            
                            //Playlist subtitle
                            Text(viewModel.currentPlaylistsSubTitle)
                                .foregroundColor(.pink)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            
                            //Playlist caption
                            Text(viewModel.currentPlaylistsCaption)
                                .foregroundColor(.secondary)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            
                            //Play and Shuffle Buttons
                            HStack(alignment: .center, spacing: geo.size.width / 21.5) {
                                Button {
                                    //Some Action
                                    print("Play")
                                } label: {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.gray.opacity(0.25))
                                        .overlay {
                                            HStack(alignment: .center, spacing: 5) {
                                                Image("play.fill")
                                                    .playlistsPlayShuffleBtnsImageModifiers()
                                                Text("Play")
                                                    .foregroundColor(.pink)
                                                    .font(.callout)
                                            }
                                        }
                                }
                                .frame(width: geo.size.width - ((geo.size.width / 21.5) * 3), height: 42.5, alignment: .center)
                                
                                Button {
                                    //Some Action
                                    print("Shuffle")
                                } label: {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.gray.opacity(0.25))
                                        .overlay {
                                            HStack(alignment: .center, spacing: 5) {
                                                Image("shuffle")
                                                    .playlistsPlayShuffleBtnsImageModifiers()
                                                Text("Shuffle")
                                                    .foregroundColor(.pink)
                                                    .font(.callout)
                                            }
                                        }
                                }
                                .frame(width: geo.size.width - ((geo.size.width / 21.5) * 3), height: 42.5, alignment: .center)
                            }
                            .padding([.leading, .trailing], geo.size.width / 21.5)
                            
                            //Playlists Description
                            Text(viewModel.currentPlaylistsDescription)
                                .foregroundColor(.secondary)
                                .font(.callout)
                                .multilineTextAlignment(.center)
                            
                            //List
                            PlaylistsList()
//                            List(viewModel.filteredSongs) { song in
//                                TrackCell(coverImageUrl: song.artwork?.url(width: 256, height: 256)?.absoluteString ?? "", numberInOrder: String(song.trackNumber ?? 0), title: song.title, artistName: song.artistName)
//                                    .frame(height: 35.5)
//
//                            }
//                            .listStyle(.plain)
//                            .environment(\.defaultMinListRowHeight, 35.5)
//                            .listRowSeparator(.visible, edges: [.all])
//                            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic))
//                            .onSubmit(of: .search, {
//                                viewModel.search(with: query)
//                            })//: ONSUBMIT
//                            .onChange(of: query, perform: { newValue in
//                                viewModel.search(with: newValue)
//                                if newValue == "" {
//                                    isSearching = false
//                                } else {
//                                    isSearching = true
//                                }
//                            })//: ONCANGE
                            ///List

                        }//: VSTACK
                    }//: SCROLLVIEW
                }
            }
            
        }//: ZSTACK
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
        .onAppear {
            viewModel.getMusicForPlaylist { result in
                print(result)
                if result == .SUCCESS {
                    songsAreFetched = true
                    showActivityIndicator = false
                    viewModel.search(with: query)
                    print(viewModel.currentPlaylistsSongs)
                } else {
                    songsAreFetched = false
                    showActivityIndicator = false
                }
            }
        }//: ONAPPEAR
        .overlay {
            if showActivityIndicator == true {
                ProgressView()
                    .progressViewStyle(.circular)
                    .foregroundColor(.black.opacity(0.15))
                    .scaleEffect(1.75)
                    .ignoresSafeArea(.all)
                    .padding(0)
            }
            
            if viewModel.filteredSongs.count == 0, isSearching == true {
                EmptySearchList()
                    .ignoresSafeArea(.all)
            }
        }//:OVERLAY
        
    }
 
    @ViewBuilder
    func PlaylistsList() -> some View {
        
        VStack(alignment: .center, spacing: 2.5) {
            Divider()
            
            ForEach(viewModel.filteredSongs.indices, id: \.self) { index in
                TrackCell(coverImageUrl: viewModel.filteredSongs[index].artwork?.url(width: 256, height: 256)?.absoluteString ?? "", numberInOrder: String(index + 1), title: viewModel.filteredSongs[index].title, artistName: viewModel.filteredSongs[index].artistName)
                    .frame(height: 35.5)
            }//: FOREACH
        }//: VSTACK
        
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView()
    }
}
