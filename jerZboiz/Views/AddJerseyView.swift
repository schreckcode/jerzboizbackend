import SwiftUI
import os
import Firebase
import FirebaseStorage

struct AddJerseyView: View {

    @State var isShowFrontPicker: Bool = false
    @State var isShowBackPicker: Bool = false
    @State var front: Image? = Image( "jersey")
    @State var back: Image? = Image( "jersey")
    
    
        init(){
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "NBABulls", size: 36)!]
            for family in UIFont.familyNames {
                 print(family)
                 for names in UIFont.fontNames(forFamilyName: family){
                 print("== \(names)")
                 }
            }
            
        }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    front?
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Button(action: {
                        withAnimation {
                            self.isShowFrontPicker.toggle()
                        }
                    }) {
                        Image(systemName: "photo")
                            .font(.headline)
                        Text("Import Front").font(Font(UIFont.systemFont(ofSize: 16)))
                    }.buttonStyle(.borderedProminent).tint(.blue)
                    Spacer()
                    back?
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Button(action: {
                        withAnimation {
                            let _ = Logger().info("Setting false")
                            self.isShowBackPicker.toggle()
                        }
                    }) {
                        Image(systemName: "photo")
                            .font(.headline)
                        Text("Import Back").font(Font(UIFont.systemFont(ofSize: 16)))
                    }.buttonStyle(.borderedProminent).tint(.blue)

                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            front = Image("jersey")
                            back = Image("jersey")
                        }) {
                            Image(systemName: "photo")
                                .font(.headline)
                            Text("Cancel").font(Font(UIFont.systemFont(ofSize: 16)))
                        }.buttonStyle(.borderedProminent).tint(.red)
                        Spacer()
                        Button(action: {
                            addJersey(frontPic: front ?? Image("jersey"), backPic: back ?? Image("jersey"))
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
}

func addJersey(frontPic: Image, backPic: Image) {
    let msec: String = String(Date().millisecondsSince1970)
    let util = UserUtility()
    let userName = util.getUserFromEmail(email: Auth.auth().currentUser?.email ?? "")
    let storage = FirebaseStorage.Storage.storage()
    let storageRef = storage.reference().child("brock")
    storageRef.listAll { (result, error) in
            if let error = error {
                    print("Error while listing all files: ", error)
            }

            for item in result!.items {
                    print("Item in images folder: ", item)
            }
    }
    // Filenames will be
        // <person>/<msec>_front.jpg
        // <person>/<msec>_back.jpg
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


struct AddJerseyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddJerseyView()
        }
    }
}
