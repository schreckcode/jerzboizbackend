//
//  MainView.swift
//  SamCop
//
//  Created by Patrick Schreck on 4/2/23.
//

import SwiftUI
import AVFoundation

struct MainView: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        TabView {
            UserJerseyListView()
                .tabItem {
                    Label("J Rankings", systemImage: "figure.pickleball")
                }
                MyProfileView()
                    .tabItem {
                        Label("My Js", systemImage: "square.and.pencil")
                    }
        }.toolbar(.visible)
    }
}

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(DataManager())
    }
}
