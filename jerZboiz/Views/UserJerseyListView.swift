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
    let edit: Bool
    @EnvironmentObject var dataManager: DataManager
    @State private var searchText = ""
    @State private var editJersey: Jersey? = nil

    @State private var sort = "BestFirst"
    @State private var whosJs = "Pat"
    @State private var whosRank = "Pat"

    let whosJsOptions = ["Brock", "Brian", "Pat"]
    let whosRankOptions = ["Brock", "Brian", "Pat"]
    let howSortOptions = ["WorstFirst", "BestFirst"]
    
    let logger = Logger()

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    
                    LazyVStack {
                        let jerseyList = dataManager.getJList(whoJ: whosJs)
                        let _ = Logger().info("1. \(jerseyList.count)")
                        let rankList = dataManager.getRankList(whoJ: whosJs, whoRank: whosRank)
                        let _ = Logger().info("2 \(rankList.count)")

                        let sortedList = getSortedList(list: rankList)
                        let _ = Logger().info("3. \(sortedList.count)")

                        let filteredList = getFilteredList(list: sortedList, jList: jerseyList)
                        if(filteredList.count > 0) {
                            ForEach(filteredList) { jersey in
                                
                                HStack {
                                    Spacer()
                                    Spacer()
                                    Text(String(getIndex(id: jersey.id, array: sortedList)))
                                        .bold()
                                        .shadow(radius: 5)
                                        .font(Font(UIFont.systemFont(ofSize: 16)))

                                    if let jerz = jerseyList.first(where: {$0.id == jersey.id}) {
                                        JerseyCellView(jersey: jerz , edit: edit)
                                    } else {
                                        let _ = Logger().info("Cannot find \(jersey.id)")
                                    }
                                }
                            }
                        } else {
                            Spacer()
                            VStack {
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text("No Jerseys")
                                    Spacer()
                                }
                                Spacer()
                            }
                            Spacer()
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
                HStack {
                    Picker("Select a paint color", selection: $whosJs) {
                        ForEach(whosJsOptions, id: \.self) {
                            Text("\($0)s Js")
                        }
                    }
                    .pickerStyle(.menu)
                    Picker("Select a paint color", selection: $whosRank) {
                        ForEach(whosRankOptions, id: \.self) {
                            Text("\($0) Ranks")
                        }
                    }
                    .pickerStyle(.menu)
                    Picker("Select a paint color", selection: $sort) {
                        ForEach(howSortOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }

        }.refreshable {
            do {
                dataManager.refresh()
            }
        }.searchable(text: $searchText)
    }
    
    func getIndex(id: Int, array: [JerseyRank]) -> Int {
        if let index = array.firstIndex(where: {$0.id == id}) {
            if(self.sort == "BestFirst") {
                return index + 1
            } else {
                return array.count - index
            }
        }
        
        return 0
    }

    func getSortedList(list: [JerseyRank]) -> [JerseyRank] {
        var internalList:[JerseyRank] = list
        if(self.sort == "WorstFirst") {
            internalList.sort {$0.rank > $1.rank }
        } else {
            internalList.sort {$0.rank < $1.rank }
        }
        
        return internalList
    }
    func getFilteredList(list: [JerseyRank], jList: [Jersey]) -> [JerseyRank] {
        
        if searchText.isEmpty {
            Logger().info("Return list.  \(list.count)")
            return list
        } else {
            Logger().info("Return Filtered.  \(list.count)")

            return list.filter { getPlayerName(id: $0.id, list: jList).contains(searchText) }
        }
    }
    func getPlayerName(id: Int, list: [Jersey]) -> String {
        if let index = list.first(where: {$0.id == id}) {
            let _ = Logger().info("Player: \(index.player)")
            return index.player
        }
        return ""
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        UserJerseyListView(edit: false)
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

