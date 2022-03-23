//
//  FullScreenBodyTextView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import SwiftUI
import CoreData
import CoreML
import RealityKit

struct DetailedSheetView: View {
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentataionMode
    @AppStorage("savePhoto's") var savePhotos: Bool = false
    
    @StateObject var imDetection: ImageDetection
    let testJson: Test
    
    //Properties that change ever time a photo is taken. changes the image and the title, then assigns it a new unique id for core data purposes.
    @State var title: String = ""
    @State private var detailDescription: String = ""
    @State private var otherFoods: [String] = []
    @Binding var takenImage: UIImage?
    @State private var didCloseInfo: Bool = false
    @State var didSave: Bool = false
    @State private var isSaved: Bool = false

    @State private var itemOffset: Int = 0
    @State private var foodJSONOffSet: Int = 0
    
    //For the share sheet.
    @State private var shareSheetShowing: Bool = false
    @State private var items: [Any] = []
    
    
    @State private var tagTitle: String = ""
    @State private var testingArray = [String]()
    
    //NUTRITION INFO UPDATING
    @State private var nutritionTitle = ["1g", "10g", "100g", "1kg", "10kg"]
    @State private var nutritionMultiplyer = [0.01, 0.1, 1, 10, 100]
    @State private var arrayCounter: Double = 2
    @State private var isNutritionExpanded: Bool = false
    
    //MARK: - CORE DATA PROPERTIES
    //trying to save items from the list the Core Data
    
    //The Following code allows me to now save the same item more than once, also it will be sorted by date.
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saved.entity(), sortDescriptors: [
    NSSortDescriptor(keyPath: \Saved.dataDate, ascending: true)])
    
//    NSSortDescriptor(keyPath: \Saved.dataFoodName, ascending: true),
//    NSSortDescriptor(keyPath: \Saved.dataFoodImage, ascending: true),
//    NSSortDescriptor(keyPath: \Saved.dataPredicPercent, ascending: true),
    
    var savings: FetchedResults<Saved>

    //MARK: - FUNCTIONS
    
//    func checkIfItemExists() {
//        if testJson1.contains(where: {$0.name == title}) {
//            //it exists, do something
//            print("It Exists")
//        } else {
//            print("Item could not be found")
//        }
//    }
    
//    func getElement() {
//        if let elementName = testJson1.first(where: {$0.name == title}) {
//            //Do something with title
//            print("Do something with Title")
//        } else {
//            print("Could not find the title")
//        }
//    }
    
    func getEleOffset() {
    if let eleOffset = testJson1.enumerated().first(where: {$0.element.name == title}) {
            //Do something with the item off set
            print("Found item.offset\(eleOffset) and item.element")
            itemOffset = eleOffset.offset
        } else {
            //item offset and element could not be found
            print("Couldn't find item.offset and item.element")
        }
    }
    
    func getFoodJSONOffset() {
        if let eleOffSet = foodJSON?.enumerated().first(where: {$0.element.food == title}) {
            //Do something with the item off set
            print("Found item.offset\(eleOffSet) and item.element for FOODJSON")
            foodJSONOffSet = eleOffSet.offset
        } else {
            //Item offset and element could not be found
            print("Couldn't find item.offset and item.element for FOODJSON")
        }
    }
