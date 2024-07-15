//
//  jerseyRankCellView.swift
//  ListDragAndDrop
//
//  Created by Donat Kabashi on 5.3.22.
//

import SwiftUI
import Foundation
import os
struct JerseyRankCellView: View {
    let jerseyRank: JerseyRank
    let whosJ: String
    let expanded: String
    @EnvironmentObject var dataManager: DataManager
    let util = UserUtility()

    
    var body: some View {
        let personsArray = dataManager.getJList(whoJ: whosJ)
        let logger = Logger()
        let _ = logger.info("Who: \(whosJ) Id: \(jerseyRank.id)")
        if let jersey = personsArray.first(where: {$0.id == jerseyRank.id}) {
            
            let color = jersey.color
            if(expanded == "More Info") {
                HStack {
                    AsyncImage(url: URL(string: jersey.front)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding(.leading, 10)
                    } placeholder: {
                        Image("jersey")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .padding(.leading, 10)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(jersey.player)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .shadow(radius: 5)
                            .padding(.bottom, 5)
                            .font(Font(UIFont.systemFont(ofSize: 16)))
                            .multilineTextAlignment(.center)
                        Spacer()
                        HStack {
                            Spacer()
                            Text(jersey.team)
                                .shadow(radius: 5)
                                .font(Font(UIFont.systemFont(ofSize: 11)))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                            
                        }
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            
                            Spacer()
                            Text("Size:\n \(jersey.size)")
                                .shadow(radius: 5)
                                .font(Font(UIFont.myBoldSystemFont(ofSize: 11)))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Text("Color:\n \(jersey.color)")
                                .shadow(radius: 5)
                                .font(Font(UIFont.myBoldSystemFont(ofSize: 11)))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Text("Cut: \n \(jersey.cut)")
                                .shadow(radius: 5)
                                .font(Font(UIFont.myBoldSystemFont(ofSize: 11)))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                            
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            
                            Text("Source:\n \(jersey.source)")
                                .shadow(radius: 5)
                                .font(Font(UIFont.myBoldSystemFont(ofSize: 11)))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Text("Price:\n \(jersey.price)")
                                .shadow(radius: 5)
                                .font(Font(UIFont.myBoldSystemFont(ofSize: 11)))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Text("Bought:\n \(jersey.yearPurchased)")
                                .shadow(radius: 5)
                                .font(Font(UIFont.myBoldSystemFont(ofSize: 11)))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                            Spacer()
                            
                        }
                        Spacer()
                        
                    }
                    
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                        .frame(width: 30)
                        .shadow(radius: 5)
                        .padding(.trailing, 10)
                }
                .foregroundColor(jersey.color == "White" ? .black : .white)
                .frame(minWidth: 150, idealWidth: 360, maxWidth: 500)
                .frame(height: 150)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.gray, getJerseyCellColor(jersey: jersey)]),
                        startPoint: .top,
                        endPoint: .bottom))
                .cornerRadius(15)
                .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                
                
            } else {
                HStack {
                    AsyncImage(url: URL(string: jersey.front)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 33)
                            .shadow(radius: 5)
                            .cornerRadius(20)
                            .padding(.leading, 10)
                    } placeholder: {
                        Image("jersey")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .shadow(radius: 5)
                            .padding(.leading, 10)
                    }
                    Spacer()
                    Text(jersey.player)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .shadow(radius: 5)
                        .padding(.bottom, 5)
                        .font(Font(UIFont.systemFont(ofSize: 16)))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text(jersey.color)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .shadow(radius: 5)
                        .padding(.bottom, 5)
                        .font(Font(UIFont.systemFont(ofSize: 16)))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                        .frame(width: 30)
                        .shadow(radius: 5)
                        .padding(.trailing, 10)
                }
                .foregroundColor(jersey.color == "White" ? .black : .white)
                .frame(minWidth: 150, idealWidth: 360, maxWidth: 500)
                .frame(height: 35)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.gray, getJerseyCellColor(jersey: jersey)]),
                        startPoint: .top,
                        endPoint: .bottom))
                .cornerRadius(80)
                .padding(EdgeInsets(top: 1, leading: 20, bottom: 1, trailing: 20))
            }
        } else {
            if let jersey = personsArray.first(where: {$0.id == jerseyRank.id}) {
                let _ = logger.info("0: Id: \(jerseyRank.id)")
            }
        }
    }
    
    func getJerseyCellColor(jersey: Jersey) -> Color {
        if(jersey.color == "White") {
            return .white
        } else if (jersey.color == "Purple") {
            return .purple
        } else if (jersey.color == "Black") {
            return .black
        } else if (jersey.color == "Gold") {
            return Color(#colorLiteral(red: 0.9882352941, green: 0.7607843137, blue: 0, alpha: 1))
        } else if (jersey.color == "Green") {
            return .green
        } else if (jersey.color == "Yellow") {
            return .yellow
        } else if (jersey.color == "Blue - Royal") {
            return Color("royalblue")
        } else if (jersey.color == "Blue - Navy") {
            return Color("navyblue")
        } else if (jersey.color == "Orange") {
            return .orange
        } else if (jersey.color == "Red") {
            return .red
        }
        return .blue
    }
}
