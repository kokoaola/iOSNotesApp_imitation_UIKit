//
//  ViewController.swift
//  Challenge4
//
//  Created by koala panda on 2023/05/26.
//

import UIKit

///メモ用のカスタムデータタイプ
///Data型に変換して保存するのでCodableに準拠
class Note: NSObject, Codable {
    var memo: String
    var date: Date
    
    init(memo: String, date: Date) {
        self.memo = memo
        self.date = date
    }
}


///デリゲート用のプロトコル
protocol DestinationViewControllerDelegate: AnyObject {
    ///保存用のメソッド
    func saveMemo(newMemo: String, index: Int?)
    ///削除用のメソッド
    func deleteItem(index: Int?)
}



class ViewController: UITableViewController , DestinationViewControllerDelegate {
    
    var notes = [Note]()
    var noteCount:Int?
    
    ///UserDefaultsクラスのインスタンスを作成
    let defaults = UserDefaults.standard
    ///JSONEncoderクラスのインスタンスを作成
    let jsonEncoder = JSONEncoder()
    ///JSONDecoderクラスのインスタンスを作成
    let jsonDecoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///テーブルビューの背景色指定
        self.view.backgroundColor = UIColor.secondarySystemBackground
        ///ナビゲーションタイトル
        title = "メモ"
        ///ナビゲーションタイトル大きく表示
        navigationController?.navigationBar.prefersLargeTitles = true
        
        ///コントロールバーの配置
        ///スペース
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ///新規作成ボタン
        let refresh = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(pushDetailView))
        toolbarItems = [spacer, refresh]
        
        ///アプリの起動時にNotes配列をロード
        if let items = defaults.object(forKey: "notes") as? Data {
            do {
                print("loaded")
                notes = try jsonDecoder.decode([Note].self, from: items)
            } catch {
                notes = []
                print("Failed to load people")
            }
        }
        
        
        ///合計メモ数を下に表示
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        label.text = "\(notes.count)件のメモ"
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        let barButton = UIBarButtonItem(customView: label)
        toolbarItems = [spacer, barButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        navigationController?.hidesBarsOnTap = false
    }
    
    
    
    ///テーブルビューのセルタップ時と新規作成時ボタン押下、DetailViewに画面推移
    @objc func pushDetailView(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    ///編集、新規作成したメモを保存するデリゲートメソッド
    func saveMemo(newMemo: String, index: Int?) {
        ///メモを新規作成時、内容が何も入っていなかったら保存せず終了
        if newMemo == "" && index == nil{
            return
        }
        
        ///Noteインスタンスを生成
        let newNote = Note(memo: newMemo, date: Date())
        
        if let index = index{
            ///既存のメモ編集の場合は既存のインスタンスを置き換える
            notes[index] = newNote
        }else{
            ///新規作成時は配列の最後尾に追加する
            notes.append(newNote)
        }
        
        ///ユーザーデフォルトに保存
        if let savedData = try? jsonEncoder.encode(notes) {
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save people.2")
        }
        self.loadView()
    }
    
    
    
    ///アイテムを削除するデリゲートメソッド
    func deleteItem(index: Int?) {
        guard let index = index else{
            return
        }
        ///指定されたアイテムを削除
        let newNotes = notes.remove(at: index)
        ///新しい配列を保存する
        if let savedData = try? jsonEncoder.encode(newNotes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
            print("saved")
        } else {
            print("Failed to save people.")
        }
        self.loadView()
    }
    
    
    
    ///テーブルビューに必要な行数を指定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    
    ///セクション名
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return "すべて"
    }
    
    
    
    ///メモを一部だけ表示させるために、テーブルの高さを指定
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    
    ///テーブルビューの内容を指定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///テーブルビュー再利用の設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "memo", for: indexPath)
        
        ///表示するインスタンス
        let note = notes[indexPath.row]
        ///セルのカスタマイズ用UIListContentConfigurationオブジェクトを作成
        var contents: UIListContentConfiguration =
        {
            var content: UIListContentConfiguration = .subtitleCell()
            content.textProperties.font = .systemFont(ofSize: 18, weight: .bold)
            content.secondaryTextProperties.font = .systemFont(ofSize: 13, weight: .light)
            return content
        }()
        var content = contents
        
        ///メモが長文の時はタイトルの後半を...で省略
        if note.memo.count < 20{
            content.text = note.memo
        }else{
            content.text = String(note.memo.prefix(20)) + "..."
        }
        
        ///日付の表示スタイルの指定
        let df =  DateFormatter()
        df.calendar = Calendar(identifier: .japanese)
        df.dateFormat = "YYYY年M月dd日"
        content.secondaryText = df.string(from: note.date) + note.memo
        ///カスタムの適用
        cell.contentConfiguration = content
        return cell
    }
    
    
    
    ///テーブルビューセルタップ時の動き
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///DetailViewに画面推移
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.text = notes[indexPath.row].memo
            vc.delegate = self
            vc.index = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

