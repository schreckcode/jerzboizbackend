//
//  DataManager.swift
//  CustomTabNavigation
//
//  Created by Patrick Schreck on 4/2/23.
//  Copyright © 2023 Sprinthub Mobile. All rights reserved.
//


import SwiftUI
import Firebase
import Foundation
import os

@available(iOS 13.0, *)
@MainActor
class DataManager: ObservableObject {
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: DataManager.self)
        )
    @Published var patJs: [Jersey] = []
    @Published var brockJs: [Jersey] = []
    @Published var brianJs: [Jersey] = []
    @Published var myJs: [Jersey] = []
    @Published var userName: String = ""
    init() {
        fetchJerseys()

        
    }
   
    func refresh() {
        fetchJerseys()
    }
    
    func fetchJerseys() {
        fetchPersonJerseys(who: "pat")
        fetchPersonJerseys(who: "brian")
        fetchPersonJerseys(who: "brock")
    }
    
    func fetchPersonJerseys(who:String) {
        userName = UserUtility().getUserFromEmail(email: Auth.auth().currentUser?.email ?? "")

        if(who == "pat") {
            patJs.removeAll()
        } else if(who == "brian") {
            brianJs.removeAll()
        } else if(who == "brock") {
            brockJs.removeAll()
        }
        myJs.removeAll()
        
        let db = Firestore.firestore()
        let ref = db.collection(who)
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let _ = Logger().info("Test \(data)")
                    
                    let id = data["id"] as? Int ?? 0
                    if(id != 0) {
                        let player = data["player"] as? String ?? ""
                        let size = data["size"] as? Int ?? 0
                        let team = data["team"] as? String ?? ""
                        let back = data["back"] as? String ?? ""
                        let front = data["front"] as? String ?? ""
                        
                        
                        //Self.logger.info("ID \(id) Name: \(name)");
                        if(who == "pat") {
                            self.patJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back))
                            
                        } else if(who == "brian") {
                            self.brianJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back))
                        } else if(who == "brock") {
                            self.brianJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back))
                        }
                        
                        if(self.userName == who) {
                            let _ = Logger().info("Appending \(player)")
                            self.myJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back))
                        }
                    }
                }
            }
        }
    }
}
