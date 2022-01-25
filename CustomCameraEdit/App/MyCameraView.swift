//
//  ContentView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/9/21.
//
import SwiftUI
import AVFoundation
 
struct CustomCameraPhotoView: View {
    //MARK:  - PROPERTIES
    @State private var image: UIImage?
    @State private var didOutPutImage = false
    @State private var selection = 0
    let customCameraController = CustomCameraController()
    
    //Timer Variables
    @State var timeRemaining = 2
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isActive = true
    
    
    let testJson: [Test] = Bundle.main.decode("TestApple.json")
    
    //Custom Tabbar Properties
    
    @State var selectedTab = "camera"
    @Namespace var animation
    @StateObject var modelData = ModelView()
    
    
    //MARK: - BODY
    var body: some View {
        
        VStack(spacing: 0){
            GeometryReader { _ in
                ZStack {
                    //Tabs go here...
                    let customCameraRepresentable = CustomCameraRepresentable(
                        cameraFrame: .zero,
                        imageCompletion: { _ in }
                    )
                    
                        CustomCameraView(
                            customCameraRepresentable: customCameraRepresentable,
                            imageCompletion: { newImage in
                                self.image = newImage
                                didOutPutImage = true
                                
                            }
                        )
                        
                        .sheet(isPresented: $didOutPutImage, content: {
        //                    FullScreenSheetView(sheetViewImage: $image, imDetection: ImageDetection(), didTakePhoto: $didOutPutImage)
                            DetailedSheetView(imDetection: ImageDetection(),testJson: testJson[0], takenImage: $image)
                        })
                    //When the app returns back to the camera screen it turns the camera preview back onx
                        .onAppear {
                                customCameraRepresentable.startRunningCaptureSession()
                        }
                        .onDisappear {
                            //When the app moves to the saved screen it should run a 2 second timer then stop the camera from running.
                            guard self .isActive else {return}
                            if self.timeRemaining > 0 {
                                self.timeRemaining -= 1
                            }
                            if self .timeRemaining <= 0 {
                                print("Disappear Timer Finished")
                                customCameraRepresentable.stopRunningCaptureSession()
                                cancelTimer()
                            }
                            
                            
                        }
                    //Checks to see if the app has gone into the back ground and stop timer if so.

                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            self.isActive = false
                        }
                    .onReceive(NotificationCenter.default.publisher(for:UIApplication.willEnterForegroundNotification)) { _ in
                            self.isActive = true
                        }

                    .opacity(selectedTab == "camera" ? 1 : 0)
                    .padding(.vertical)
                    
                    SavedFoodListView(testJson: testJson[0])
                        .opacity(selectedTab == "bookmark" ? 1 : 0)
                        .padding(.vertical)
                    
                    
                }//: ZSTACK
            }//: GEOREADER
            .onChange(of: selectedTab) {_ in
                switch(selectedTab) {
                case "bookmark": if !modelData.isBookMarkLoaded{modelData.loadBookMark()}
//                case "camera": if !modelData.isCameraLoaded{modelData.loadCamera()}
//                case "square": if !modelData.isSquareLoaded{modelData.loadSquare()}
                default: ()
                }
            }
            //Tab View...
            HStack(spacing: 0){
                
                ForEach(tabs, id:\.self) { tab in
                    Spacer()
                    TabButtonView(title: tab, selectedTab: $selectedTab, animation: animation)
                    Spacer()
                    if tab != tabs.last {
                        
                    }
                }
                
            }//: HSTACK
            .padding(.vertical, 6)
            .background(Color.clear)
        }
//        .ignoresSafeArea(.all, edges: [.bottom, .top])
//        .background(Color.black.opacity(0.6).ignoresSafeArea(.all, edges: .all))
        
    }
    
 var tabs = ["camera", "bookmark"]
            

    func cancelTimer () {
        self.timer.makeConnectable().connect().cancel()
        return
    }
}

