//
//  FullScreenBodyTextView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import SwiftUI
import CoreData

struct FullScreenBodyTextView: View {
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentataionMode
    @StateObject var imDetection: ImageDetection
    let testJson: Test
    
    //Properties that change ever time a photo is taken. changes the image and the title, then assigns it a new unique id for core data purposes.
    @State var title: String = ""
    @Binding var takenImage: UIImage?
    @State var id = UUID()
    
    
    
    
    //MARK: - CORE DATA PROPERTIES
    //trying to save items from the list the Core Data
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saved.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Saved.dataFoodName, ascending: true), NSSortDescriptor(keyPath: \Saved.dataFoodImage, ascending: true), NSSortDescriptor(keyPath: \Saved.dataPredicPercent, ascending: true), NSSortDescriptor(keyPath: \Saved.dataFoodID, ascending: true)])
    
    var savings: FetchedResults<Saved>

    //MARK: - BODY
    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .center, spacing: 20) {
                    //HERO IMAGE
                    Image(uiImage: takenImage ?? UIImage(named: "placeholder")!)
                        .resizable()
                        .scaledToFit()
                    
                    //TITLE
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 8)
                        .foregroundColor(.primary)
                        .background(Color.accentColor
                                        .frame(height: 6)
                                        .offset(y: 24))
                    
                    //LINE OF BUTTONS
                    
                    //HEADLINE
                    Text(testJson.headline)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    
                    //NUTRITION INFO
                    Group{
                    HeadingView(headingImage: "info.circle", headingTitle: "Nutritional Values")
                    NutritionView(food: testJson)
                    }//: GROUP
                    
                    //GALLERY
                    Group{
                        HeadingView(headingImage: "photo.on.rectangle.angled", headingTitle: "More \(title)'s")
                        ImageSliderView(testJson: testJson)
                    }//: GROUP
                    .padding(.vertical)
                    
                    //DESCRIPTION
                    Group{
                    HeadingView(headingImage: "questionmark.circle", headingTitle: "All about \(title)'s")
                        Text(testJson.description)
                            .multilineTextAlignment(.leading)
                            .layoutPriority(1)
                    }//: GROUP
                    
                    //LINK
                    Group{
                        HeadingView(headingImage: "books.vertical", headingTitle: "Find out More!")
                        LinkView(testJson: testJson)
                    }//: GROUP
                    .padding(.vertical)
                }//: VSTACK
                
            }//: SCROLL
            .ignoresSafeArea(.container, edges: .top)
            .onAppear {
                imDetection.imageDetectionVM.detect(takenImage)
                title = imDetection.imageDetectionVM.predictionLabel
                
                
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



    //MARK: - PREVIEW
struct FullScreenBodyTextView_Previews: PreviewProvider {
    static let testApple: [Test] = Bundle.main.decode("TestApple.json")
    
    static var previews: some View {
        FullScreenBodyTextView(imDetection: ImageDetection(), testJson: testApple[0], takenImage: Binding<UIImage?>.constant(UIImage(named: "placeholder")!))
            .preferredColorScheme(.dark)
    }
}
