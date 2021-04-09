//
//  CustomDialogController.swift
//  ATTSample
//
//  Created by ryokosuge on 2021/04/09.
//

import UIKit

protocol CustomDialogControllerDelegate: class {
    func customDialogDidTouchCancel(_ customDialog: CustomDialogController)
    func customDialogDidTouchOK(_ customDialog: CustomDialogController)
}

class CustomDialogController: UIViewController {

    @IBOutlet weak var contentView: UIView?

    weak var delegate: CustomDialogControllerDelegate?

    init() {
        let nibName = "CustomDialogController"
        super.init(nibName: nibName, bundle: .main)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentView?.layer.cornerRadius = 8.0
    }

}

// MARK: - Action
extension CustomDialogController {

    @IBAction func didTouchCancel(button: UIButton) {
        delegate?.customDialogDidTouchCancel(self)
    }

    @IBAction func didTouchOK(button: UIButton) {
        delegate?.customDialogDidTouchOK(self)
    }

}

// MARK: - Private
extension CustomDialogController {
    
    private func setup() {
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }

}
