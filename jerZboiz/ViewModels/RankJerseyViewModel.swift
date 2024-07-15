
import SwiftUI
import Firebase
import os
import Foundation

@MainActor
class RankJerseyViewModel: ObservableObject {
    @Published var draggedItem: JerseyRank?
    @Published var jerseyList: [JerseyRank] = []
    @Published var dropOccurredFlag: Bool = false
    @Published var rankingWho: String = ""
    @Published var capsUserName = ""
    let util = UserUtility()
    var savedList: [JerseyRank] = []
    let db = Firestore.firestore()
    var ref: CollectionReference
    
    init() {
        let icapsUserName = util.getCapsUserFromEmail(email: Auth.auth().currentUser?.email ?? "")
        self.rankingWho = icapsUserName
        ref = db.collection(icapsUserName + "Rank" + icapsUserName)
        self.capsUserName = icapsUserName
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let _ = Logger().info("2: \(data)")

                    let rank = data["rank"] as? Int ?? -1
                    let id = data["id"] as? Int ?? -1
                    let userRank = JerseyRank(id: id, rank: rank)
                    self.jerseyList.append(userRank)
                    self.jerseyList.sort {$0.rank < $1.rank }
                    self.savedList = self.jerseyList
                    
                }
            }
        }
    }
    
    func upload() {
        let logger = Logger()
        var rank:Int = 1
        for jersey in self.jerseyList {
            logger.info("Updating Jersey \(jersey.id) to rank \(rank)")
            ref.document(String(jersey.id)).updateData(["rank": rank])
            rank = rank + 1
        }
        dropOccurredFlag = false
        self.savedList = self.jerseyList
        
        Task {
            await util.reCalcRanks()
        }
    }
    
    func dropOccurred() {
        dropOccurredFlag = true
    }
    
    func reset() {
        self.jerseyList = self.savedList
        dropOccurredFlag = false
    }
    
    func refresh() {
        capsUserName = util.getCapsUserFromEmail(email: Auth.auth().currentUser?.email ?? "")
        ref = db.collection(capsUserName + "Rank" + rankingWho)
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            if let snapshot = snapshot {
                self.jerseyList = []

                for document in snapshot.documents {
                    let data = document.data()
                    let _ = Logger().info("1: \(data)")
                    let rank = data["rank"] as? Int ?? -1
                    let id = data["id"] as? Int ?? -1
                    let userRank = JerseyRank(id: id, rank: rank)
                    self.jerseyList.append(userRank)
                    self.jerseyList.sort {$0.rank < $1.rank }
                    self.savedList = self.jerseyList
                    
                }
            }
        }
    }
}
