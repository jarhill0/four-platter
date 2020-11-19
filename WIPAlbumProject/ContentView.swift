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
        main_view()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func albums_view(albums: [MPMediaItemCollection]) -> some View {
    VStack {
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

func grant_permissions_view() -> some View {
    VStack {
        Text(
            "Permissions not granted"
        ).font(.title).padding(.all)
        placeholder_view()
        Text(
            "Please grant access to your music library in Settings."
        ).multilineTextAlignment(.center).padding()
        Button("Go to Settings", action: OPEN_SETTINGS_ACTION)
            .padding()
            .font(.callout)
            .frame(minWidth: 260, maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding()
    }
}

func not_enough_albums_view() -> some View {
    VStack {
        Text(
            "Not enough albums"
        ).font(.title).padding(.all)
        placeholder_view()
        Text(
            "We couldn't find enough albums in your library. Try adding more full-length albums with artwork."
        ).multilineTextAlignment(.center).padding()
        Button("Go to Music", action: OPEN_MUSIC_ACTION)
            .padding()
            .font(.callout)
            .frame(minWidth: 260, maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(40)
            .padding()
    }
}

func placeholder_view() -> some View {
    VStack {
        HStack {
            Image("gradient-A").resizable().scaledToFit()
            Image("gradient-B").resizable().scaledToFit()
        }
        HStack {
            Image("gradient-D").resizable().scaledToFit()
            Image("gradient-C").resizable().scaledToFit()
        }
    }.padding(.all)
}

func main_view() -> some View {
    switch get_albums() {
    case let .four(albums):
        return AnyView(albums_view(albums: albums))
    case .not_enough:
        return AnyView(not_enough_albums_view())
    case .permission_denied:
        return AnyView(grant_permissions_view())
    }
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

let OPEN_SETTINGS_ACTION = {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

let OPEN_MUSIC_ACTION = {
    if let url = URL(string: "music://") {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