//
//    func getOffset() {
//        if let foodOffset = testJson1.firstIndex(where: {$0.name == title}) {
//            //Do something with titleOffset
//            print("retrieved offset")
//        } else {
//            //Item could not be found
//            print("Could not get offset")
//        }
//    }
    
    func runAll(){
//        checkIfItemExists()
//        getElement()
        getEleOffset()
        getFoodJSONOffset()
//        getOffset()
    }
    
    //MARK: - BODY
    var body: some View {
        
        ZStack {
            //MARK: - SCROLL VIEW
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .center, spacing: 20) {

                    TestingImageSharing(image: takenImage, title: title)
                    
                    
                    //HEADLINE
                    Text(foodJSON?[foodJSONOffSet].self.description ?? "n/a")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    
                    //LINE OF BUTTONS
                    //MARK: - DISMISS BUTTON
                    HStack {
                        Spacer()
                        Button(action: {
                                        presentataionMode.wrappedValue.dismiss()
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.title2)
                                            .foregroundColor(.accentColor)
                                            
                                })
                                    .frame(width: 15, height: 15)
                                .padding(4)
                    
                  //MARK: - SHARE BUTTON
                        Spacer()
                        Button(action: {
                            let sharedSnapshot = TestingImageSharing(image: takenImage,title: title).snapshot()
                            print("Share Image")
                            items.removeAll()
                            items.append(sharedSnapshot)
                            shareSheetShowing.toggle()
                        }, label: {
                            Image(systemName: "square.and.arrow.up")
                        })
                        Spacer()
                            .sheet(isPresented: $shareSheetShowing) {
                                ShareSheet(items: items)
                            }
                        
                        
                    //MARK: - SAVE BUTTON
                        Button(action: {
                            didSave = true
                            if didSave{
                            addItem()
                            } else {
                                print("Item Not Saved")
                            }
                            if savePhotos {
                            MyPhotoAlbum.shared.save(image: takenImage ?? UIImage(named: "placeholder")!)
                            } else {
                                print("Not Saving photo's")
                            }

                                
            //Testing to see if the items are being displayed in the list with CoreData
            //                    if didClickSave == true {
            //                        imageAndNameFeeder.foodList.append(ImageAndNameFeeder.Item(addingItemName: foodNameTitle, itemImage: sheetViewImage ?? UIImage(named: "placeholder")!))
            //                    } else {
            //                        imageAndNameFeeder.foodList.removeLast()
            //                    }
                                
                                }
                            ,label: {
                            Image(systemName: didSave ? "bookmark.fill" : "bookmark")
                                        .font(.title2)
                                        .foregroundColor(.accentColor)
                            })
                                    .disabled(didSave)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 15, height: 15)
                                    .padding(4)
                        Spacer()
                    }//: HSTACK (BUTTONS)
                    
                    //MARK: - FOOD TAG'S
                    Group{
                        
                        HeadingView(headingImage: "tag", headingTitle: "Other Possibilities")
                        
                        //FOOD TAG BUTTON'S
                        VStack(alignment: .center, spacing: 12) {
                                HStack(alignment: .center, spacing: 2) {
                                    ForEach(otherFoods, id: \.self) { item in
                                        Button(action: {
                                            print("passedTagTitle", tagTitle)
                                            title = item
                                            

                                        }, label: {
                                            Text(item)

                                                .foregroundColor(Color.primary)
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .padding(.horizontal)
                                                .padding(.vertical, 2)
                                                
                                        })
                                        .border(Color.accentColor, width: 2, cornerRadius: 25)

                                            .padding(.horizontal)

                                        }//: LOOP
                                    }//: HSTACK
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)

                                }//: VSTACK
                            
                    }
                    .padding(.bottom)
                    //MARK: - GROUP VIEWS
                    //NUTRITION INFO
                    Group{
                    HeadingView(headingImage: "leaf", headingTitle: "Nutritional Values")
                        VStack {
                            Text("Food Weight \(nutritionTitle[Array<String>.Index(arrayCounter)])")
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                                
                            HStack{
                                Image(systemName: "minus")
                                    .foregroundColor(.accentColor)
                                    .font(.title2)
                                    .onTapGesture {
                                        print("Decreasing food Weight Array Counter: \(arrayCounter)")
                                        feedback.notificationOccurred(.success)
                                        if arrayCounter <= 0 {
                                            print("At Min")
                                            feedback.notificationOccurred(.warning)
                                        } else {
                                            arrayCounter = arrayCounter - 1
                                            feedback.notificationOccurred(.success)
                                            if !isNutritionExpanded {
                                                print("Is Expended is False")
                                            } else {
                                                print("Is Expanded is True")
                                                isNutritionExpanded = false
                                            }
                                        }
                                    }
                                
                                Slider(value: $arrayCounter,in: 0...4, step: 1)
                                    .accentColor(Color.accentColor)
                                    .onChange(of: arrayCounter) { V in
                                        isNutritionExpanded = false
                                    }
                                
                                Image(systemName: "plus")
                                    .foregroundColor(.accentColor)
                                    .font(.title2)
                                    .onTapGesture {
                                        print("Increasing food weight Array Counter: \(arrayCounter)")
    
                                        if arrayCounter >= 4 {
                                            print("At max")
                                            feedback.notificationOccurred(.warning)
                                        } else {
                                            arrayCounter = arrayCounter + 1
                                            feedback.notificationOccurred(.success)
                                            if !isNutritionExpanded {
                                                print("Is Expended is False")
                                            } else {
                                                print("Is Expanded is True")
                                                isNutritionExpanded = false
                                            }
                                        }
                                    }
                            }//: SLIDER
                            .padding(.horizontal, 36)
                        }//: VSTACK
                        
                        NutritionView(foodJSON: foodJSON?[foodJSONOffSet], foodMultiplyer: $nutritionMultiplyer[Array<Double>.Index(arrayCounter)], foodMultiplyerTitle: $nutritionTitle[Array<String>.Index(arrayCounter)], isNutrientsExpanded: $isNutritionExpanded)
                    }//: GROUP
                    
                    //GALLERY
                    Group{
                        HeadingView(headingImage: "photo.on.rectangle.angled", headingTitle: "More on \(title)")
                        ImageSliderView(testJson: testJson1[itemOffset])
                    }//: GROUP
                    .padding(.vertical)
                    
                    //DESCRIPTION
                    Group{
                    HeadingView(headingImage: "questionmark.circle", headingTitle: "All about \(title)'s")
                        Text(testJson1[itemOffset].description)
                            .multilineTextAlignment(.leading)
                            .layoutPriority(1)
                    }//: GROUP
                    
                    //LINK
                    Group{
                        HeadingView(headingImage: "books.vertical", headingTitle: "Find out More!")
                        LinkView(testJson: testJson1[itemOffset])
                    }//: GROUP
                    .padding(.vertical)
                }//: VSTACK
                
                .padding(.bottom, 46)
            }//: SCROLL
