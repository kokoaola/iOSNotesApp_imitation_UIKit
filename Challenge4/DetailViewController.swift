//
//  DetailViewController.swift
//  project1
//
//  Created by koala panda on 2023/03/15.
//
///画像のSaveのためには許可が必要
///プロジェクト・ナビゲーターでInfo.plistを選択し、データでいっぱいの大きなテーブルが表示されたら、その下の白いスペースで右クリックしてください。表示されるメニューから「行の追加」をクリックすると、「アプリケーション・カテゴリー」で始まる新しいオプションのリストが表示されるはずです。
///そのリストを下にスクロールして、「Privacy - Photo Library Additions Usage Description」という名前を見つけてください。これは、あなたのアプリがフォトライブラリに追加する必要があるときにユーザーに表示されるものです。右側空白部分に、アプリがフォトライブラリで何をするつもりなのかを説明するテキストを入力して、ユーザーに表示することができます。

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var text: String?
    var index: Int?
    weak var delegate: DestinationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///上の配置
        let backButton = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: #selector(save))
        self.navigationItem.leftBarButtonItem = backButton
        ///右上（アイコン）
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(showAlert))
        
        if text?.count ?? 0 < 20{
            title = text
        }else{
            title = String((text?.prefix(20) ?? "")) + "..."
        }
        textView.text = text
    }
    
    @objc func save(){
        ///ここでデリゲートメソッドを発動させる
        delegate?.changeProperty(newMemo: textView.text, low: index)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showAlert(){
        let alert = UIAlertController(title: "削除",
                                      message: "メモを削除しますか？",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "戻る", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "削除する", style: .destructive, handler: {[weak self] _ in
            ///ここでデリゲートメソッドを発動させる
            print(self?.index, self?.text)
            
            self?.delegate?.deleteItem(low: self?.index)
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}
