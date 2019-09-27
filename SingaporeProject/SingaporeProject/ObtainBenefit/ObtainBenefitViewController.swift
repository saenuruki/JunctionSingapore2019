//
//  ObtainBenefitViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher

class ObtainBenefitViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    fileprivate let bag = DisposeBag()
    fileprivate var event = Event()
    
    static func create(with event: Event) -> UIViewController {
        let vc = R.storyboard.obtainBenefit.instantiateInitialViewController()!
        vc.event = event
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

extension ObtainBenefitViewController {
    
    private func configureUI() {
        popUpView.layer.cornerRadius = 10
        popUpView.layer.masksToBounds = true
        
        selectedImageView.layer.cornerRadius = 10
        selectedImageView.layer.masksToBounds = true
        selectedImageView.kf.setImage(with: URL(string: event.imageURLString))
        
        confirmView.layer.cornerRadius = 10
        confirmView.layer.masksToBounds = true
        
        nameLabel.text = event.name
        areaLabel.text = event.area
        descriptionLabel.text = event.description
    }
    
    private func configureButton() {
        
        confirmButton
            .rx.tap
            .throttle(0.7, latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let wself = self else { return }
                wself.dismiss(animated: false, completion: nil)
            })
            .disposed(by: bag)
        
    }
}


