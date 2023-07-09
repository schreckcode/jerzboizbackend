import SwiftUI
import os
import Firebase
import FirebaseStorage
import SDWebImage

struct AddJerseyView: View {
    

    @State var isShowFrontPicker: Bool = false
    @State var isShowBackPicker: Bool = false
    @State var front: Image? = Image( "jersey")
    @State var back: Image? = Image( "jersey")
    @State var team: String = "Atlanta Hawks"
    @State var size: Int = 36
    @State private var playerName: String = ""
    @State var fIP:Bool = false
    @State var bIP:Bool = false
    @State var dIP:Bool = false
    @State var uploadInProgress:Bool = false
    
        init(){
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Avenir-Book", size: 36)!]
            for family in UIFont.familyNames {
                 print(family)
                 for names in UIFont.fontNames(forFamilyName: family){
                 print("== \(names)")
                 }
            }
            
        }
    
    func clearAll() {
        front = Image("jersey")
        back = Image("jersey")
        team = "Atlanta Hawks"
        size = 36
        playerName = ""
        uploadInProgress = false
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
                     let _ = clearAll()
                    }
                    //                VStack {
                    //                    VStack {
                    //                        Text("Blue")
                    //                    }
                    //                    .frame(width: gp.size.width, height: gp.size.height * 0.7)
                    //                    .background(Color.blue)
                    //                    VStack {
                    //                        Text("Red")
                    //                    }
                    //                    .frame(width: gp.size.width, height: gp.size.height * 0.3)
                    //                    .background(Color.red)
                    //                }
                    
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
                                Picker("Size", selection: $size) {
                                    ForEach(jerseySizes, id: \.self) {
                                        Text(String($0))
                                            .foregroundStyle(.white)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))                        .pickerStyle(.menu)
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    front = Image("jersey")
                                    back = Image("jersey")
                                    team = ""
                                    size = 36
                                    playerName = ""
                                }) {
                                    Image(systemName: "photo")
                                        .font(.headline)
                                    Text("Cancel").font(Font(UIFont.systemFont(ofSize: 16)))
                                }.buttonStyle(.borderedProminent).tint(.red)
                                Spacer()
                                Button(action: {
                                    fIP = true
                                    bIP = true
                                    dIP = true
                                    uploadInProgress = true
                                    addJersey(frontPic: front ?? Image("jersey"), backPic: back ?? Image("jersey"), player: playerName, team: team, size: size)
                                }) {
                                    Image(systemName: "photo")
                                        .font(.headline)
                                    Text("Submit").font(Font(UIFont.systemFont(ofSize: 16)))
                                }.buttonStyle(.borderedProminent).tint(.green)
                                Spacer()
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
                    .navigationBarTitle("Pick Image").font(Font(UIFont.systemFont(ofSize: 16)))
                }
            }
            .frame(height: .infinity).frame(maxWidth: .infinity)
            .cornerRadius(24).padding(.horizontal, 30)
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
    func addJersey(frontPic: Image, backPic: Image, player: String, team: String, size: Int) {
//        dIP = true
//        fIP = true
//        bIP = true
        let msec: String = String(Date().millisecondsSince1970)
        let util = UserUtility()
        let userName = util.getUserFromEmail(email: Auth.auth().currentUser?.email ?? "")
        let storage = FirebaseStorage.Storage.storage()
        let person = util.getUserFromEmail(email: Auth.auth().currentUser?.email ?? "invalid")
        let storageRef = storage.reference().child(person)
    //    storageRef.listAll { (result, error) in
    //        if let error = error {
    //            print("Error while listing all files: ", error)
    //        }
    //
    //        for item in result!.items {
    //            print("Item in images folder: ", item)
    //        }
    //    }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let frontFile: String = person + "/" + msec + "_front.jpg"
        let frontFileUrl: String = "https://firebasestorage.googleapis.com/v0/b/jerzboiz.appspot.com/o/" + person + "%2F" + msec + "_front.jpg?alt=media"

        let frontRef = storage.reference().child(frontFile)
        let frontData = resizeImage(image: frontPic.asUIImage(), targetSize: CGSize(width: 768, height: 1024))?.jpegData(compressionQuality: 0.2)

        
        frontRef.putData(frontData!, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
            }
            
            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
            fIP = false
        }
        
        let backFile: String = person + "/" + msec + "_back.jpg"
        let backFileUrl: String = "https://firebasestorage.googleapis.com/v0/b/jerzboiz.appspot.com/o/" + person + "%2F" + msec + "_back.jpg?alt=media"

        let backRef = storage.reference().child(backFile)
        let backData = resizeImage(image: backPic.asUIImage(), targetSize: CGSize(width: 768, height: 1024))?.jpegData(compressionQuality: 0.2)

        backRef.putData(backData!, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
            }
            
            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
            bIP = false
        }
        
        let db = Firestore.firestore()

          let docRef = db.collection(person).document(msec)

        docRef.setData(["id":Int(msec),"player": player, "team": team, "size": size, "front": frontFileUrl, "back": backFileUrl]) { error in
              if let error = error {
                  print("Error writing document: \(error)")
              } else {
                  print("Document successfully written!")
              }
            dIP = false
          }
    }
}


class StorageManager: ObservableObject {
}
extension Date {
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>) {
            _presentationMode = presentationMode
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


struct AddJerseyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddJerseyView()
        }
    }
}
