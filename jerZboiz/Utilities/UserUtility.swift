//
//  UserUtility.swift
//  SamCop
//
//  Created by Patrick Schreck on 4/14/23.
//

import Foundation

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
}
