//
//  ContentView.swift
//  CustomCameraEdit
//
//  Created by Josh Bourke on 9/9/21.
//
import SwiftUI
import AVFoundation
 
struct CustomCameraPhotoView: View {
    @State private var image: Image?
    @State private var showingCustomCamera = false
    @State private var inputImage: UIImage?
    var body: some View {
//        NavigationView {
        let detectDirectionDrags = DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                print(value.translation)
                if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30{
                   print("Swipe Left")
                }else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30{
                    print("Swipe Right")
                }else if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                    print("Swipe Up")
                    showingCustomCamera = true
                }else if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                    print("Swipe Down")
                }else {
                    print("Not sure where you swiped aye dawg.")
                }
                
            }

            VStack {
                
                ZStack {
                    CustomCameraView(showingCustomCamera: self.$showingCustomCamera, image: self.$inputImage)
                        .gesture(detectDirectionDrags)
//                    Rectangle().fill(Color.secondary)
                    
//                    if image != nil
//                    {
//                        image?
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                    }
//                    else
//                    {
//                        Text("Take Photo").foregroundColor(.white).font(.headline)
//                    }
                }
//                .onTapGesture {
//                    self.showingCustomCamera = true
//                }
            }
            .fullScreenCover(isPresented: $showingCustomCamera) {
                FullScreenSheetView(sheetViewImage: $inputImage, imDetection: ImageDetection())
            }
            .onAppear(perform: {
                loadImage()
            })
            .edgesIgnoringSafeArea(.all)
//
//        }

    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}


struct CustomCameraView: View {
    @Binding var showingCustomCamera: Bool
    @Binding var image: UIImage?
    @State var didTapCapture: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            
            CustomCameraRepresentable(image: self.$image, didTapCapture: $didTapCapture)
            CaptureButtonView().onTapGesture {
                self.didTapCapture = true
                self.showingCustomCamera = true
            }
            .padding(EdgeInsets().bottom)
        }
    }
    
}


struct CustomCameraRepresentable: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var didTapCapture: Bool
    
    func makeUIViewController(context: Context) -> CustomCameraController {
        let controller = CustomCameraController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: CustomCameraController, context: Context) {
        
        if(self.didTapCapture) {
            cameraViewController.didTapRecord()
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate {
        let parent: CustomCameraRepresentable
        
        init(_ parent: CustomCameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            parent.didTapCapture = false
            
            if let imageData = photo.fileDataRepresentation() {
                parent.image = UIImage(data: imageData)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

class CustomCameraController: UIViewController {
    
    var image: UIImage?
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //DELEGATE
    var delegate: AVCapturePhotoCaptureDelegate?
    
    func didTapRecord() {
        
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: delegate!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func setup() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.iFrame1280x720
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .back)
        for device in deviceDiscoverySession.devices {
            
            switch device.position {
            case AVCaptureDevice.Position.front:
                self.frontCamera = device
            case AVCaptureDevice.Position.back:
                self.backCamera = device
            default:
                break
            }
        }
        
        self.currentCamera = self.backCamera
    }
    
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
        } catch {
            print(error)
        }
        
    }
    func setupPreviewLayer()
    {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
}


struct CaptureButtonView: View {
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
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))

    }
}
