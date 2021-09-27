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
    @EnvironmentObject var imageAndNameFeeder: ImageAndNameFeeder

    var body: some View {
//        let detectDirectionDrags = DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
//            .onEnded { value in
//                print(value.translation)
//                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30{
//                   print("Swipe Left FullScreenSheetView")
//
//                }else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30{
//                    print("Swipe Right FullScreenSheetView")
//                }else if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
//                    print("Swipe Up FullScreenSheetView")
//                }else if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
//                    print("Swipe Down FullScreenSheetView")
//                }else {
//                    print("Not sure where you swiped aye dawg. FullScreenSheetView")
//                }
//                
//            }
        
        VStack {
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
                    .shadow(color: .black, radius: 3, x: 0.25, y: 0.25)
                    
                 Spacer()
                    
                
                Button(action: {
                    fireBaseObject.fireBaseUpload(funcMetaDataName: foodNameTitle, funcImage: sheetViewImage!)
                    
                    print("Upload Button Pressed")
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                        .resizable()
                })
                        .frame(width: 15, height: 20)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 3, x: 0.25, y: 0.25)
                
                    Spacer()
                    
                Button(action: {
                    didClickSave.toggle()
                    
                    if didClickSave == true {
                        imageAndNameFeeder.foodList.append(ImageAndNameFeeder.Item(addingItemName: foodNameTitle, itemImage: sheetViewImage ?? UIImage(named: "placeholder")!))
                    } else {
                        imageAndNameFeeder.foodList.removeLast()
                    }
                    
                    }, label: {
                        Image(systemName: self.didClickSave == true ? "bookmark.fill" : "bookmark")
                        .resizable()
                })
                        .frame(width: 15, height: 20)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .black, radius: 3, x: 0.25, y: 0.25)
                    Spacer()
                }
            ZStack(alignment: .top){
            ScrollView{
                Image(uiImage: sheetViewImage ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 350, height: 425)
                    .cornerRadius(12)
                    .shadow(color: .black, radius: 3, x: 0.25, y: 0.25)
                    .onChange(of: sheetViewImage, perform: { value in
                        imDetection.imageDetectionVM.detect(sheetViewImage)
                       foodNameTitle = imDetection.imageDetectionVM.predictionLabel
                        didClickClose = false
                        didClickSave = false
                    
                    })
                Spacer()
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
            
            Spacer()

            
            Spacer()
        }
    }
    
}

class FireBaseUpload {
    //Create a root reference
    
    func fireBaseUpload(funcMetaDataName: String, funcImage: UIImage){
        let foodNameId = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "Nutrify Photo's/\(foodNameId).jpg")
        guard let imageData = funcImage.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        uploadMetaData.customMetadata = ["Name" : "\(funcMetaDataName)"]
        
        
        
        
        storageRef.putData(imageData, metadata: uploadMetaData) { downloadMetadata, error in
            if let error = error{
                print("Oh no! Got an Error! \(error.localizedDescription)")
                return
            }
            print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
        }
        
    }

    
    
    
}

struct FullScreenSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenSheetView(sheetViewImage: Binding<UIImage?>.constant(UIImage(named: "placeholder")!), imDetection: ImageDetection())
    }
}
