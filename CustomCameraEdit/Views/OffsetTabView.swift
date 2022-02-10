//
//  OffsetTabView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 29/1/22.
//

import SwiftUI


//Custom View that will return offset for paging control
struct OffsetPageTabView<Content: View>: UIViewRepresentable {
    
    
    var content: Content
    @Binding var offset: CGFloat
    @Binding var selection: Int
    @Binding var isSelected: Bool
    
    func makeCoordinator() -> Coordinator {
        return OffsetPageTabView.Coordinator(parent: self)
    }
    
    init(selection: Binding<Int>, offset: Binding<CGFloat>, isSelected: Binding<Bool>, @ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self._offset = offset
        self._selection = selection
        self._isSelected = isSelected
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollview = UIScrollView()
        
        //Extracting SwiftUI View and embedding into UIKit ScrollView....
        
        let hostview = UIHostingController(rootView: content)
        hostview.view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            hostview.view.topAnchor.constraint(equalTo: scrollview.topAnchor),
            hostview.view.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
            hostview.view.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            hostview.view.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
        
            //If you are using vertical paging then dont declare height
            hostview.view.heightAnchor.constraint(equalTo: scrollview.heightAnchor)
        ]
        scrollview.addSubview(hostview.view)
        scrollview.addConstraints(constraints)
        
        //Enabling Paging...
        scrollview.isPagingEnabled = true
        scrollview.showsVerticalScrollIndicator = false
        scrollview.showsHorizontalScrollIndicator = false
        scrollview.bounces = false
        //Setting Delegate...
        
        scrollview.delegate = context.coordinator
        
        return scrollview
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        //Need to update only when offset changed manually...
        //Just check the current scroll view offsets...
        
        let currentOffset = uiView.contentOffset.x
        
        if currentOffset != offset {
            print("Updating")
            uiView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
        }
    }
    
    //Pager Offset...
    class Coordinator: NSObject, UIScrollViewDelegate {
        
        var parent: OffsetPageTabView
        
        init(parent: OffsetPageTabView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            
            //Safer side updating selection on scroll...
            let maxSize = scrollView.contentSize.width
            let currentSelection = (offset / maxSize).rounded()
            parent.selection = Int(currentSelection)
            
            if parent.selection > 0 {
                parent.isSelected = false
            } else if parent.selection < 1 {
                parent.isSelected = true
            }
            
            parent.offset = offset
        }
        
    }
}
