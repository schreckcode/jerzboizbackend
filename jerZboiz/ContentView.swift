import SwiftUI
import os

struct ContentView: View {

    @State var isShowFrontPicker: Bool = false
    @State var isShowBackPicker: Bool = false
    @State var front: Image? = Image("placeholder")
    @State var back: Image? = Image("placeholder")
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    front?
                        .resizable()
                        .scaledToFit()
                        .frame(height: 320)
                    Button(action: {
                        withAnimation {
                            self.isShowFrontPicker.toggle()
                        }
                    }) {
                        Image(systemName: "photo")
                            .font(.headline)
                        Text("Import Front").font(.headline)
                    }.foregroundColor(.black)
                    Spacer()
                    back?
                        .resizable()
                        .scaledToFit()
                        .frame(height: 320)
                    Button(action: {
                        withAnimation {
                            let _ = Logger().info("Setting false")
                            self.isShowBackPicker.toggle()
                        }
                    }) {
                        Image(systemName: "photo")
                            .font(.headline)
                        Text("Import Back").font(.headline)
                    }.foregroundColor(.black)
                    Spacer()
                    Spacer()

                }
            }
            .sheet(isPresented: $isShowFrontPicker) {

                ImagePicker(image: self.$front)
                
            }
            .sheet(isPresented: $isShowBackPicker) {

                ImagePicker(image: self.$back)
                
            }
            .navigationBarTitle("Pick Image")
        }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
