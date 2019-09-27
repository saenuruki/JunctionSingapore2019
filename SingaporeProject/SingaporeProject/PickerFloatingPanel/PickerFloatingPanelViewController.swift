//
//  PickerFloatingPanelViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FloatingPanel

class PickerFloatingPanelViewController: UIViewController {
    
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    fileprivate private(set) weak var viewModel: ARAdminViewModel!
    fileprivate let bag = DisposeBag()
    
    static func create(_ viewModel: ARAdminViewModel) -> UIViewController {
        let viewController = R.storyboard.pickerFloatingPanel.instantiateInitialViewController()!
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVM()
        configurePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PickerFloatingPanelViewController {
    
    func configureVM() {
        viewModel
            .selectedEvent$
            .map { $0.name }
            .bind(to: selectedLabel.rx.text)
            .disposed(by: bag)
    }
    
    private func configurePicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
    }
}

// MARK: - UIPickerViewDelegate
extension PickerFloatingPanelViewController: UIPickerViewDelegate {
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedEventTrigger.onNext(viewModel.events.value[row])
    }
}

// MARK: - UIPickerViewDataSource
extension PickerFloatingPanelViewController: UIPickerViewDataSource {
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.events.value.count
    }
    
    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return viewModel.events.value[row].name
    }
}

// MARK: My custom layout

class FloatingPanelStocksLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.half, .tip]
    }
    
    var topInteractionBuffer: CGFloat { return 0.0 }
    var bottomInteractionBuffer: CGFloat { return 0.0 }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        //        case .full: return 56.0
        case .half: return 320.0
        case .tip: return 120.0
        default: return nil
        }
    }
    
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}

// MARK: My custom behavior

class FloatingPanelStocksBehavior: FloatingPanelBehavior {
    var velocityThreshold: CGFloat {
        return 15.0
    }
    
    func interactionAnimator(_ fpc: FloatingPanelController, to targetPosition: FloatingPanelPosition, with velocity: CGVector) -> UIViewPropertyAnimator {
        let timing = timeingCurve(to: targetPosition, with: velocity)
        return UIViewPropertyAnimator(duration: 0, timingParameters: timing)
    }
    
    private func timeingCurve(to: FloatingPanelPosition, with velocity: CGVector) -> UITimingCurveProvider {
        let damping = self.damping(with: velocity)
        return UISpringTimingParameters(dampingRatio: damping,
                                        frequencyResponse: 0.4,
                                        initialVelocity: velocity)
    }
    
    private func damping(with velocity: CGVector) -> CGFloat {
        switch velocity.dy {
        case ...(-velocityThreshold):
            return 0.7
        case velocityThreshold...:
            return 0.7
        default:
            return 1.0
        }
    }
}
