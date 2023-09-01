//
//  UserUtility.swift
//  SamCop
//
//  Created by Patrick Schreck on 4/14/23.
//

import Foundation
import os
import Firebase

class UserUtility {
    func getUserFromEmail(email: String) -> String {
        var user:String
        switch email {
        case "brock@brock.com":
            user = "brock"
        case "brian@brian.com":
            user = "brian"
        case "pat@pat.com":
            user = "pat"
        default:
            user = "unknown"
        }
        return user
    }
    func getCapsUser() -> String {
        return getCapsUserFromEmail(email: Auth.auth().currentUser?.email ?? "")
    }
    func getCapsUserFromEmail(email: String) -> String {
        var user:String
        switch email {
        case "brock@brock.com":
            user = "Brock"
        case "brian@brian.com":
            user = "Brian"
        case "pat@pat.com":
            user = "Pat"
        default:
            user = "unknown"
        }
        return user
    }
    
    func reCalcRanks() async {
        let logger = Logger()
        let url = URL(string: "https://us-central1-samcopluvrs-58f34.cloudfunctions.net/calcJerseyRanks")!
        do {
            logger.info("In Try")
            // @todo let (data, _) =  try await URLSession.shared.data(from:url)
            //logger.info("Data \(data)")
            
        } catch {
            logger.error("oops")
        }
        logger.info("What?")
        return
    }
}
