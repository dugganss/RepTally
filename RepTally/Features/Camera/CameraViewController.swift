//
//  CameraViewController.swift
//  RepTally
//
//  Created by Samuel Duggan on 01/12/2024.
//
/*
 This module is the ViewController for the CameraView.
 It essentially starts an AVCaptureSession and configures an input, an output and a PreviewLayer for the session.
 This provides a live feed of the front camera, which can be translated into a SwiftUI View.
 
 This is dependant on containing a Pose Estimator, used to infer poses from the output. It also instantiates an
 Exercise Detector that tracks exercises once a pose has been inferred.
 
 This implementation could adhere more closely to the SOLID principles, however this wasn't a priority during development.
*/
import SwiftUI
import AVFoundation
import Accelerate
import CoreML

class CameraViewController: UIViewController,  AVCaptureVideoDataOutputSampleBufferDelegate {
    var cameraManagerModel: CameraManagerModel?
    private let captureSession = AVCaptureSession()
    private var videoDataOutput = AVCaptureVideoDataOutput()
    private let videoOutputQueue = DispatchQueue(label: "videoOutputQueue")
    var poseEstimator: PoseEstimator?
    private let exerciseDetector = ExerciseDetector()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraInputOutput()
        showCamera()
        poseEstimator?.cameraManagerModel = cameraManagerModel
        addChild(poseEstimator!)
    }
    
    // This function sets up the camera on a background thread. It identifies the front-facing camera device,
    // creates an input from the device, and adds it to an AVCaptureSession configured with high quality.
    // A preview layer displaying the live camera feed is created and added to the view hierarchy on the main thread.
    private func setupCameraInputOutput() {
        self.captureSession.sessionPreset = .high
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            //code adapted from Apple (n.d.-a)
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),//safe device setup
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.captureSession.canAddInput(videoInput) else {
                print("Error: Unable to set up the camera.")
                return
            }
            //end of adapted code
            
            self.captureSession.addInput(videoInput) //adds input to capture session
            
            //code adapted from Ajwani (2019) 
            self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
            self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
            self.videoDataOutput.setSampleBufferDelegate(self, queue: self.videoOutputQueue)
            self.captureSession.addOutput(self.videoDataOutput)
            
            guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
                  connection.isVideoMirroringSupported else {return}
            //end of adapted code
            connection.videoRotationAngle = 90
        }
    }
    
    //sets up view of live camera feed using a preview layer
    private func showCamera(){
        DispatchQueue.main.async { //runs on main thread because the preview layer is a UI component
            if self.cameraManagerModel!.isDisplayCameraFeed{
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession) //creates preview layer with capture session
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = self.view.bounds
                previewLayer.backgroundColor = CGColor(red: 255,green: 255,blue: 255,alpha: 5)
                self.view.layer.addSublayer(previewLayer)
            }
            
            //adds pose estimation overlay view on top of camera preview layer
            self.poseEstimator?.setupOverlayView(in: self.view.bounds)
            self.view.addSubview(self.poseEstimator!.view)
            DispatchQueue.global(qos: .userInitiated).async { //starts capture session on background thread after the preview layer has set up in main thread to prevent delay
                self.captureSession.startRunning()
                
            }
        }
    }
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection){
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else{
            debugPrint("unable to get image from sample buffer")
            return
        }
        poseEstimator?.detectBody(in: frame)
        exerciseDetector.detectExercise()
    }
    
}
