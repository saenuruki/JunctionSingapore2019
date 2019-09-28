//
//  HomeViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var campaignButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController {
    
    private func configureUI() {
    }
    
    private func configureButton() {
        
        cameraButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                let vc = R.storyboard.camera.instantiateInitialViewController()!
                wself.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
        
        campaignButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                let vc = R.storyboard.itemDetail.instantiateInitialViewController()!
                wself.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
}


