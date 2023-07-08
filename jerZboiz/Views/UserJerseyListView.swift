//
//  MovieListView.swift
//  CustomTabNavigation
//
//  Created by Patrick Schreck on 4/2/23.
//  Copyright © 2023 Sprinthub Mobile. All rights reserved.
//

import SwiftUI
import os

import UniformTypeIdentifiers

struct UserJerseyListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""

    let logger = Logger()

    var body: some View {
        NavigationView {

            ScrollView {

                LazyVStack {
                    let filteredList = getFilteredList(list: dataManager.myJs)
                        ForEach(filteredList) { jersey in
                        HStack {
                            Spacer()
                            Spacer()
                            JerseyCellView(jersey: jersey)
                        }
                    }
                }.padding(.vertical, 20)
                    .background(Color.blue.opacity(0.2))

            }.navigationTitle("Jerseys")
                .bold()
                .shadow(radius: 5)
                .font(Font(UIFont.systemFont(ofSize: 16)))
                .background(Color.blue.opacity(0.2))
                .frame(alignment: .center)
                .navigationBarTitleDisplayMode(.inline)

        }.refreshable {
            do {
                dataManager.refresh()
            } catch {
                // Something went wrong; clear the news
                logger.info("Something Bad in Refresh")
            }
        }.searchable(text: $searchText)
    }

    func getFilteredList(list: [Jersey]) -> [Jersey] {
        if searchText.isEmpty {
            Logger().info("Return list.  \(list.count)")
            return list
        } else {
            Logger().info("Return Filtered.  \(list.count)")

            return list.filter { $0.player.contains(searchText) }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        UserJerseyListView()
                    .environmentObject(DataManager())

    }
}



//struct MovieListView: View {
//    @EnvironmentObject var dataManager: DataManager
//    @State private var showPopup = false
//
//    var body: some View {
//        NavigationView {
//            List(dataManager.movielist, id: \.id) { movie in
//                Text(movie.name)
//            }
//            .navigationTitle("Movies")
//        }
//    }
//}
//
//struct MovieListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieListView()
//            .environmentObject(DataManager())
//    }
//}

