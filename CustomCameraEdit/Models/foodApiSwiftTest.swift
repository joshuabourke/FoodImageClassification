//
//  foodApiSwiftTest.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 18/11/21.
//

import SwiftUI
@available(iOS 15.0, *)
struct foodApiSwiftTest: View {
    @StateObject private var foodResults = FoodListViewModel()
    @State private var searchText: String = ""
    
  
    var body: some View {
        NavigationView {
            List(foodResults.results, id:\.fat) { result in
                Text(result.fat)
            }.listStyle(.plain)
                .searchable(text: $searchText)
                .onChange(of: searchText) { value in
                    async {
                        if !value.isEmpty  {
                           await foodResults.search(name: value)
                        } else {
                            foodResults.results.removeAll()
                        }
                    }
                }
                .navigationTitle("Foods")
        }
    }
}
@available(iOS 15.0, *)
struct foodApiSwiftTest_Previews: PreviewProvider {
    static var previews: some View {
        foodApiSwiftTest()
    }
}
