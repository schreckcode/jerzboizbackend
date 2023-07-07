//
//  jerZboizApp.swift
//  jerZboiz
//
//  Created by Patrick  Schreck on 7/3/23.
//

import SwiftUI
import Firebase

@main
struct jerZboizApp: App {
    
    init() {
        FirebaseApp.configure()

        UIFont.overrideInitialize()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
