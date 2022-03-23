//
//  LinkView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 23/12/21.
//

import SwiftUI

struct LinkView: View {
    //MARK: - PROPERTIES
    let testJson: Test
    
    //MARK: - BODY
    var body: some View {
        GroupBox(){
            HStack {
                Image(systemName: "globe")
                Text("Wikipedia")
                Spacer()
                
                Group{
                    Image(systemName: "arrow.up.right.square")
                    
                    Link(testJson.name, destination: URL(string: testJson.link) ?? URL(string: "https://wikipedia.org")!)
                }//: GROUP
                .foregroundColor(.accentColor)
            }//: HSTACK
        }//: GROUPBOX
        .padding()
        
        
        
        
        
        
    }
}
    //MARK: PREVIEW
struct LinkView_Previews: PreviewProvider {
    static var previews: some View {
        let foods: [Test] = Bundle.main.decode("TestApple.json")
        
        LinkView(testJson: foods[0])
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
