//
//  ItemDetailViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var faButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ItemDetailViewController {
    
    private func configureUI() {
        
    }
    
    private func configureButton() {
        
        faButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                let vc = GameStartViewController.create(itemType: .marketing)
                wself.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
        
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
