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

class CameraViewController: UIViewController {
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    fileprivate let bag = DisposeBag()

    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
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
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    // MMEO: - 写真撮影完了後に呼び出される
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let imageData = photo.fileDataRepresentation()
        
        let photo = UIImage(data: imageData!)?.croppingToCenterSquare()
        // アルバムに追加.
        UIImageWriteToSavedPhotosAlbum(photo!, self, nil, nil)
        viewModel.capturedImageTrigger.onNext(photo ?? UIImage())
        
        let vc = CameraConfirmViewController.create(viewModel: viewModel, searchViewModel: searchViewModel)
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
