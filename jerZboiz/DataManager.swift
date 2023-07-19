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
    
    
    @Published var patRankPat: [JerseyRank] = []
    @Published var patRankBrock: [JerseyRank] = []
    @Published var patRankBrian: [JerseyRank] = []
    @Published var brianRankPat: [JerseyRank] = []
    @Published var brianRankBrian: [JerseyRank] = []
    @Published var brianRankBrock: [JerseyRank] = []
    @Published var brockRankPat: [JerseyRank] = []
    @Published var brockRankBrock: [JerseyRank] = []
    @Published var brockRankBrian: [JerseyRank] = []
    
    init() {
        fetchJerseys()

        
    }
   
    func refresh() {
        fetchJerseys()
    }
        
    func fetchJerseys() {
        fetchPersonJerseys(who: "Pat")
        fetchPersonJerseys(who: "Brian")
        fetchPersonJerseys(who: "Brock")
        fetchPersonRanks(whoRank: "Pat", whoJ: "Pat")
        fetchPersonRanks(whoRank: "Pat", whoJ: "Brian")
        fetchPersonRanks(whoRank: "Pat", whoJ: "Brock")
        fetchPersonRanks(whoRank: "Brock", whoJ: "Pat")
        fetchPersonRanks(whoRank: "Brock", whoJ: "Brian")
        fetchPersonRanks(whoRank: "Brock", whoJ: "Brock")
        fetchPersonRanks(whoRank: "Brian", whoJ: "Pat")
        fetchPersonRanks(whoRank: "Brian", whoJ: "Brian")
        fetchPersonRanks(whoRank: "Brian", whoJ: "Brock")
    }
    func getRankList(whoJ: String, whoRank: String) -> [JerseyRank] {
        if((whoRank == "Pat") && (whoJ == "Pat"))
        {
            return patRankPat
        } else if((whoRank == "Pat") && (whoJ == "Brock"))
        {
            return patRankBrock
        } else if((whoRank == "Pat") && (whoJ == "Brian"))
        {
            return patRankBrian
        } else if((whoRank == "Brock") && (whoJ == "Pat"))
        {
            return brockRankPat
        } else if((whoRank == "Brock") && (whoJ == "Brock"))
        {
            return brockRankBrock
        } else if((whoRank == "Brock") && (whoJ == "Brian"))
        {
            return brockRankBrian
        } else if((whoRank == "Brian") && (whoJ == "Pat"))
        {
            return brianRankPat
        } else if((whoRank == "Brian") && (whoJ == "Brock"))
        {
            return brianRankBrock
        } else if((whoRank == "Brian") && (whoJ == "Brian")) {
            return brianRankBrian
        }
        
        return []
    }
    
    func getJList(whoJ: String) -> [Jersey] {
        if( (whoJ == "Pat"))
        {
            let _ = Logger().info("Return pat. \(self.patJs.count)")
            return patJs
        } else if( (whoJ == "Brock"))
        {
            return brockJs
        } else if( (whoJ == "Brian"))
        {
            return brianJs
        }
        
        return []
    }
    
    func fetchPersonRanks(whoRank: String, whoJ: String) {
        if((whoRank == "Pat") && (whoJ == "Pat"))
        {
            patRankPat.removeAll()
        } else if((whoRank == "Pat") && (whoJ == "Brock"))
        {
            patRankBrock.removeAll()
        } else if((whoRank == "Pat") && (whoJ == "Brian"))
        {
            patRankBrian.removeAll()
        } else if((whoRank == "Brock") && (whoJ == "Pat"))
        {
            brockRankPat.removeAll()
        } else if((whoRank == "Brock") && (whoJ == "Brock"))
        {
            brockRankBrock.removeAll()
        } else if((whoRank == "Brock") && (whoJ == "Brian"))
        {
            brockRankBrian.removeAll()
        } else if((whoRank == "Brian") && (whoJ == "Pat"))
        {
            brianRankPat.removeAll()
        } else if((whoRank == "Brian") && (whoJ == "Brock"))
        {
            brianRankBrock.removeAll()
        } else if((whoRank == "Brian") && (whoJ == "Brian")) {
            brianRankBrian.removeAll()
        }
        
        let db = Firestore.firestore()
        let ref = db.collection(whoRank + "Rank" + whoJ)
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
                        let rank = data["rank"] as? Int ?? -1
                        
                        if((whoRank == "Pat") && (whoJ == "Pat"))
                        {
                            self.patRankPat.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Pat") && (whoJ == "Brock"))
                        {
                            self.patRankBrock.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Pat") && (whoJ == "Brian"))
                        {
                            self.patRankBrian.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Brock") && (whoJ == "Pat"))
                        {
                            self.brockRankPat.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Brock") && (whoJ == "Brock"))
                        {
                            self.brockRankBrock.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Brock") && (whoJ == "Brian"))
                        {
                            self.brockRankBrian.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Brian") && (whoJ == "Pat"))
                        {
                            self.brianRankPat.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Brian") && (whoJ == "Brock"))
                        {
                            self.brianRankBrock.append(JerseyRank(id:id, rank:rank))
                        } else if((whoRank == "Brian") && (whoJ == "Brian")) {
                            self.brianRankBrian.append(JerseyRank(id:id, rank:rank))
                        }
                    }
                }
            }
        }
    }
        
    func fetchPersonJerseys(who:String) {
        userName = UserUtility().getUserFromEmail(email: Auth.auth().currentUser?.email ?? "")

        if(who == "Pat") {
            patJs.removeAll()
        } else if(who == "Brian") {
            brianJs.removeAll()
        } else if(who == "Brock") {
            brockJs.removeAll()
        }
        myJs.removeAll()
        
        let db = Firestore.firestore()
        var counter:Int = 1
        let ref = db.collection(who.lowercased())
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
//                        if(who == "Pat") {
//                            let prpRef = db.collection("PatRankPat").document(String(id))
//                            prpRef.setData(["id":id, "rank":counter]){ error in
//                                if let error = error {
//                                    print("Error writing document: \(error)")
//                                } else {
//                                    print("Document successfully written!")
//                                }
//                            }
//                            let bfrpRef = db.collection("BrianRankPat").document(String(id))
//                            bfrpRef.setData(["id":id, "rank":counter]){ error in
//                                if let error = error {
//                                    print("Error writing document: \(error)")
//                                } else {
//                                    print("Document successfully written!")
//                                }
//                            }
//                            let bcrpRef = db.collection("BrockRankPat").document(String(id))
//                            bcrpRef.setData(["id":id, "rank":counter]){ error in
//                                if let error = error {
//                                    print("Error writing document: \(error)")
//                                } else {
//                                    print("Document successfully written!")
//                                }
//                            }
//                        }
//                        counter = counter + 1
                        let player = data["player"] as? String ?? ""
                        let size = data["size"] as? Int ?? 0
                        let team = data["team"] as? String ?? ""
                        let back = data["back"] as? String ?? ""
                        let front = data["front"] as? String ?? ""
                        let cut = data["cut"] as? String ?? ""
                        let price = data["price"] as? String ?? ""
                        let color = data["color"] as? String ?? ""
                        let source = data["source"] as? String ?? ""
                        let yearPurchased = data["yearPurchased"] as? String ?? ""
                        
                        
                        //Self.logger.info("ID \(id) Name: \(name)");
                        if(who == "Pat") {
                            self.patJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back,cut:cut,price:price,color:color,source:source,yearPurchased:yearPurchased))
                            
                        } else if(who == "Brian") {
                            self.brianJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back,cut:cut,price:price,color:color,source:source,yearPurchased:yearPurchased))
                        } else if(who == "Brock") {
                            self.brianJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back,cut:cut,price:price,color:color,source:source,yearPurchased:yearPurchased))
                        }
                        
                        if(self.userName == who) {
                            let _ = Logger().info("Appending \(player)")
                            self.myJs.append(Jersey(id: id, player: player, team: team, size: size, front: front, back: back,cut:cut,price:price,color:color,source:source,yearPurchased:yearPurchased))
                        }
                    }
                }
            }
        }
    }
}
