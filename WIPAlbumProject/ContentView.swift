//
//  ContentView.swift
//  WIPAlbumProject
//
//  Created by Joseph Rees-Hill on 11/17/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            row()
            row()
        }.padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func peppers() -> some View {
    let tap = TapGesture()
        .onEnded { _ in
            print("View tapped!")
        }
    return Image("peppers").resizable().scaledToFit().gesture(tap)
}

func row() -> some View {
    HStack {
        peppers()
        peppers()
    }
}
