//
//  TrackCell.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 10.01.2023.
//

import SwiftUI

struct TrackCell: View {
    
    @State var coverImageUrl: String
    @State var numberInOrder: String
    @State var title: String
    @State var artistName: String
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            ImageView(url: coverImageUrl, placeholder: "playlist_artwork_placeholder")
            
            Text(numberInOrder)
                .font(.system(size: 20.0, weight: .bold, design: .default))
                .lineLimit(1)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(5.5)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Text(artistName)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }//:VSTACK
            
            Spacer()
            
            Button {
                //Some Action
                print("1")
            } label: {
                Image(systemName: "ellipsis")
                    .trackCellEllipseModifier()
            }
            .padding(10)

            
        }//: HSTACK
        //.padding()
        
    }
    
}

struct TrackCell_Previews: PreviewProvider {
    static var previews: some View {
        TrackCell(coverImageUrl: "https://media.istockphoto.com/id/931643150/vector/picture-icon.jpg?s=612x612&w=0&k=20&c=St-gpRn58eIa8EDAHpn_yO4CZZAnGD6wKpln9l3Z3Ok=", numberInOrder: "1", title: "Insomnia", artistName: "Akha")
    }
}
