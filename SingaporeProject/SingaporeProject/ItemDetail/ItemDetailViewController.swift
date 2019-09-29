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
    @IBOutlet weak var faView: UIView!
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
        
        faView.layer.cornerRadius = 35
        faView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        faView.layer.shadowOpacity = 0.2
        faView.layer.shadowColor = UIColor.black.cgColor
        faView.layer.shadowRadius = 2.0
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
