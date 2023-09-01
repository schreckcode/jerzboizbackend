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
            UserJerseyListView(edit: false)
                .tabItem {
                    Label("J Ranks", systemImage: "figure.pickleball")
                        .font(Font(UIFont.systemFont(ofSize: 11)))

                }
                MyProfileView()
                    .tabItem {
                        Label("My Stuff", systemImage: "square.and.pencil")
                            .font(Font(UIFont.systemFont(ofSize: 11)))

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
