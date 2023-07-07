//
//  MyProfileView.swift
//  FirebaseTutorial
//
//  Created by Logan Koshenka on 3/30/22.
//

import SwiftUI
import Firebase
import os
import Foundation

struct MyProfileView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false

    var body: some View {
        let user = Auth.auth().currentUser;

        if (user == nil) {
            content
        } else {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Rank Js", systemImage: "carrot")
                    }
                ContentView()
                    .tabItem {
                        Label("Edit My Js", systemImage: "wineglass")
                    }
                AddJerseyView()
                    .tabItem {
                        Label("Add New J", systemImage: "appple")
                    }
                if (user?.email == "pat@pat.com") {
                    ContentView()
                        .tabItem {
                            Label("Admin Menu", systemImage:
                            "8.circle")
                        }
                }
            }
        }
    }
    
    var scroll: some View {
        ScrollView {
            VStack {
                let log = Logger()
                let _ = log.info("one")
                Text("Text")
            }
        }
    }
    var content: some View {

                ZStack {
                    let log = Logger()
                    Color.black
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.blue, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 1000, height: 400)
                    .rotationEffect(.degrees(135))
                    .offset(y: -350)
                
                VStack(spacing: 20) {
                    Image("showtime")
                        .offset(y:-70)
                    
                        TextField("Email", text: $email)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .textCase(.lowercase)
                            .placeholder(when: email.isEmpty) {
                                Text("Email")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .textCase(.lowercase)
                            .placeholder(when: password.isEmpty) {
                                Text("Password")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        
                        Rectangle()
                            .frame(width: 350, height: 1)
                            .foregroundColor(.white)
                        
                        Button {
                            login()
                        } label: {
                            Text("Login")
                                .bold()
                                .frame(width: 200, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.linearGradient(colors: [.blue, .teal], startPoint: .top, endPoint: .bottomTrailing))
                                )
                                .foregroundColor(.white)
                                .offset(y: -30)
                        }
                        .padding(.top)
                        .offset(y: 100)
                    
                    
                }
                .frame(width: 350)

            }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
