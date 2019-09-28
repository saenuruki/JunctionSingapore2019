//
//  CameraConfirmViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/29.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class CameraConfirmViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var gameVuew: UIView!
    @IBOutlet weak var gameButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    fileprivate private(set) weak var viewModel: CameraViewModel!
    
    fileprivate var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    fileprivate lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(self.goBackPageByPan(_:)))
        recognizer.delegate = self
        return recognizer
    }()
    
    static func create(viewModel: CameraViewModel) -> UIViewController {
        let vc = R.storyboard.cameraConfirm.instantiateInitialViewController()!
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CameraConfirmViewController {
    
    private func configureUI() {
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        gameVuew.layer.cornerRadius = 32
        gameVuew.layer.masksToBounds = true
    }
    
    private func configureButton() {
        
        gameButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.dismiss(animated: false, completion: {
                    // 親のViewControllerも閉じるためのフラグを立てる
                    wself.viewModel.dismissFlagTrigger.onNext(true)
                })
            })
            .disposed(by: bag)
        
        cancelButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }
    
    @objc private func goBackPageByPan(_ sender: UIPanGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizer.State.changed {
            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
            if touchPoint.y - initialTouchPoint.y > statusBarHeight {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}

// MARK: - Gesture recognizer delegate
extension CameraConfirmViewController: UIGestureRecognizerDelegate {}

