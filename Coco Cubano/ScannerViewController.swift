//
//  ScannerViewController.swift
//  Coco Cubano
//
//  Created by kavi yadav on 20/12/21.
//

import UIKit
import AVFoundation
import UIKit

class ScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var scanned_data = ""
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var tableNoView: UIView!
    
    @IBOutlet weak var proceedToorder: UIButton!
    @IBOutlet weak var tableNoTxt: UITextField!
    
    @IBOutlet var tableInfoView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        self.tableInfoView.frame = CGRect(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 300)
        self.view.addSubview(tableInfoView)
        self.tableInfoView.roundCorners(corners:[.topLeft,.topRight], radius: 20)
    }
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    override func viewDidLayoutSubviews() {
        self.tableNoView.viewBorder(radius: 5, color: .lightGray, borderWidth: 1)
        self.proceedToorder.viewBorder(radius: 5, color: .clear, borderWidth: 0)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
  
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            self.scanned_data = stringValue
//            NotificationCenter.default.post(name: .qr_code_scanned, object: nil , userInfo: ["data":stringValue])
            self.tableNoTxt.text = "Your Table Number Is : \(stringValue)"
        }

        dismiss(animated: true)
        
    }

    func found(code: String) {
        print(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @IBAction func tapOnBck(_ sender: Any) {
        scanned_data = self.tableNoTxt.text ?? ""
            NotificationCenter.default.post(name: .qr_code_scanned, object: nil , userInfo: ["data":scanned_data])

        self.tableInfoView.removeFromSuperview()
        goBack(vc: self)
    }
    
    @IBAction func tapOnProceedToOrder(_ sender: Any) {
        let table_no = self.tableNoTxt.text ?? ""
        if table_no != ""{
            table_number = table_no
            goToNextVcThroughNavigation(currentVC: self, nextVCname: "CategoryViewController", nextVC: CategoryViewController.self)
        }else{
            AlertMsg(Msg: "Please scan qr code or enter table no", title: "Alert", vc: self)
        }
    }
}
