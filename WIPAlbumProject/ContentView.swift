//
//  ContentView.swift
//  WIPAlbumProject
//
//  Created by Joseph Rees-Hill on 11/17/20.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    var body: some View {
        albums()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func albums() -> some View {
    let albums = get_albums()
    return VStack {
        HStack {
            album_art(album: albums[0])
            album_art(album: albums[1])
        }
        HStack {
            album_art(album: albums[2])
            album_art(album: albums[3])
        }
    }.padding(.all)
}

func album_art(album: MPMediaItemCollection) -> some View {
    let tap = TapGesture()
        .onEnded { _ in
            play(album: album)
        }
    let artwork = album.representativeItem!.artwork!
    return Image(uiImage: artwork.image(at: artwork.bounds.size)!)
        .resizable()
        .scaledToFit()
        .gesture(tap)
}
