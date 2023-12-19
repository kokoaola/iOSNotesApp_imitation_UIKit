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

class TableViewController: UITableViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedNumber = 0
    var totalImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pictures \(selectedNumber) of \(totalImages)"

        ///これは簡単に2つの部分に分けられます。左側では、ビューコントローラーのnavigationItemのrightBarButtonItemに代入しています。このナビゲーションアイテムは、ナビゲーションバーが関連情報を表示できるようにするために使用されます。この場合、このビューコントローラが表示されているときにナビゲーションバーの右側に表示されるボタンである、右バーボタンの項目を設定しています。
        
        ///右側では、UIBarButtonItemデータタイプの新しいインスタンスを作成し、システムアイテム、ターゲット、アクションという3つのパラメータを設定します。システムアイテムは.actionを指定していますが、.を入力すると、コード補完で他の多くのオプションが表示されるようにすることができます。.actionシステムアイテムは、ボックスから出る矢印を表示し、タップされると何かできることを示します。
        ///targetパラメータとactionパラメータは、UIBarButtonItemにどのメソッドを呼び出すべきかを伝えるもので、密接な関係にあります。actionパラメータは「タップされたらshareTapped()メソッドを呼びなさい」という意味であり、targetパラメータはそのメソッドが現在のビューコントローラ（self）に属することをボタンに伝えている。それは新しいと珍しい構文であるため、#selectorの部分は、もう少し説明する必要があります。それが何をするかというと、"shareTapped "と呼ばれるメソッドが存在し、ボタンがタップされたときにトリガーされるべきであるとSwiftコンパイラに伝えることです。
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        
        
        if let imageToLoad = selectedImage {
            imageView.image  = UIImage(named: imageToLoad)
        }
        // Do any additional setup after loading the view.
    }
    
    ///ナビゲーションバーをタップで非表示にする設定
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    ///このメソッドは、基盤となるObjective-Cオペレーティングシステム（UIBarButtonItem）から呼び出されるので、Objective-Cコードから利用できるように@objcでマークする必要があります。selectorを使用してメソッドを呼び出す場合は、常に@objcも使用する必要があります。画像ビューの中に画像がある場合とない場合があるので、それを安全に読み出し、JPEGデータに変換します。これは、compressionQualityパラメータで、1.0（最高品質）から0.0（最低品質）までの値を指定することができます。次に、UIActivityViewControllerを作成します。これは、他のアプリやサービスとコンテンツを共有するためのiOSの方法です。最後に、アクティビティビューコントローラーがどこに固定されるか、つまりどこから表示されるべきかをiOSに伝えます。
    ///iPhoneでは、アクティビティビューコントローラは自動的に全画面を占有しますが、iPadではポップオーバーとして表示され、ユーザーが作業していたものを下に見ることができます。このコードの行は、アクティビティビューコントローラを右のバーのボタンアイテム（共有ボタン）に固定するようiOSに指示しますが、これはiPadでのみ効果があります。
    ///アクティビティビューコントローラーがどのように作成されるかに焦点を当てましょう。コードで見ることができるように、あなたは2つのアイテムを渡します：あなたが共有したいアイテムの配列と、あなたがリストにあることを確認したいあなた自身のアプリのサービスの任意の配列です。私たちのアプリには提供するサービスがないため、2番目のパラメーターに空の配列を渡しています。しかし、このアプリを拡張して、たとえば「こんな写真もありますよ」というような機能を持たせるのであれば、ここにその機能を含めることになります。つまり、最初のパラメータである[image]に注目してください。これは、ユーザーが選択した画像を表すJPEGデータで、iOSはそれが画像であることを理解し、TwitterやFacebookなどに投稿することができます。
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, selectedImage ?? ""], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
