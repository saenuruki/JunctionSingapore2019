//
//  MarketingViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/29.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MarketingViewController: UIViewController {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    fileprivate let bag = DisposeBag()
    fileprivate(set) var viewModel = MarketingViewModel()

    static func create(itemType: ItemType) -> UIViewController {
        let vc = R.storyboard.marketing.instantiateInitialViewController()!
        vc.viewModel.itemTypeTrigger.onNext(itemType)
        return vc
    }
    
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

extension MarketingViewController {
    
    private func configureUI() {
        titleLabel.text = viewModel.getText(by: viewModel.itemType.value)
        itemImageView.image = viewModel.getImage(by: viewModel.itemType.value)
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


