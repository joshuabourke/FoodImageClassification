//
//  FullScreenSheetView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 13/9/21.
//

import SwiftUI
import Firebase

struct FullScreenSheetView: View {
    //MARK: - PROPERTIES
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @Environment(\.presentationMode) var presentataionMode
    @Binding var sheetViewImage: UIImage?
    @StateObject var imDetection: ImageDetection
    @State var foodNameTitle: String = "Food Name"
    @Binding var didTakePhoto: Bool
    @State var didClickClose: Bool = false
    @State var didClickSave: Bool = false
    @State private var isAnimating: Bool = false
    
    let hapticFeedBack = UINotificationFeedbackGenerator()
    
    @State var id = UUID()
    var fireBaseObject = FireBaseUpload()
    
    @State var posts = [Post]()
    
    //trying to save items from the list the Core Data

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saved.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Saved.dataFoodName, ascending: true), NSSortDescriptor(keyPath: \Saved.dataFoodImage, ascending: true), NSSortDescriptor(keyPath: \Saved.dataPredicPercent, ascending: true), NSSortDescriptor(keyPath: \Saved.dataFoodID, ascending: true)])
    
    var savings: FetchedResults<Saved>
    

    //MARK: - BODY
    var body: some View {
        VStack {
            HStack{
                    Spacer()
                
        //MARK: - DISMISS BUTTON
                Button(action: {
                        presentataionMode.wrappedValue.dismiss()
                        didClickClose = true
                    }, label: {
                        Image(systemName: self.didClickClose ? "xmark.circle.fill" : "xmark" )
                            .font(.title2)
                            .foregroundColor(.white)
                            
                })
                    .frame(width: 15, height: 15)
                    .padding()
//                    .background(Color.white)
//                    .clipShape(Circle())
//                    .shadow(color: .black, radius: 3, x: 0.25, y: 0.25)
//
                 Spacer()
                    
        //MARK: - FIREBASE BUTTON
                Button(action: {
                    fireBaseObject.fireBaseUpload(funcMetaDataName: foodNameTitle, funcImage: sheetViewImage!)
                    
                    print("Upload Button Pressed")
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.white)
                })
                        .frame(width: 15, height: 15)
                        .padding()
//                        .background(Color.white)
//                        .clipShape(Circle())
//                        .shadow(color: .black, radius: 3, x: 0.25, y: 0.25)
//
                    Spacer()
        //MARK: - SAVE BUTTON
                Button(action: {
                    addItem()
                    didClickSave.toggle()
//Testing to see if the items are being displayed in the list with CoreData
                    
                    
//                    if didClickSave == true {
//                        imageAndNameFeeder.foodList.append(ImageAndNameFeeder.Item(addingItemName: foodNameTitle, itemImage: sheetViewImage ?? UIImage(named: "placeholder")!))
//                    } else {
//                        imageAndNameFeeder.foodList.removeLast()
//                    }
                    
                    }, label: {
                        Image(systemName: self.didClickSave ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .foregroundColor(.white)
                })
                        .frame(width: 15, height: 15)
                        .padding()

                    Spacer()
                }
            ZStack(alignment: .top){
            ScrollView{
                Image(uiImage: sheetViewImage ?? UIImage(named: "placeholder")!)

                    .resizable()
                    .frame(width: 350, height: 425)
                    .cornerRadius(12)
                    .shadow(color: .black, radius: 3, x: 0.25, y: 0.25)
                    .scaleEffect(isAnimating ? 1 : 2)
                    .animation(.easeOut(duration: 0.4), value: isAnimating)
                    .onAppear {
                        isAnimating = true
                        hapticFeedBack.notificationOccurred(.success)
                    }
                Spacer()
                    HStack(){
                        Text(foodNameTitle)
                            .font(.largeTitle).bold()
                            .padding(EdgeInsets(.init(top: 0, leading: 15, bottom: 3, trailing: 5)))
                        Spacer()
                    }
                    .frame(alignment: .leading)
                
                ForEach(posts) { post in
                    VStack(alignment: .leading){
                        Text(post.title)
                        Divider()
                    }
                }
            }

            Spacer()

            }
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 40)
            .animation(.easeOut(duration: 0.8), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
            
            Spacer()
        }
        .onAppear {
//            switch foodNameTitle {
//            case "Apple":
//
//                
//            }
            
            imDetection.imageDetectionVM.detect(sheetViewImage)
            foodNameTitle = imDetection.imageDetectionVM.predictionLabel
            didClickClose = false
            didClickSave = false
            Api().getPosts { posts in
                self.posts = posts
            }
        }

    }
   //Function to save stuff to coreData
    private func addItem () {
        let data = self.sheetViewImage?.jpegData(compressionQuality: 0.5)
        withAnimation {
            let newItem = Saved(context: moc)
            newItem.dataFoodImage = data
            newItem.dataFoodName = foodNameTitle
            newItem.dataFoodID = id
            
            do{
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }
        
    }//: addItem
    
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
        FullScreenSheetView(sheetViewImage: Binding<UIImage?>.constant(UIImage(named: "placeholder")!), imDetection: ImageDetection(), didTakePhoto: Binding<Bool>.constant(false))
    }
}
