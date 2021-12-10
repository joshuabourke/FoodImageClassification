//
//  SavedFoodView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 19/9/21.
//

import SwiftUI
import CoreData

struct SavedFoodView: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var imageAndFoodNameFeeder: ImageAndNameFeeder
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saved.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Saved.dataFoodName, ascending: true), NSSortDescriptor(keyPath: \Saved.dataFoodImage, ascending: true), NSSortDescriptor(keyPath: \Saved.dataPredicPercent, ascending: true), NSSortDescriptor(keyPath: \Saved.dataFoodID, ascending: true)])
    
    var savings: FetchedResults<Saved>
    
    var body: some View {
        NavigationView{
            List{
                ForEach(savings, id:\.self) { index in
                    HStack{
                        Image(uiImage: UIImage(data: index.dataFoodImage!) ?? UIImage(named: "placeholder")!)
                            .resizable()
                            .frame(width: 125, height: 125)
                            .cornerRadius(12)
                            .padding()
                        Text(index.dataFoodName ?? "")
                            .font(.bold(.title2)())
                    }

                }
                .onDelete(perform: removeFromCoreData)
                
            }
            
            .navigationBarTitle(Text("Saved"))
            .navigationBarHidden(false)
        }
        
        //Fetching CoreData
    .onAppear{
       
        }
        //Storing CoreData
    .onDisappear{
        
        }
    
    }

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

struct SavedFoodView_Previews: PreviewProvider {
    static var previews: some View {
        SavedFoodView()
    }
}
