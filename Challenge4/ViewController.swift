//
//  ViewController.swift
//  Challenge4
//
//  Created by koala panda on 2023/05/26.
//

import UIKit


class Note: NSObject, Codable {
    var memo: String
    var date: Date
    
    init(memo: String, date: Date) {
        self.memo = memo
        self.date = date
    }
}



class ViewController: TableViewController {
    
    
    private var contents: UIListContentConfiguration =
        {
            var content: UIListContentConfiguration = .subtitleCell()
            content.textProperties.font = .systemFont(ofSize: 18, weight: .bold)
            //content.textProperties.color = .systemBlue
            content.secondaryTextProperties.font = .systemFont(ofSize: 13, weight: .light)
            //content.secondaryTextProperties.color = .systemTeal
            //content.imageProperties.tintColor = .systemRed
            
            return content
        }()
    
    var items = ["タイトル", "日付"]
    var notes = [Note]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.secondarySystemBackground
        title = "メモ"
        navigationController?.navigationBar.prefersLargeTitles = true
        ///上の配置
        ///右上（アイコン）
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(pushDetailView))
        
        ///下の配置
        ///スペース
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ///新規作成
        let refresh = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: nil, action: #selector(aaa))
    
        
        ///アプリの実行時にディスクから配列をロード
        let defaults = UserDefaults.standard
        
        
        let testItem = Note(memo: "UINavigationBar decoded as unlocked for UINavigationController, or navigationBar delegate set up incorrectly. Inconsistent configuration may cause problems. navigationController=<UINavigationController: 0x137813800>, navigationBar=<UINavigationBar: 0x136a094f0; frame = (0 59; 0 50); opaque = NO; autoresize = W; layer = <CALayer: 0x600002d997e0>> delegate=0x137813800", date: Date())
        notes.append(testItem)
        
        
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save people.")
        }
        
        
        if let items = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                notes = try jsonDecoder.decode([Note].self, from: items)
                print("________________")
            } catch {
                print("Failed to load people")
            }
        }
        
        ///合計メモ数
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        label.text = "\(items.count)件のメモ"
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        let barButton = UIBarButtonItem(customView: label)
        
        toolbarItems = [spacer, barButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
    }
    
    ///ナビゲーションバーをタップで非表示にする設定
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func aaa(){
        print("aaa")
    }
    
    
    @objc func pushDetailView(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    
    ///テーブルビューに必要な行数を指定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return "すべて"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    
    ///テーブルビューの内容を指定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///withIdentifierは識別子文字列を使ってコードとストーリーボード情報を結びつけています。Interface Builderとコードで同じ名前使用しないと、クラッシュしてしまいます。
        let cell = tableView.dequeueReusableCell(withIdentifier: "memo", for: indexPath)

        let note = notes[indexPath.row]
        
        
        var content = contents
        content.text = String(note.memo.prefix(10))
        
        let df =  DateFormatter()
        df.calendar = Calendar(identifier: .japanese)
        df.dateFormat = "YYYY年M月dd日"
        content.secondaryText = df.string(from: note.date) + note.memo
        cell.contentConfiguration = content
        return cell
    }
    
    
    ///テーブルビューセルタップ時の動き
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("AAA")
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.text = notes[indexPath.row].memo
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }

}

