//
//  CalendarViewController.swift
//  TeamSB
//
//  Created by 구본의 on 2021/07/04.
//

import UIKit
import FSCalendar
import Alamofire

//MARK: -캘린더 class
class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var menuTableView: UITableView!
  
    var selectedDate: String = ""
    var morningString: String = ""
    var firstLaunchString: String = ""
    var secondLauchString: String = ""
    var dinnerString: String = ""
    
    var calMenu: [Menu] = []
    lazy var dataManager: CalendarDataManager = CalendarDataManager(view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setCalendar()
        
        
        let formatter        = DateFormatter()
        formatter.locale     = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY-MM-dd"
        selectedDate = formatter.string(from: Date())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "식단"
        dataManager.getCalMenu(viewController: self)
   
    }
    

}

//MARK: -기본 UI 설정 함수
extension CalendarViewController {
    
    func setTableView() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        let menuTableViewCellNib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        menuTableView.register(menuTableViewCellNib, forCellReuseIdentifier: "MenuTableViewCell")
        
    }
    
    
    func setCalendar() {
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.placeholderType = .none
        calendar.backgroundColor = UIColor.SBColor.SB_LightGray
        calendar.appearance.weekdayTextColor = UIColor.black
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.eventSelectionColor = UIColor.SBColor.SB_BaseYellow
        calendar.appearance.todayColor = UIColor.SBColor.SB_LightYellow
        calendar.appearance.todaySelectionColor = UIColor.SBColor.SB_LightYellow
        calendar.appearance.titleTodayColor = UIColor.black
        calendar.appearance.selectionColor = UIColor.SBColor.SB_BaseYellow
        calendar.headerHeight = 50
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        
    }
    
    func showMenu(date: String) {
        for i in 0..<calMenu.count {
            let dateMenu = calMenu[i]
            if dateMenu.일자 == date {
                for i in 0..<dateMenu.아침[0].count {
                    if i == dateMenu.아침[0].count - 1 {
                        morningString += "\(dateMenu.아침[0][i])"
                    } else {
                        morningString += "\(dateMenu.아침[0][i])\n"
                    }
                }
                
                for i in 0..<dateMenu.점심[0].count {
                    if i == dateMenu.점심[0].count - 1 {
                        firstLaunchString += "\(dateMenu.점심[0][i])"
                    } else {
                        firstLaunchString += "\(dateMenu.점심[0][i])\n"
                    }
                }
                
                for i in 0..<dateMenu.점심[1].count {
                    if i == dateMenu.점심[1].count - 1 {
                        secondLauchString += "\(dateMenu.점심[1][i])"
                    } else {
                        secondLauchString += "\(dateMenu.점심[1][i])\n"
                    }
                }
                
                for i in 0..<dateMenu.저녁[0].count {
                    if i == dateMenu.저녁[0].count - 1 {
                        dinnerString += "\(dateMenu.저녁[0][i])"
                    } else {
                        dinnerString += "\(dateMenu.저녁[0][i])\n"
                    }
                }
                
            }
        }
    }
    
}

//MARK: -tableview setting
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        if indexPath.row == 0 {
            cell.timeLabel.text = "아침"
            cell.menuLabel.text = morningString
        } else if indexPath.row == 1 {
            cell.timeLabel.text = "점심1"
            cell.menuLabel.text = firstLaunchString
        } else if indexPath.row == 2 {
            cell.timeLabel.text = "점심2"
            cell.menuLabel.text = secondLauchString
        } else if indexPath.row == 3 {
            cell.timeLabel.text = "저녁"
            cell.menuLabel.text = dinnerString
        } else {
            cell.timeLabel.text = "메뉴 없음"
            cell.menuLabel.text = "메뉴 없음"
        }

        cell.selectionStyle = .none
        return cell
    }
}

//MARK: -FSCalendar delegate, datasource
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        morningString = ""
        firstLaunchString = ""
        secondLauchString = ""
        dinnerString = ""
        
        let formatter        = DateFormatter()
        formatter.locale     = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY-MM-dd"
        
        selectedDate = formatter.string(from: date)
        
        print(">> \(selectedDate)일 메뉴를 가져옵니다.")
        
    
        showMenu(date: selectedDate)
        
        menuTableView.reloadData()
        menuTableView.scrollToRow(at: [0, 0], at: .top, animated: true)
        
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("\(dateFormatter.string(from: date)) 해제됨")
    }
}

//MARK: -DataManager 연결 함수
extension CalendarViewController: CalendarView {
    func setSelectedMenu() {
        let dateFormatter        = DateFormatter()
        dateFormatter.locale     = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date: String = dateFormatter.string(from: Date())
        
        showMenu(date: date)
        self.menuTableView.reloadData()
    }
}
