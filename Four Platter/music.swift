//
//  music.swift
//  Four Platter
//
//  Created by Joseph Rees-Hill on 11/18/20.
//

import Foundation
import MediaPlayer

enum AlbumResult {
    case four([MPMediaItemCollection])
    case not_enough
    case permission_denied
}

func play(album: MPMediaItemCollection) {
    let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
    musicPlayer.setQueue(with: album)
    musicPlayer.play()
}

func get_albums() -> AlbumResult {
    if let all_albums = MPMediaQuery.albums().collections {
        var full_length_albums_with_artwork = all_albums
            .filter { $0.count > 5 && $0.representativeItem?.artwork != nil }
        if (full_length_albums_with_artwork.count >= 4) {
            full_length_albums_with_artwork.shuffle()
            return .four(Array(full_length_albums_with_artwork[..<4]))
        } else {
            return .not_enough
        }
    } else {
        return .permission_denied
    }
}

func request_permission(_ contentView: ContentView) {
    let handler : (MPMediaLibraryAuthorizationStatus) -> () = {
        switch $0 {
        case .authorized:
            // Doing this immediately returns no results -- some sort of permissions race condition?
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                contentView.refresh_albums()
            }
        default:
            break;
        }
    }
    MPMediaLibrary.requestAuthorization(handler)
}
