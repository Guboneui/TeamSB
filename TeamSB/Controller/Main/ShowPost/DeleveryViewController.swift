//
//  DelevaryViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/14.
//

import UIKit
import Alamofire

class DeleveryViewController: UIViewController {

    var currentPage = 0
    var isLoadedAllData = false
    var saveData = [Any]()
    
    var writeButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDelivary(page: currentPage)
        setTableView()
        setNavigationBarItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItemUse()
    }
    
//MARK: -기본 UI 함수
    
    func setNavigationBarItem() {
        self.navigationItem.title = "배달"
        self.tabBarController?.tabBar.isHidden = true
        writeButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(goWriteView))
        writeButton.tintColor = .black
        searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goSearchView))
        searchButton.imageInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        searchButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [writeButton, searchButton]
        
    }
    
    func navigationItemUse() {
        writeButton.isEnabled = true
        searchButton.isEnabled = true
    }
    
    func setTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        let mainTableViewNib = UINib(nibName: "DeleveryTableViewCell", bundle: nil)
        mainTableView.register(mainTableViewNib, forCellReuseIdentifier: "DeleveryTableViewCell")
        
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
//MARK: -스토리보드 Action 함수
    @objc func refreshData() {
        print(">> 상단 새로고침")
        currentPage = 0
        self.isLoadedAllData = false
        saveData.removeAll()
        mainTableView.reloadData()
        getDelivary(page: currentPage)
        
    }
    
    @objc func goWriteView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WriteViewController") as! WriteViewController
        
        vc.delegate = self
        vc.getCategory = "배달"
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goSearchView() {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        writeButton.isEnabled = false
        searchButton.isEnabled = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
//MARK: -API
    func getDelivary(page: Int) {
        
        currentPage += 1
        
        guard
            isLoadedAllData == false
        else {
            return
        }
        
        let URL = "http://13.209.10.30:3000/home/delivery?page=\(currentPage)"
        let alamo = AF.request(URL, method: .get, parameters: nil).validate(statusCode: 200...500)
        
        alamo.responseJSON { [self] (response) in
            switch response.result {
            case .success(let value):
                if let jsonObj = value as? NSDictionary {
                    print(">> \(URL)")
                    print(">> 배달 게시글 API 호출 성공")
                    
                    mainTableView.refreshControl?.endRefreshing()
                    
                    let result = jsonObj.object(forKey: "check") as! Bool
                    if result == true {
                        let message = jsonObj.object(forKey: "message") as! String
                        print(">> \(message)")
                        let content = jsonObj.object(forKey: "content") as! NSArray
                        
                        guard content.count > 0 else {
                            print(">> 더이상 읽어올 게시글 없음")
                            print(">> 총 읽어온 게시글 개수 = \(saveData.count)")
                            self.isLoadedAllData = true
                            return
                        }
                        
                        
                        for i in 0..<content.count {
                            saveData.append(content[i])
                        }
                        print(">> \(URL)")
                        print(">> 읽어온 게시글의 개수: \(content.count), 현재 페이지\(page+1)")
                        mainTableView.reloadData()
                    }
                  
                }
            case .failure(let error):
                if let jsonObj = error as? NSDictionary {
                    print("서버통신 실패")
                    print(jsonObj)
                }
            }
        }
    }
}

extension DeleveryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeleveryTableViewCell", for: indexPath) as! DeleveryTableViewCell
        
        if saveData.count != 0 {
            let data = saveData[indexPath.row] as! NSDictionary
            
            cell.titleLabel.text = data["title"] as? String
            cell.timeLabel.text = data["timeStamp"] as? String
            cell.contentsLabel.text = data["text"] as? String
            
            var hashString = ""
            
            let hashData = data["hash"] as! NSArray
            
            for i in 0..<hashData.count {
                hashString += "#" + "\(hashData[i] as! String) "
            }
            
            cell.tagLabel.text = hashString
            
        } else {
            cell.titleLabel.text = ""
            cell.timeLabel.text = ""
            cell.contentsLabel.text = ""
            cell.tagLabel.text = ""
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "In_Post", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPostViewController") as! DetailPostViewController
        
        let data = saveData[indexPath.row] as! NSDictionary
        
        vc.getPostNumber = data["no"] as! Int
        vc.getTitle = data["title"] as! String
        vc.getCategory = data["category"] as! String
        vc.getTime = data["timeStamp"] as! String
        vc.getNickname = data["userNickname"] as! String
        vc.getContents = data["text"] as! String
        vc.getShowCount = data["viewCount"] as! Int
        vc.getUserID = data["userId"] as! String
        
        //vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            getDelivary(page: currentPage)
        }
        

    }
}

extension DeleveryViewController: UpdateData {
    func update() {
        mainTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        currentPage = 0
        isLoadedAllData = false
        saveData = []
        getDelivary(page: currentPage)
    }
}
