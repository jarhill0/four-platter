//
//  ContentView.swift
//  Four Platter
//
//  Created by Joseph Rees-Hill on 11/17/20.
//

import MediaPlayer
import SwiftUI

struct ContentView: View {
    @State private var albums: AlbumResult = get_albums()
    func refresh_albums() {
        self.albums = get_albums()
    }
    var body: some View {
        switch self.albums {
        case AlbumResult.four(let albums):
            return AnyView(
                albums_view(
                    albums: albums,
                    contentView: self
                )
            )
        case AlbumResult.not_enough:
            return AnyView(not_enough_albums_view())
        case AlbumResult.permission_denied:
            request_permission(self)
            return AnyView(grant_permissions_view())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func albums_view(
    albums: [MPMediaItemCollection],
    contentView: ContentView
) -> some View {
    return NavigationStack {
        albums_square(albums: albums)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    refresh_button(contentView: contentView)
                }
            }
    }
}

func albums_square(albums: [MPMediaItemCollection]) -> some View {
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

func refresh_button(contentView: ContentView) -> some View {
    Button(action: contentView.refresh_albums) {
        Label {
            Text("Load new selection")
        } icon: {
            Image(systemName: "arrow.clockwise")
                .padding()
        }
    }.labelStyle(IconOnlyLabelStyle())
}

func grant_permissions_view() -> some View {
    let button_text = "Go to Settings"
    let button = Button(
        action: OPEN_SETTINGS_ACTION,
        label: {
            Text("\(button_text) \(Image(systemName: "arrow.up.right"))")
                .padding(
                    EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50)
                )
                .accessibilityLabel(button_text)
        },
    )

    return VStack {
        placeholder_view()
        Text(
            "Permissions not granted"
        ).font(.title).multilineTextAlignment(.center)
        Text(
            "Please grant access to your music library in Settings."
        ).multilineTextAlignment(.center).padding()
        if #available(iOS 26.0, *) {
            button.buttonStyle(.glassProminent)
        } else {
            button.buttonStyle(.borderedProminent)
        }
    }
}

func not_enough_albums_view() -> some View {
    let button_text = "Open Music"
    let button = Button(
        action: OPEN_MUSIC_ACTION,
        label: {
            Text("\(button_text) \(Image(systemName: "arrow.up.right"))")
                .padding(
                    EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50)
                )
                .accessibilityLabel(button_text)
        },
    )

    return VStack {
        placeholder_view()
        Text(
            "Not enough albums"
        ).font(.title).multilineTextAlignment(.center)
        Text(
            "We couldn't find enough albums in your library. Try adding more full-length albums with artwork."
        ).multilineTextAlignment(.center).padding()
        if #available(iOS 26.0, *) {
            button.buttonStyle(.glassProminent)
        } else {
            button.buttonStyle(.borderedProminent)
        }
    }
}

func placeholder_gradient(_ linearGradient: LinearGradient) -> some View {
    linearGradient.aspectRatio(
        CGSize(width: 1, height: 1),
        contentMode: .fill
    )
    .scaledToFit()
}

func placeholder_view() -> some View {
    VStack {
        HStack {
            placeholder_gradient(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("gradient-color-A"), Color("gradient-color-B"),
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            placeholder_gradient(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("gradient-color-B"), Color("gradient-color-C"),
                    ]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
            )
        }
        HStack {
            placeholder_gradient(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("gradient-color-D"), Color("gradient-color-A"),
                    ]),
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
            )
            placeholder_gradient(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("gradient-color-C"), Color("gradient-color-D"),
                    ]),
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                )
            )
        }
    }.padding(.all)
}

func album_art(album: MPMediaItemCollection) -> some View {
    let haptics = UIImpactFeedbackGenerator(style: .medium)
    haptics.prepare()

    let album_selected = {
        haptics.impactOccurred()
        play(album: album)
    }
    let artwork = album.representativeItem!.artwork!
    let title = album.representativeItem!.albumTitle!
    return Button(action: album_selected) {
        Label {
            Text(title)
        } icon: {
            Image(uiImage: artwork.image(at: artwork.bounds.size)!)
                .resizable()
                .scaledToFit()
        }
    }.labelStyle(IconOnlyLabelStyle())
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
