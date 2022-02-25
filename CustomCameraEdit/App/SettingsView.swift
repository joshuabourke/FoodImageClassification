//
//  SettingsView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 10/2/22.
//

import SwiftUI

struct SettingsView: View {
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("savePhoto's") var savePhotos: Bool = false
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    @State var theColorSheme: ColorScheme? = nil

    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    //MARK: - SECTION 1
                    GroupBox(
                        label:
                            SettingsLabelView(labelText: "Nutrify", labelImage: "info.circle")) {
                                Divider().padding(.vertical, 4)
                                
                                HStack(alignment: .center, spacing: 10){
                                    Image("LogoNoBackground")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(9)
                                    Text("Nutrify is an app that will help people learn more about food. The whole idea behind nutrify was to help people become more aware about what they are consuming.")
                                        .font(.footnote)
                                }//: HSTACK
                            }

                    //MARK: - SECTION 2
                    GroupBox(label: SettingsLabelView(labelText: "Customization", labelImage: "paintbrush")){
                        Divider().padding(.vertical, 4)
                        
                        Text("All Nutrify customizations will be found here...")
                            .padding(.vertical, 8)
                            .frame(minHeight: 60)
                            .layoutPriority(1)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        
                        Toggle(isOn: $savePhotos) {
                            if savePhotos {
                                Text("Saving to camera roll".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("yellow1"))
                            } else {
                                Text("Saving to camera roll".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("grey1"))
                            }
                        }
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )
                        
                        Toggle(isOn: $isDarkMode) {
                            
                            if isDarkMode {
                                
                                Text("Light Mode".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                                
                            } else {
                                Text("Dark Mode".uppercased())
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.primary)
                                
                            }
                        }
                        
                        .padding()
                        .background(
                            Color(UIColor.tertiarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        )

                    }
                    
                    //MARK: - SECTION 3
                    GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")){
                        
                        SettingsRowView(name: "Developer", content: "Josh & Daniel")
                        SettingsRowView(name: "Designer", content: "Josh")
                        SettingsRowView(name: "Machine Learning", content: "Daniel")
                        SettingsRowView(name: "Compatibility", content: "iOS 14")
                        SettingsRowView(name: "Website", linkLabel: "Nutrify", linkDestination: "nutrify.app")
                        SettingsRowView(name: "Twitter", linkLabel: "Josh", linkDestination: "twitter.com/tinnie_tv")
                        SettingsRowView(name: "Twitter", linkLabel: "Daniel", linkDestination: "twitter.com/mrdbourke")
                        SettingsRowView(name: "Made with", content: "SwiftUI")
                        SettingsRowView(name: "Version", content: "0.1")
                    }//: BOX

                }//: VSTACK
                .navigationBarTitle(Text("Settings"), displayMode: .large).padding()
                .navigationBarItems(trailing:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                })
                )
            }//: SCROLLVIEW
        }//: NAVIGATION
        .preferredColorScheme(isDarkMode ? .light : .dark)
    }
}

    //MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
