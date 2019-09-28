//
//  GameStartViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameStartViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var easyView: UIView!
    @IBOutlet weak var easyImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
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

extension GameStartViewController {
    
    private func configureUI() {
    }
    
    private func configureButton() {
        
        backButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
}
