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
    @StateObject var dataManager = DataManager()

    init() {
        // put the following into the .onAppear of a top level view or App.init
            // get each of the font families
            for family in UIFont.familyNames.sorted() {
                let names = UIFont.fontNames(forFamilyName: family)
                // print array of names
                print("Family: \(family) Font names: \(names)")
            }
        FirebaseApp.configure()

        UIFont.overrideInitialize()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dataManager)

        }
    }
}
