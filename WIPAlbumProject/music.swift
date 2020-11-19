//
//  music.swift
//  WIPAlbumProject
//
//  Created by Joseph Rees-Hill on 11/18/20.
//

import Foundation
import MediaPlayer

func play(album: MPMediaItemCollection) {
    let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
    musicPlayer.setQueue(with: album)
    musicPlayer.play()
}

func get_albums() -> [MPMediaItemCollection] {
    var full_length_albums_with_artwork = MPMediaQuery
        .albums()
        .collections?
        .filter { $0.count > 5 && $0.representativeItem?.artwork != nil }
    full_length_albums_with_artwork?.shuffle()
    return Array(full_length_albums_with_artwork![..<4])
}
