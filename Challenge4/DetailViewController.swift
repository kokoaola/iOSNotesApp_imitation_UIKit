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

///２デリゲート用のプロトコル
protocol DestinationViewControllerDelegate: AnyObject {
    func changeProperty(newMemo: String, low: Int)
}

class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var text: String?
    var index: Int?
    weak var delegate: DestinationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title:"aa", style: .plain, target: self, action: #selector(done))
        //navigationItem.hidesBackButton = true
//        let backItem = UIBarButtonItem(title: "戻る", style: .plain, target: self, action: nil)
//        backItem.tintColor = .blue
//        navigationItem.backBarButtonItem = backItem
//        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")
        //(image: UIImage(systemName: "る"), style: .plain, target: self, action: #selector(done))
        
        if text?.count ?? 0 < 20{
            title = text
        }else{
            title = String((text?.prefix(20) ?? "")) + "..."
        }
        
//        title = String((text?.prefix(20) ?? "")) + "..."
        textView.text = text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ///ここでデリゲートメソッドを発動させる
        delegate?.changeProperty(newMemo: textView.text, low: index ?? 0)
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func done(){
//        delegate?.changeProperty(newMemo: "更新したい値", low: 1)
//        self.navigationController?.popViewController(animated: true)
//    }
    
}
