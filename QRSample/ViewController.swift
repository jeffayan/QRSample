//
//  ViewController.swift
//  QRSample
//
//  Created by CSS on 24/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var video = AVCaptureVideoPreviewLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadQR()
    }

    // Loading AVSession
    
    private func loadQR(){
        
        
        let session = AVCaptureSession()
        
        guard  let captureDevice = AVCaptureDevice.default(for: .video) else {
           print("Failed to Capture Device")
           return
       }
        
        
        // Adding session input
        do {
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            session.addInput(input)
            
        } catch let err {
            
            print("Failed "+err.localizedDescription)
        }
        
        
        // Adding session output
        
        let output = AVCaptureMetadataOutput()
        
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [.qr]  // Adding QR as Meta Object
        
        
        video = AVCaptureVideoPreviewLayer(session: session)
        
        video.frame = self.view.bounds
        
        view.layer.addSublayer(video)
        
        session.startRunning()
        
        
    }


}


extension ViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count>0, let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject, object.type == .qr {
            
            print("Output",object.stringValue ?? "")
        }
        
    }
    
}

