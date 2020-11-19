//
//  music.swift
//  WIPAlbumProject
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
        let handler : (MPMediaLibraryAuthorizationStatus) -> () = {
            switch $0 {
            case .authorized:
                print("gotta do something!!")
            default:
                break;
            }
        }
        MPMediaLibrary.requestAuthorization(handler)
        return .permission_denied
    }
}
