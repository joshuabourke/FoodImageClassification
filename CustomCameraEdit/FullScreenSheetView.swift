//
//  FullScreenSheetView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 13/9/21.
//

import SwiftUI
import Firebase

struct FullScreenSheetView: View {
    @Environment(\.presentationMode) var presentataionMode
    @Binding var sheetViewImage: UIImage?
    @StateObject var imDetection: ImageDetection
    @State var foodNameTitle: String = "Food Name"
    @State var didClickClose: Bool = false
    @State var didClickSave: Bool = false
    var fireBaseObject = FireBaseUpload()
//    @ObservedObject var imageDetectionVM: ImageDetectionViewModel
//    var imageDetectionManager: ImageDetectionManager
//
//    init(){
//        self.imageDetectionManager = ImageDetectionManager()
//        self.imageDetectionVM = ImageDetectionViewModel(manager: imageDetectionManager)
    
    var body: some View {
        VStack {
            ZStack(alignment: .top){
                Image(uiImage: sheetViewImage ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 325, height: 450)
                    .cornerRadius(12)
                    .onChange(of: sheetViewImage, perform: { value in
                        imDetection.imageDetectionVM.detect(sheetViewImage)
                       foodNameTitle = imDetection.imageDetectionVM.predictionLabel
                        didClickClose = false
                        didClickSave = false
                    })
            HStack{
                    Spacer()
                Button(action: {
//                        sheetViewImage = UIImage()
                        presentataionMode.wrappedValue.dismiss()
                        didClickClose = true
                    }, label: {
                        Image(systemName: self.didClickClose == true ? "xmark.circle.fill" : "xmark" )
                            .resizable()
                            .frame(width: 15, height: 20)
                })
                    .frame(width: 15, height: 20)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    
                 Spacer()
                    
                
                Button(action: {
                    fireBaseObject.fireBaseUpload(funcName: foodNameTitle, funcImage: sheetViewImage!)
                    
                    print("Upload Button Pressed")
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                        .resizable()
                })
                        .frame(width: 15, height: 20)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                
                    Spacer()
                    
                Button(action: {
                    didClickSave.toggle()
                    }, label: {
                        Image(systemName: self.didClickSave == true ? "bookmark.fill" : "bookmark")
                        .resizable()
                })
                        .frame(width: 15, height: 20)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    Spacer()
                    
                }
            Spacer()

            }
            Spacer()
        }
        ScrollView{
            HStack(){
            Text(foodNameTitle)
                .font(.largeTitle).bold()
                .padding(EdgeInsets(.init(top: 0, leading: 15, bottom: 3, trailing: 5)))
                Spacer()
            }
            .frame(alignment: .leading)
            HStack(){
                Text("Secondary food info will be displayed here...")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(EdgeInsets(.init(top: 0, leading: 15, bottom: 5, trailing: 5)))
                Spacer()
            }
            .frame(alignment: .leading)
            Spacer()
        }
    }
    
}

class FireBaseUpload {
    //Create a root reference
    
    func fireBaseUpload(funcName: String,funcImage: UIImage){
        let foodNameId = funcName
        let storageRef = Storage.storage().reference(withPath: "Nutrify Photo's/\(foodNameId).jpg")
        guard let imageData = funcImage.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: uploadMetaData) { downloadMetadata, error in
            if let error = error{
                print("Oh no! Got an Error! \(error.localizedDescription)")
                return
            }
            print("Put is complete and I got this back: \(downloadMetadata)")
        }
        
    }

    
    
    
}

struct FullScreenSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenSheetView(sheetViewImage: Binding<UIImage?>.constant(UIImage(named: "placeholder")!), imDetection: ImageDetection())
    }
}
