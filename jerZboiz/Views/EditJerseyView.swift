import SwiftUI
import os
import Firebase
import FirebaseStorage
import SDWebImage

struct EditJerseyView: View {
    let jersey: Jersey
    
    @State var isShowFrontPicker: Bool = false
    @State var isShowBackPicker: Bool = false
    @State var front: Image? = Image( "jersey")
    @State var back: Image? = Image( "jersey")
    @State var team: String = "Atlanta Hawks"
    @State var size: Int = 36
    @State var price: String = "???"
    @State var yearPurchased: String = "2022"
    @State var color: String = "White"
    @State var cut: String = "Pro Cut"
    @State var source: String = "eBay"
    @State private var showConfirmation = false
    @Environment(\.colorScheme) var colorScheme

    @State var frontUrl: String = ""
    @State var backUrl: String = ""


    @State private var playerName: String = ""
    @State var fIP:Bool = false
    @State var bIP:Bool = false
    @State var dIP:Bool = false
    @State var uploadInProgress:Bool = false
    @State var first:Bool = true


    func clearAll() {
        front = Image("jersey")
        back = Image("jersey")
        team = "Atlanta Hawks"
        size = 36
        playerName = ""
        price = "???"
        yearPurchased = "2022"
        color = "White"
        cut = "Pro Cut"
        source = "eBay"
        uploadInProgress = false
    }
    func setVars() {
        frontUrl = jersey.front
        backUrl = jersey.back
        team = jersey.team
        size = jersey.size
        playerName = jersey.player
        price = jersey.price
        if(jersey.yearPurchased != "") {
            yearPurchased = jersey.yearPurchased
        }
        if(jersey.color != "") {
            
            color = jersey.color
        }
        
        if(jersey.cut != "") {
            cut = jersey.cut
        }
        if(jersey.source != "") {
            
            source = jersey.source
        }
        uploadInProgress = false
        first = false
    }
    
    
    var body: some View {
        NavigationView {
            GeometryReader { gp in
                if((fIP || dIP || bIP)) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        Spacer()
                    }
                    
                } else {
                    if(uploadInProgress) {
                     Text("Uploaded")
                    }
                    
                    if(first) {
                       let _ = setVars()
                        
                    }
                    
                    ZStack {
                        VStack {
                            HStack {
                                VStack {
                                    front?
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 200)
                                    Button(action: {
                                        withAnimation {
                                            self.isShowFrontPicker.toggle()
                                        }
                                    }) {
                                        Image(systemName: "photo")
                                            .font(.headline)
                                        Text("Import Front").font(Font(UIFont.systemFont(ofSize: 10)))
                                    }.buttonStyle(.borderedProminent).tint(.blue)
                                }
                                VStack {
                                    back?
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 200)
                                    Button(action: {
                                        withAnimation {
                                            let _ = Logger().info("Setting false")
                                            self.isShowBackPicker.toggle()
                                        }
                                    }) {
                                        Image(systemName: "photo")
                                            .font(.headline)
                                        Text("Import Back").font(Font(UIFont.systemFont(ofSize: 10)))
                                    }.buttonStyle(.borderedProminent).tint(.blue)
                                }
                            }
                            TextField(
                                "Player Name",
                                text: $playerName
                            )
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .disableAutocorrection(true)
                            .padding(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.green, lineWidth: 2)
                            )
                            .padding()
                            HStack {
                                Picker("Team", selection: $team) {
                                    ForEach(jerseyTeams, id: \.self) {
                                        Text($0)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .pickerStyle(.menu)
                            }
                            HStack {
                                Picker("Size", selection: $size) {
                                    ForEach(jerseySizes, id: \.self) {
                                        Text(String($0))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .pickerStyle(.menu)
                                Picker("Color", selection: $color) {
                                    ForEach(jerseyColors, id: \.self) {
                                        Text(String($0))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .pickerStyle(.menu)
                                Picker("Bought", selection: $yearPurchased) {
                                    ForEach(jerseyYearPurchased, id: \.self) {
                                        Text(String($0))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .pickerStyle(.menu)
                            }
                            HStack {
                                Picker("Cut", selection: $cut) {
                                    ForEach(jerseyCut, id: \.self) {
                                        Text($0)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .pickerStyle(.menu)
                                Picker("Size", selection: $source) {
                                    ForEach(jerseySource, id: \.self) {
                                        Text(String($0))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .pickerStyle(.menu)
                                Picker("Color", selection: $price) {
                                    ForEach(jerseyPrice, id: \.self) {
                                        Text(String($0))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                                .pickerStyle(.menu)
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    clearAll()
                                }) {
                                    Image(systemName: "photo")
                                        .font(.headline)
                                    Text("Cancel").font(Font(UIFont.systemFont(ofSize: 16)))
                                }.buttonStyle(.borderedProminent).tint(.pink)
                                Spacer()
                                Button(action: {
                                    //fIP = true
                                    //bIP = true
                                    dIP = true
                                    uploadInProgress = true
                                    updateJersey(id: jersey.id, frontPic: front ?? Image("jersey"), backPic: back ?? Image("jersey"), player: playerName, team: team, size: size,cut:cut,price:price,color:color,source:source,yearPurchased:yearPurchased)
                                }) {
                                    Image(systemName: "photo")
                                        .font(.headline)
                                    Text("Submit").font(Font(UIFont.systemFont(ofSize: 16)))
                                }.buttonStyle(.borderedProminent).tint(.green)
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                Button("Delete Jersey") {
                                    showConfirmation = true
                                }
                                .frame(maxWidth: .infinity)
                                .confirmationDialog("Delete J For Real?", isPresented: $showConfirmation) {
                                    Button("Yes, Delete J!", role: .destructive, action: {deleteJersey(id: jersey.id)})
                                }
                                .buttonStyle(.borderedProminent).tint(.red).opacity(30.0)
                                
                            }
                            Spacer()
                            
                        }
                    }
                    .sheet(isPresented: $isShowFrontPicker) {
                        
                        ImagePicker(image: self.$front)
                        
                    }
                    .sheet(isPresented: $isShowBackPicker) {
                        
                        ImagePicker(image: self.$back)
                        
                    }
                    .navigationBarTitle("Edit Jersey").font(Font(UIFont.systemFont(ofSize: 16)))
                }
            }
            .frame(height: .infinity).frame(maxWidth: .infinity)
            .cornerRadius(24).padding(.horizontal, 30)
        }
            
    }
    
    func deleteJersey(id: Int) {
        let logger = Logger()
        logger.info("Deleting J")
        
        let defaultSession = URLSession(configuration: .default)
        
        var dataTask: URLSessionDataTask?
        
        // 1
        dataTask?.cancel()
        let util = UserUtility()

        let person = util.getCapsUserFromEmail(email: Auth.auth().currentUser?.email ?? "invalid")
        if(person != "invalid") {
            
            // 2
            if var urlComponents = URLComponents(string: "https://us-central1-jerzboiz.cloudfunctions.net/jerseyDelete" ) {
                urlComponents.query = "id=\(id)&who=\(person)"
                
                // 3
                guard let url = urlComponents.url else {
                    return
                }
                // 4
                dataTask =
                defaultSession.dataTask(with: url) { data, response, error in
                    defer {
                        dataTask = nil
                    }
                    // 5
                    if let error = error {
                        logger.error("Error \(error.localizedDescription)")
                        return
                    } else if
                        let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        logger.info("Data \(data)")
                    }
                }
            }
            // 7
            dataTask?.resume()
        } else {
            logger.error("Invalid Person for Delete")
        }
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func updateJersey(id: Int, frontPic: Image, backPic: Image, player: String, team: String, size: Int,cut:String,price:String,color:String,source:String,yearPurchased:String) {
//        dIP = true
//        fIP = true
//        bIP = true
        let msec: String = String(Date().millisecondsSince1970)
        let util = UserUtility()
        let userName = util.getUserFromEmail(email: Auth.auth().currentUser?.email ?? "")
        let storage = FirebaseStorage.Storage.storage()
        let person = util.getUserFromEmail(email: Auth.auth().currentUser?.email ?? "invalid")
        let storageRef = storage.reference().child(person)
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        let frontFile: String = person + "/" + msec + "_front.jpg"
//        let frontFileUrl: String = "https://firebasestorage.googleapis.com/v0/b/jerzboiz.appspot.com/o/" + person + "%2F" + msec + "_front.jpg?alt=media"
//
//        let frontRef = storage.reference().child(frontFile)
//        let frontData = resizeImage(image: frontPic.asUIImage(), targetSize: CGSize(width: 768, height: 1024))?.jpegData(compressionQuality: 0.2)
//
//
//        frontRef.putData(frontData!, metadata: metadata) { (metadata, error) in
//            if let error = error {
//                print("Error while uploading file: ", error)
//            }
//
//            if let metadata = metadata {
//                print("Metadata: ", metadata)
//            }
//            fIP = false
//        }
//
//        let backFile: String = person + "/" + msec + "_back.jpg"
//        let backFileUrl: String = "https://firebasestorage.googleapis.com/v0/b/jerzboiz.appspot.com/o/" + person + "%2F" + msec + "_back.jpg?alt=media"
//
//        let backRef = storage.reference().child(backFile)
//        let backData = resizeImage(image: backPic.asUIImage(), targetSize: CGSize(width: 768, height: 1024))?.jpegData(compressionQuality: 0.2)
//
//        backRef.putData(backData!, metadata: metadata) { (metadata, error) in
//            if let error = error {
//                print("Error while uploading file: ", error)
//            }
//
//            if let metadata = metadata {
//                print("Metadata: ", metadata)
//            }
//            bIP = false
//        }
        
        let db = Firestore.firestore()

          let docRef = db.collection(person).document(String(id))
        let _ = Logger().info("Setting cut \(cut)")
        docRef.setData(["id":id,"player": player, "team": team, "size": size, "front": frontUrl, "back": backUrl,
                        "cut":cut,"price":price,"color":color,"source":source,"yearPurchased":yearPurchased]) { error in
              if let error = error {
                  print("Error writing document: \(error)")
              } else {
                  print("Document successfully written!")
              }
            dIP = false
          }
    }
}

struct EditJerseyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditJerseyView(jersey: Jersey(id: 1, player: "player", team: "team", size: 35, front: "front", back: "back",cut:"cut",price:"price",color:"color",source:"source",yearPurchased:"yearPurchased"))
        }
    }
}
