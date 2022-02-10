//
//  SavedItemView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 25/1/22.
//

import SwiftUI

struct SavedItemView: View {
   // MARK: - PROPERTIES
    var image: Data
    
    var title: String
    
    var headline: String
    
//    var date: String
    
    //MARK: - BODY
    var body: some View {
        HStack{
            Image(uiImage: UIImage(data: image) ?? UIImage(named: "placeholder")!)
//            Image(uiImage: UIImage(named: "placeholder")!)
                .centerCropped()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 3)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                Text(headline)
                    .foregroundColor(Color("grey1"))
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.trailing, 8)
                    


            }//: VSTACK
//            
//            Spacer()
//            
//            
//            VStack {
//                Spacer()
//                Text(date)
//                        .font(.footnote)
//                    .foregroundColor(.gray)
//            }
                

        }//: HSTACK
        .padding(.vertical, 10)
    }
}
        //MARK: - PREVIEW
//struct SavedItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedItemView(title: "Apple", headline: "This is an Apple.")
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
