//
//  SavedFoodView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 19/9/21.
//

import SwiftUI
import CoreData

struct SavedFoodView: View {
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
    
    let testJson: Test
    
    var body: some View {
    //MARK: - BODY
        
        NavigationView{
            List{
                ForEach(savings, id: \.self.dataFoodID.description) { index in
                    NavigationLink(destination: FullScreenBodyTextView(imDetection: ImageDetection(), testJson: testJson, takenImage: Binding<UIImage?>.constant(UIImage(data: index.dataFoodImage!)!)))
                    {
                        HStack{
                            Image(uiImage: UIImage(data: index.dataFoodImage!) ?? UIImage(named: "placeholder")!)
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(index.dataFoodName ?? "")
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.primary)
                                Text(testJson.headline)
                                    .font(.footnote)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .padding(.trailing, 8)
    //                            switch index.dataFoodName{
    //                            case "apple":
    //                                Text("Testing for Apple")
    //                            case "banana":
    //                                Text("Testing for Banana")
    //                            default:
    //                                Text("Not sure Whats going on")
    //
    //                            }
    //                                .font(.caption)
    //                                .foregroundColor(Color.secondary)
                            }//: VSTACK
                        }//: HSTACK
                    }//: LINK
                }//: LOOP
                .onDelete(perform: removeFromCoreData)
                
            }//: LIST
            
            .navigationTitle("Saved")
        }//: NAVIGATION
        
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
        SavedFoodView(testJson: testing[0])
    }
}
