//
//  ContentView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/9/21.
//
import SwiftUI
import AVFoundation
 
struct CustomCameraPhotoView: View {
//    @State private var image: Image?
//    @State private var showingCustomCamera = false
//    @State private var inputImage: UIImage?
    @State private var image: UIImage?
    @State private var didOutPutImage = false
    @State private var selcetion = 0
    let customCameraController = CustomCameraController()
    var body: some View {

        TabView(selection: $selcetion){
            
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
                    FullScreenSheetView(sheetViewImage: $image, imDetection: ImageDetection(), didTakePhoto: $didOutPutImage)
                })

                .onAppear {
                    customCameraRepresentable.startRunningCaptureSession()
                }
                .onDisappear {
                    customCameraRepresentable.stopRunningCaptureSession()
                }

                
        //        if let image = image {
        //            Image(uiImage: image)
        //                .resizable()
        //                .aspectRatio(contentMode: .fit)
        //        }
//            VStack{
//                ZStack {
//                    CustomCameraView(showingCustomCamera: self.$showingCustomCamera, image: self.$inputImage)
//
//            }
//            .sheet(isPresented: $showingCustomCamera) {
//                FullScreenSheetView(sheetViewImage: $inputImage, imDetection: ImageDetection())
//
//            }
//            .onChange(of: showingCustomCamera, perform: { newValue in
//                loadImage()
//            })
//
//            .edgesIgnoringSafeArea(.all)
//
//            }

            
            
                .tag(0)
                .tabItem {
                    Image(systemName: (selcetion == 0 ? "camera.fill" : "camera"))
                    
                }
            
            SavedFoodView()
                .tag(1)
                .tabItem {
                Image(systemName: (selcetion == 1 ? "bookmark.fill" : "bookmark"))
                        
            }
            
            
            
        }.tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
//        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//            .indexViewStyle(.page)
//            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    
    
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        image = Image(uiImage: inputImage)
//    }
}

import SwiftUI

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
                }
            }
        }
    }
    
    private func cameraView(frame: CGRect) -> CustomCameraRepresentable {
        customCameraRepresentable.cameraFrame = frame
        customCameraRepresentable.imageCompletion = imageCompletion
        return customCameraRepresentable
    }
}

import SwiftUI

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

struct CaptureButtonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width: 65, height: 65)
        
                    Circle()
                        .stroke(Color.white,lineWidth: 2)
                        .frame(width: 75, height: 75)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
        
    }
}

import SwiftUI
import AVFoundation

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
