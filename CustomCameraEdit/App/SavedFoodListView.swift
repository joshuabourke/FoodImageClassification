//
//  SavedFoodView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 19/9/21.
//

import SwiftUI
import CoreData

struct SavedFoodListView: View {
    //MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saved.entity(), sortDescriptors: [
    NSSortDescriptor(keyPath: \Saved.dataDate, ascending: true)])
    
//    NSSortDescriptor(keyPath: \Saved.dataFoodName, ascending: true),
//    NSSortDescriptor(keyPath: \Saved.dataFoodImage, ascending: true),
//    NSSortDescriptor(keyPath: \Saved.dataPredicPercent, ascending: true),
//    NSSortDescriptor(keyPath: \Saved.dataFoodID, ascending: true),

    var savings: FetchedResults<Saved>
    
    var testJson: Test
    

    
    var body: some View {
    //MARK: - BODY
        
        NavigationView{
            List{
                ForEach(savings, id: \.self.dataFoodID.description) { index in
                    NavigationLink(destination: DetailedSheetView(imDetection: ImageDetection(), testJson: testJson, takenImage: Binding<UIImage?>.constant(UIImage(data: index.dataFoodImage!)!), didSave: true))
                    {
                        //MARK: - SAVED ITEM VIEW
                        
                        SavedItemView(image: index.dataFoodImage!, title: index.dataFoodName ?? "", headline: testJson.headline)
                    }//: LINK

                }//: LOOP
                .onDelete(perform: removeFromCoreData)
                
            }//: LIST
            .navigationTitle("Saved")
            .navigationBarItems(trailing:
                    EditButton()
                    .padding()
            )
        }//: NAVIGATION
        .padding(.top, 70)
        
        //Fetching CoreData
    .onAppear{
        }
        //Storing CoreData
    .onDisappear{
        
        }
    
    }

    //MARK: - FUNCTIONS
    
    func save() throws {
        try self.moc.save()
    }
    
    func removeFromCoreData(at offsets: IndexSet) {
        for index in offsets {
            let storedFoodItem = savings[index]
            moc.delete(storedFoodItem)
            do{
            try save()
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }

}
    //MARK: - PREVIEW
struct SavedFoodView_Previews: PreviewProvider {
    static let testing : [Test] = Bundle.main.decode("TestApple.json")
    
    static var previews: some View {
        SavedFoodListView(testJson:  testJson1[1])
    }
}
