//
//  ViewController.swift
//  ATTSample
//
//  Created by ryokosuge on 2021/04/09.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            print("ダイアログ出てないよ")
        }

        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("idfa:    \(idfa)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let viewController = CustomDialogController()
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }

}

extension ViewController: CustomDialogControllerDelegate {

    func customDialogDidTouchCancel(_ customDialog: CustomDialogController) {
        // 何もしない
        customDialog.dismiss(animated: true, completion: nil)
    }

    func customDialogDidTouchOK(_ customDialog: CustomDialogController) {
        customDialog.dismiss(animated: true) {
            // カスタムダイアログを出した回数 : 分母
            // ATTのダイアログを出した回数 : 母数
            // 許可してくれた回数 : 分子 => 許諾率が出る

            // event("request tracking dialog")
            let notShowDialog = ATTrackingManager.trackingAuthorizationStatus == .notDetermined
            if notShowDialog {
                // dialogを出してないなら
                // ダイアログを表示するよっていうイベントを計測する
                // event("request tracking dialog")
            }

            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .notDetermined:
                    // まだユーザーに聞いてないよ
                    print("まだダイアログ出してないよ")
                case .denied:
                    if notShowDialog {
                        // dialogを初めて出した時だけ計測する
                        // event("not tracking authorized")
                    }
                    // 拒否した
                    print("拒否られました")
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    print("idfa:    \(idfa)")
                case .authorized:
                    if notShowDialog {
                        // dialogを初めて出した時だけ計測する
                        // event("tracking authorized")
                        DispatchQueue.main.async {[weak self] in
                            let alert = UIAlertController(title: nil, message: "ありがとう！", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                        }
                    }
                    // okした
                    print("トラッキングしていいよ")
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    print("idfa:    \(idfa)")
                case .restricted:
                    // 端末 / ユーザーの年齢とか
                    print("端末レベルでだめ")
                @unknown default:
                    print("よくわかりません")
                }
            }
        }
    }
}
