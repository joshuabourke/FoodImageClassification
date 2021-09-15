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
    @StateObject var imDetection: ImageDetection
    @State var foodNameTitle: String = "Food Name"
    @State var didClickClose: Bool = false
    @State var didClickSave: Bool = false
//    @ObservedObject var imageDetectionVM: ImageDetectionViewModel
//    var imageDetectionManager: ImageDetectionManager
//
//    init(){
//        self.imageDetectionManager = ImageDetectionManager()
//        self.imageDetectionVM = ImageDetectionViewModel(manager: imageDetectionManager)
    
    var body: some View {
        VStack {
            ZStack(alignment: .top){
                Image(uiImage: sheetViewImage ?? UIImage(named: "placeholder")!)
                    .resizable()
                    .frame(width: 325, height: 450)
                    .cornerRadius(12)
                    .onChange(of: sheetViewImage, perform: { value in
                        imDetection.imageDetectionVM.detect(sheetViewImage)
                       foodNameTitle = imDetection.imageDetectionVM.predictionLabel
                        didClickClose = false
                        didClickSave = false
                    })
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
                    didClickSave.toggle()
                    }, label: {
                        Image(systemName: self.didClickSave == true ? "bookmark.fill" : "bookmark")
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
    
}

struct FullScreenSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenSheetView(sheetViewImage: Binding<UIImage?>.constant(UIImage(named: "placeholder")!), imDetection: ImageDetection())
    }
}
