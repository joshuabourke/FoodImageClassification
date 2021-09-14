//
//  FullScreenSheetView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 13/9/21.
//

import SwiftUI

struct FullScreenSheetView: View {
    @Environment(\.presentationMode) var presentataionMode
    @Binding var sheetViewImage: UIImage?
    
    var body: some View {
        VStack {
            ZStack(alignment: .top){
                Image(uiImage: sheetViewImage ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 325, height: 450)
                    .cornerRadius(12)
            HStack{
                    Spacer()
                Button(action: {
                        sheetViewImage = UIImage()
                        presentataionMode.wrappedValue.dismiss()
                        
                    }, label: {
                    Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(.green)
                })
                    .frame(width: 15, height: 20)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    Spacer(minLength: 200)
                    
                    Spacer()
                    
                Button(action: {
                    }, label: {
                    Image(systemName: "bookmark")
                        .resizable()
                        .foregroundColor(.green)
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
            Text("Food Name")
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

struct FullScreenSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenSheetView(sheetViewImage: Binding<UIImage?>.constant(UIImage(named: "placeholder")!))
    }
}
