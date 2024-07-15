//
//  RankJerseyView.swift
//  SamCop
//
//  Created by Patrick Schreck on 4/12/23.
//

import SwiftUI
import Firebase
import os
import Foundation
import UniformTypeIdentifiers

//pat@pat.com
// schreck

struct RankJerseyView: View {
    //@EnvironmentObject var dataManager: DataManager
    @StateObject var viewModel = RankJerseyViewModel()
    @State private var whosJs = "Pat"
    @State private var expandedView = "More Info"

    let changeOccurred:Bool = false
    let logger = Logger()
    let whosJsOptions = ["Brock", "Brian", "Pat"]
    let expandedOptions = ["More Info", "Less Info"]

    var body: some View {
        let array = viewModel.jerseyList
        NavigationView {
            VStack (spacing: 10){
                ScrollView {
                    VStack {
                        ForEach(array) { jerz in
                            HStack {
                                Spacer()
                                Spacer()
                                Text(String((array.firstIndex(of: jerz) ?? 69) + 1))
                                    .bold()
                                    .shadow(radius: 5)
                                    .font(Font(UIFont.systemFont(ofSize: 16)))
                                JerseyRankCellView(jerseyRank: jerz, whosJ: viewModel.rankingWho, expanded: expandedView)
                                    .onDrag({
                                        viewModel.draggedItem = jerz
                                        return NSItemProvider(item: nil, typeIdentifier: String(jerz.id))
                                    })
                                    .onDrop(of: [UTType.text], delegate:   AnnualDragAndDropService<JerseyRank>(currentItem: jerz, items: $viewModel.jerseyList, draggedItem: $viewModel.draggedItem, model: viewModel)
                                    )
                            }.backgroundStyle(.linearGradient(colors: [.blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                        }
                    }.padding(.vertical, 20)
                        .background(Color.blue.opacity(0.2))

                }
                HStack {
                    Picker("Select a paint color", selection: $whosJs) {
                        ForEach(whosJsOptions, id: \.self) {
                            Text("\($0)s Js")
                        }
                    }
                    .onChange(of: whosJs, perform: {_ in
                        viewModel.rankingWho = whosJs
                        viewModel.refresh()
                    })
                    .pickerStyle(.segmented)
                    Picker("Select a paint color", selection: $expandedView) {
                        ForEach(expandedOptions, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.menu)

                }
                if(viewModel.dropOccurredFlag) {
                    Spacer()
                    HStack {
                        Button{ viewModel.reset() }
                    label: {
                        Text("Reset")
                            .bold()
                            .frame(width: 100, height: viewModel.dropOccurredFlag ? 40 : 0)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.red, .red], startPoint: .top, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.white)
                            .offset(y: -10)
                            .opacity(viewModel.dropOccurredFlag ? 100 : 0)
                    }
                        Button{ viewModel.upload() }
                    label: {
                        Text("Upload Changes")
                            .bold()
                            .frame(width: 200, height: viewModel.dropOccurredFlag ? 40 : 0)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.blue, .teal], startPoint: .top, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.white)
                            .offset(y: -10)
                            .opacity(viewModel.dropOccurredFlag ? 100 : 0)
                    }
                        
                    }
                }
                }
            .backgroundStyle(.blue.gradient)
            
            
        }.refreshable {
            do {
                viewModel.refresh()
            } catch {
                // Something went wrong; clear the news
                logger.info("Something Bad in Refresh")
            }
        }
    }
    
    struct AnnualDragAndDropService<T: Equatable>: DropDelegate {
        let currentItem: T
        @Binding var items: [T]
        @Binding var draggedItem: T?
        var model: RankJerseyViewModel

        var logger = Logger()
        
        func performDrop(info: DropInfo) -> Bool {
            model.dropOccurred()
            return true
        }
        
        func dropEntered(info: DropInfo) {
            guard let draggedItem = draggedItem,
                  draggedItem != currentItem,
                  let from = items.firstIndex(of: draggedItem),
                  let to = items.firstIndex(of: currentItem)
            else {
                return
            }
            withAnimation {
                items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
        
    }
}