//            .ignoresSafeArea(.container, edges: .top)
            .onAppear {
                
                
                imDetection.imageDetectionVM.detect(takenImage)
                title = imDetection.imageDetectionVM.predictionLabel
                otherFoods = imDetection.imageDetectionVM.otherPossiblePredictions
                runAll()
                
                detailDescription = foodJSON?[foodJSONOffSet].self.description ?? "n/a"
                print("DETAILDESCRIPTION: \(detailDescription)")
                
                print("Other Predictions: \(imDetection.imageDetectionVM.otherPossiblePredictions)")
                
            }
            .onDisappear {
                didSave = false
                detailDescription = ""
            }

        }//: ZSTACK
    }//: BODY
    
    //MARK: - CORE DATA SAVING
     private func addItem () {
         let data = self.takenImage?.jpegData(compressionQuality: 0.5)
         withAnimation {
             let newItem = Saved(context: moc)
             newItem.dataFoodImage = data
             newItem.dataFoodName = title
             newItem.dataFoodDescription = detailDescription
             newItem.dataFoodID = UUID()
             newItem.dataDate = Date()
             newItem.dataIsSaved = didSave
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



    //MARK: - PREVIEW
struct FullScreenBodyTextView_Previews: PreviewProvider {
    static let testApple: [Test] = Bundle.main.decode("TestApple.json")
    
    static var previews: some View {
        DetailedSheetView(imDetection: ImageDetection(), testJson: testApple[0], takenImage: Binding<UIImage?>.constant(UIImage(named: "placeholder")!))
            .preferredColorScheme(.dark)
    }
}
