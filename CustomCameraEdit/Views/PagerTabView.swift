//
//  PagerTabView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 29/1/22.
//

import SwiftUI

struct PagerTabView<Content: View, Label: View>: View {
    //MARK: - PROPERTIES
    var content: Content
    var label: Label

    
    //Selection
    @Binding var selection: Int
    @Binding var isSelected: Bool
    
    init(selection: Binding<Int>, isSelected: Binding<Bool>,@ViewBuilder labels: @escaping()-> Label,@ViewBuilder content: @escaping ()->Content){
        self.content = content()
        self.label = labels()
        
        self._selection = selection
        self._isSelected = isSelected
    }
    
    //Offset for page Scroll
    @State var offset: CGFloat = 0
    @State var maxTabs: CGFloat = 0
    @State var tabOffSet: CGFloat = 0
    
    
    //MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            OffsetPageTabView(selection: $selection, offset: $offset, isSelected: $isSelected) {
                HStack(spacing: 0) {
                    content
                }//: HSTACK
                
                //Getting how many tabs are there by getting the total Content Size...
                .overlay(
                    GeometryReader{ proxy in
                        Color.clear
                            .preference(key: TabPreferencekey.self, value: proxy.frame(in: .global))
                        
                    }
                )
                //When Value Changes...
                .onPreferenceChange(TabPreferencekey.self) {proxy in
                    let minX = -proxy.minX
                    let maxWidth = proxy.width
                    let screenWidth = getScreenBounds().width
                    let maxTabs = (maxWidth / screenWidth).rounded()
                    
                    //Getting Tab Offset...
                    let progress = minX / screenWidth
                    let tabOffset = progress * (screenWidth / maxTabs)
                    
                    self.tabOffSet = tabOffset
                    
                    self.maxTabs = maxTabs
                }
            }
            HStack(spacing: 0){
                label
                    .padding(.top)
            }
            
            //MARK: - TO CHANGE TAB BAR
            //For Tap to change tab...
            .overlay(
                HStack(spacing: 0){
                    ForEach(0..<Int(maxTabs), id: \.self) {index in
                        Rectangle()
                            .background(.ultraThinMaterial).opacity(0.1)
//                            .fill(Color.gray.opacity(0.3))
                            .ignoresSafeArea(edges: .bottom)
                            .frame(height: 54, alignment: .bottom)
                            
                            
                            
                            .onTapGesture {
                                //Changing Offset
                                //Based on index...
                                let newOffset = CGFloat(index) *
                                getScreenBounds().width
                                self.offset = newOffset
                            }
                    }//: LOOP
                }//: HSTACK
            )//: OverLay
            
            
        }
    }
}
    //MARK: - PREVIEW
struct PagerTabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TabPreferencekey: PreferenceKey {
    
    static var defaultValue: CGRect = .init()
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
