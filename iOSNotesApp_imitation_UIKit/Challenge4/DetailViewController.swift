//
//  DetailViewController.swift
//  project1
//
//  Created by koala panda on 2023/03/15.
//

import UIKit

class DetailViewController: UIViewController {
    ///メインで表示させるテキストビュー
    @IBOutlet weak var textView: UITextView!
    var text: String?
    var index: Int?
    
    ///DestinationViewControllerDelegateプロトコルを準拠したデリゲートオブジェクト
    weak var delegate: DestinationViewControllerDelegate?
    
    ///deleteは、メモを削除するかどうかを示すフラグ
    var delete = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///右上にゴミ箱のアイコンを表示する
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(showAlert))
        
        
        ///テキストが20文字未満の場合はそのままタイトルに表示
        if text?.count ?? 0 < 20{
            title = text
        }else{
            ///テキストが20文字以上の場合は先頭20文字を抽出してタイトルに表示
            title = String((text?.prefix(20) ?? "")) + "..."
        }
        
        ///textViewにテキストを表示
        textView.text = text
    }

    
    
    ///画面破棄の際の処理
    override func viewWillDisappear(_ animated: Bool) {
        /// 削除フラグがfalseの場合、保存処理を実行
        if !delete{
            save()
        }
    }
    
    
    
    @objc func save(){
        ///ここでデリゲートメソッドを発動させる
        delegate?.saveMemo(newMemo: textView.text, index: index)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func showAlert(){
        ///アラートの設定
        let alert = UIAlertController(title: "削除",
                                      message: "メモを削除しますか？",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "戻る", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "削除する", style: .destructive, handler: {[weak self] _ in
            ///デリゲートメソッドを呼び出して削除フラグを設定し、インデックスを渡す
            self?.delete = true
            self?.delegate?.deleteItem(index: self?.index)
            self?.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
}
