//
//  MovieCellView.swift
//  ListDragAndDrop
//
//  Created by Donat Kabashi on 5.3.22.
//

import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImage
import os
struct JerseyCellView: View {
    let jersey: Jersey
    let edit: Bool
    @State var presentPopup = false

    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: jersey.front)) { image in
                    image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                    .shadow(radius: 5)
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
            VStack(alignment: .leading) {
                Text(jersey.player)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .shadow(radius: 5)
                    .padding(.bottom, 5)
                    .font(Font(UIFont.systemFont(ofSize: 16)))
                    .multilineTextAlignment(.center)

                Text(jersey.team)
                    .shadow(radius: 5)
                    .font(Font(UIFont.systemFont(ofSize: 11)))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                Spacer()

                HStack {
                    Spacer()


                    Spacer()
                    Text("Size:\n \(jersey.size)")
                        .shadow(radius: 5)
                        .font(Font(UIFont.systemFont(ofSize: 11)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Color:\n \(jersey.color)")
                        .shadow(radius: 5)
                        .font(Font(UIFont.systemFont(ofSize: 11)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Cut: \n \(jersey.cut)")
                        .shadow(radius: 5)
                        .font(Font(UIFont.systemFont(ofSize: 11)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    Spacer()

                }
                Spacer()
                HStack {
                    Spacer()

                    Text("Source:\n \(jersey.source)")
                        .shadow(radius: 5)
                        .font(Font(UIFont.systemFont(ofSize: 11)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Price:\n \(jersey.price)")
                        .shadow(radius: 5)
                        .font(Font(UIFont.systemFont(ofSize: 11)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Bought:\n \(jersey.yearPurchased)")
                        .shadow(radius: 5)
                        .font(Font(UIFont.systemFont(ofSize: 11)))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    Spacer()

                }
                Spacer()
                    
            }
            Spacer()
            if(edit == true) {
                Button(action: {
                  presentPopup = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
                .popover(isPresented: $presentPopup, arrowEdge: .bottom) {
                    EditJerseyView(jersey: jersey)
                }
                .padding(.horizontal, 10)
                Spacer()
            }
        }
        .foregroundColor(.white)
        .frame(minWidth: 150, idealWidth: 360, maxWidth: 500)
        .frame(height: 150)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.gray, .blue]),
                startPoint: .top,
                endPoint: .bottom))
        .cornerRadius(15)
        .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
     
        
    }
}

//struct MovieCellView_Previews: PreviewProvider {
//    static let fakemovie = Movie(
//        id: 1,
//        name: "Fake Movie",
//        image: "garbage_day_drawing",
//        description: "Blueberries are sweet, nutritious and wildly popular movie all over the world.",
//        trailer: "JbLvaMVtovc",
//        imdb: "tt0099664",
//        letterbox: "girlfriend-from-hell",
//        rt: "girlfriend_from_hell"
//    )
//    static var previews: some View {
//        MovieCellView(movie: fakemovie)
//    }
//}