import SwiftUI
//MARK: - CUSTOM CAMERA VIEW
struct CustomCameraView: View {
    var customCameraRepresentable: CustomCameraRepresentable
    var imageCompletion: ((UIImage) -> Void)
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                //Camera Frame
                let frame = CGRect(x: 0, y: 0, width: geometry.size.width, height: geometry.size.height)
                cameraView(frame: frame)
                
                HStack {
                    CameraControlsView(captureButtonAction: { [weak customCameraRepresentable] in
                        customCameraRepresentable?.takePhoto()
                    })
                }//: HSTACK
            }
        }
        .ignoresSafeArea(.all, edges: [.top, .bottom])
        .cornerRadius(12)
        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
    }
    
    private func cameraView(frame: CGRect) -> CustomCameraRepresentable {
        customCameraRepresentable.cameraFrame = frame
        customCameraRepresentable.imageCompletion = imageCompletion
        return customCameraRepresentable
    }
}

import SwiftUI
//MARK: - CAMERA CONTROLS VIEW
struct CameraControlsView: View {
    var captureButtonAction: (() -> Void)
    
    var body: some View {
        CaptureButtonView()
            .onTapGesture {
                captureButtonAction()
            }
    }
}

import SwiftUI
//MARK: - CAPTURE BUTTON VIEW
struct CaptureButtonView: View {
    
    @State private var isAnimating: Bool = false
    @State private var animation: Double = 0.0
    
    var body: some View {
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width: 65, height: 65)

                    Circle()
                        .stroke(Color.accentColor,lineWidth: 2)
                        .frame(width: 70, height: 70, alignment: .center)
                        .scaleEffect(0.9 + CGFloat(animation))
                        .opacity(1 - animation)
                        
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
  
                .onAppear {
                    withAnimation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false)){
                        animation = 1
                    }
                }
    }
}

import SwiftUI
import AVFoundation
//MARK: - CUSTOM CAMERA CONTROLLER CLASS
final class CustomCameraController: UIViewController {
    static let shared = CustomCameraController()
    
    private var captureSession = AVCaptureSession()
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var photoOutput: AVCapturePhotoOutput?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    weak var captureDelegate: AVCapturePhotoCaptureDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func configurePreviewLayer(with frame: CGRect) {
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        cameraPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer.frame = frame
        
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
        
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        
        guard let delegate = captureDelegate else {
            print("delegate nil")
            return
        }
        photoOutput?.capturePhoto(with: settings, delegate: delegate)
    }
    
    // MARK: Private
    
