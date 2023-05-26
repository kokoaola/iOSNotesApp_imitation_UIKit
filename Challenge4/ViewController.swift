//
//  ViewController.swift
//  Challenge4
//
//  Created by koala panda on 2023/05/26.
//

import UIKit

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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        ///合計メモ数
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        label.text = "\(items.count)件のメモ"
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        let barButton = UIBarButtonItem(customView: label)
        
        toolbarItems = [spacer, barButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        ///アプリの実行時にディスクから配列をロード
        let defaults = UserDefaults.standard
        ///object(forKey:)メソッドでオプションのDataを取り出してアンラップし、それをJSONDecoderでPersonオブジェクトの配列に変換。
        
        if let items = defaults.object(forKey: "items") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                ///[Person].selfは「Personオブジェクトの配列を作成」という指示。
                //allPhotos = try jsonDecoder.decode([Photos].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
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
//        if section == 0 {
//            return imgArray1.count
//        }
//        else if section == 1 {
//            return imgArray2.count
//        }
//        else if section == 2 {
//            return imgArray3.count
//        }
//        else{
//            return 0
//        }
        return 5
    }
    
    // Section数
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Sectioのタイトル
    override func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    
    
    ///テーブルビューの内容を指定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///withIdentifierは識別子文字列を使ってコードとストーリーボード情報を結びつけています。Interface Builderとコードで同じ名前使用しないと、クラッシュしてしまいます。
        let cell = tableView.dequeueReusableCell(withIdentifier: "memo", for: indexPath)
        //cell.textLabel?.text = "aaa"
        // Set different UIListContentConfiguration for odd/even cell
        var content = contents
        
#if DEBUG
        print(content)
#endif
        
        content.text = items[0]
        content.secondaryText = "2023/5/26"
        //content.image = UIImage(systemName: "iphone")
        
        // Set content
        cell.contentConfiguration = content
        return cell
    }

}

