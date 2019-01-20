//
//  ViewController.swift
//  iTrash
//
//  Created by Mark Mansur on 2017-08-01.
//  Modified by Kelly Fesler on 1/20/19.
//  Copyright © 2017 Mark Mansur. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.font = label.font.withSize(30)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        
        view.addSubview(label)
        setupLabel()
    }
    
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // search for available capture devices
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        
        // setup capture device, add input to our capture session
        do {
            if let captureDevice = availableDevices.first {
                let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(captureDeviceInput)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        // setup output, add output to our capture session
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(captureOutput)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    // called everytime a frame is captured
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // CHANGE THE "___.model" IN THIS LINE TO CHANGE ML MODEL (originally Resnet50)
        guard let model = try? VNCoreMLModel(for: ImageClassifier().model) else {return}
        
        
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            // change results of scan here
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let Observation = results.first else { return }
            
            DispatchQueue.main.async(execute: {
                //self.label.text = "\(Observation.identifier)"
                
                if Observation.identifier == "hard_plastic" {
                    self.label.text = "Recyclable plastic"
                }
                if Observation.identifier == "soft_plastic" {
                    self.label.text = "Non-recyclable plastic"
                }
                if Observation.identifier == "glass" {
                    self.label.text = "Glass - recycle only if intact"
                }
                if Observation.identifier == "metal" {
                    self.label.text = "Recyclable metal - you CAN do it"
                }
                if Observation.identifier == "paper" {
                    self.label.text = "Recyclable paper"
                }
         //       if Observation.identifier == "compost" {
         //           self.label.text = "Compost"
         //       }
                else {
                    self.label.text = "iTrash"
                }
                
            })
        }
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // executes request
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    func setupLabel() {
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}