    private func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )
        
        for device in deviceDiscoverySession.devices {
            switch device.position {
            case AVCaptureDevice.Position.front:
                frontCamera = device
            case AVCaptureDevice.Position.back:
                backCamera = device
            default:
                break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    
    private func setupInputOutput() {
        do {
            guard let currentCamera = currentCamera else { return }
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
            
            captureSession.addInput(captureDeviceInput)
            
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray(
                [AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
                completionHandler: nil
            )
            
            guard let photoOutput = photoOutput else { return }
            captureSession.addOutput(photoOutput)
        } catch {
            print(error)
        }
    }
}

//MARK: - CUSTOM CAMERA REPRESENTABLE

final class CustomCameraRepresentable: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
    
    init(cameraFrame: CGRect, imageCompletion: @escaping ((UIImage) -> Void)) {
        self.cameraFrame = cameraFrame
        self.imageCompletion = imageCompletion
    }
    
    var cameraFrame: CGRect
    var imageCompletion: ((UIImage) -> Void)
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CustomCameraController {
        CustomCameraController.shared.configurePreviewLayer(with: cameraFrame)
        CustomCameraController.shared.captureDelegate = context.coordinator
        return CustomCameraController.shared
    }
    
    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {}
    
    func takePhoto() {
        CustomCameraController.shared.takePhoto()
    }
    
    func startRunningCaptureSession() {
        CustomCameraController.shared.startRunningCaptureSession()
    }
    
    func stopRunningCaptureSession() {
        CustomCameraController.shared.stopRunningCaptureSession()
    }
}

//MARK: - CUSTOM CARMERA REP EXTENSION
extension CustomCameraRepresentable {
    final class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        private let parent: CustomCameraRepresentable
        
        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput,
                         didFinishProcessingPhoto photo: AVCapturePhoto,
                         error: Error?) {
            if let imageData = photo.fileDataRepresentation() {
                guard let newImage = UIImage(data: imageData) else { return }
                parent.imageCompletion(newImage)
            }
//            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}




//struct CustomCameraView: View {
//    @Binding var showingCustomCamera: Bool
//    @Binding var image: UIImage?
//    @State var didTapCapture: Bool = false
//    var body: some View {
//        ZStack(alignment: .bottom) {
//
//            CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture)
//            CaptureButtonView().onTapGesture {
//                self.didTapCapture = true
//                self.showingCustomCamera = true
//            }
//            .padding(EdgeInsets().bottom)
//        }
//    }
//
//}
//
//
//struct CustomCameraRepresentable: UIViewControllerRepresentable {
//
//    @Environment(\.presentationMode) var presentationMode
//    @Binding var image: UIImage?
//    @Binding var didTapCapture: Bool
//
//    func makeUIViewController(context: Context) -> CustomCameraController {
//        let controller = CustomCameraController()
//        controller.delegate = context.coordinator
//        return controller
//    }
//
//    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {
//
//        if(self.didTapCapture) {
//            cameraViewController.didTapRecord()
//
//        }
//    }
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
//        let parent: CustomCameraRepresentable
//
//        init(_ parent: CustomCameraRepresentable) {
//            self.parent = parent
//        }
//
//        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//
//            parent.didTapCapture = false
//
//            if let imageData = photo.fileDataRepresentation() {
//                parent.image = UIImage(data: imageData)
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}
//
//class CustomCameraController: UIViewController {
//
//
//    var captureSession = AVCaptureSession()
//    var backCamera: AVCaptureDevice?
//    var frontCamera: AVCaptureDevice?
//    var currentCamera: AVCaptureDevice?
//    var photoOutput: AVCapturePhotoOutput?
//    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
//
//    //DELEGATE
//    var delegate: AVCapturePhotoCaptureDelegate?
//
//    func didTapRecord() {
//
//        let settings = AVCapturePhotoSettings()
//        photoOutput?.capturePhoto(with: settings, delegate: delegate!)
//
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setup()
//    }
//    func setup() {
//        setupCaptureSession()
//        setupDevice()
//        setupInputOutput()
//        setupPreviewLayer()
//        startRunningCaptureSession()
//    }
//    func setupCaptureSession() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//    }
//
//    func setupDevice() {
//        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
//                                                                      mediaType: AVMediaType.video,
//                                                                      position: .back)
//        for device in deviceDiscoverySession.devices {
//
//            switch device.position {
//            case AVCaptureDevice.Position.front:
//                self.frontCamera = device
//            case AVCaptureDevice.Position.back:
//                self.backCamera = device
//            default:
//                break
//            }
//        }
//
//        self.currentCamera = self.backCamera
//    }
//
//
//    func setupInputOutput() {
//        do {
//
//            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
//            captureSession.addInput(captureDeviceInput)
//            photoOutput = AVCapturePhotoOutput()
//            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
//            captureSession.addOutput(photoOutput!)
//
//        } catch {
//            print(error)
//        }
//
//    }
//    func setupPreviewLayer()
//    {
//        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//        self.cameraPreviewLayer?.frame = self.view.frame
//        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
//
//    }
//    func startRunningCaptureSession(){
//        captureSession.startRunning()
//    }
//
//    func stopRunningCaptureSession(){
//        captureSession.stopRunning()
//    }
//}
//
//
//struct CaptureButtonView: View {
//    @State private var animationAmount: CGFloat = 1
//    var body: some View {
//        ZStack{
//            Circle()
//                .fill(Color.white)
//                .frame(width: 65, height: 65)
//
//            Circle()
//                .stroke(Color.white,lineWidth: 2)
//                .frame(width: 75, height: 75)
//        }
//        .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
//
//    }
//}
