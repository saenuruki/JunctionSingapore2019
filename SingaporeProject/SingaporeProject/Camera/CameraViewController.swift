//
//  CameraViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import Photos
import PhotosUI
import CoreML
import Vision

class CameraViewController: UIViewController {
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    fileprivate(set) var viewModel = CameraViewModel()

    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    /// - Tag: MLModelSetup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNet().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
        configureVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCamera()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // メモリの解放
        //        self.view.layer.insertSublayer(previewLayer!, at: 0)
        previewLayer?.removeFromSuperlayer()
        captureSession.stopRunning()
        captureSession.outputs.forEach { captureSession.removeOutput($0) }
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CameraViewController {
    
    private func configureUI() {
        
    }
    
    private func configureButton() {
        captureButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                guard let wself = self else { return }
                wself.captureAction()
            })
            .disposed(by: bag)
        
        backButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                guard let wself = self else { return }
                wself.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    func configureVM() {
        viewModel
            .dismissFlag$
            .subscribe(onNext: { [weak self] isDismissed in
                guard let wself = self else { return }
                //                wself.dismiss(animated: true, completion: {
                //                    wself.inferDelegate.modalDidFinished(modalText: "hogehogehgoegheo")
                //                })
                // falseに戻す
                if isDismissed {
                    let vc = GameStartViewController.create(itemType: wself.viewModel.itemType.value)
                    wself.navigationController?.pushViewController(vc, animated: true)
                    wself.viewModel.dismissFlagTrigger.onNext(false)
                }
            })
            .disposed(by: bag)
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        stillImageOutput = AVCapturePhotoOutput()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        let device = AVCaptureDevice.default(for: .video)
        do {
            let input = try AVCaptureDeviceInput(device: device!)
            
            // 入力
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                
                // 出力
                if captureSession.canAddOutput(stillImageOutput!) {
                    
                    captureSession.addOutput(stillImageOutput!)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer?.videoGravity = .resizeAspectFill
                    previewLayer?.connection?.videoOrientation = .portrait
                    previewLayer?.frame = self.view.bounds
                    self.view.layer.insertSublayer(previewLayer!, at: 0)
                    captureSession.startRunning() // カメラ起動
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func captureAction() {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        self.stillImageOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
//        classificationLabel.text = "Classifying..."
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else { return }
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
//                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
//                self.classificationLabel.text = "Nothing recognized."
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(5)
                let labelArray = topClassifications.map { $0.identifier }
//                let descriptions = topClassifications.map { classification in
//                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
//                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
//                }
//                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
                print("==================================")
                print(labelArray.count)
                print(labelArray)
                self.viewModel.detectItemType(by: labelArray)
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    // MMEO: - 写真撮影完了後に呼び出される
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
//
        guard let photo = UIImage(data: imageData!) else { return }
//        // アルバムに追加.
//        UIImageWriteToSavedPhotosAlbum(photo!, self, nil, nil)
        
        updateClassifications(for: photo)

//
        let vc = CameraConfirmViewController.create(viewModel: viewModel)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension CameraViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
