//
//  SelectMyStationViewController.swift
//  Algorithm-Team1
//
//  Created by 이재혁 on 11/28/23.
//

import UIKit
import SnapKit
import NMapsMap

class SelectMyStationViewController: UIViewController {
    var locationName: String = ""
    var locationTemp: Array<Double> = []
    private var items = ["선정릉",
                         "선릉",
                         "한티",
                         "도곡",
                         "구룡",
                         "개포동",
                         "대모산입구",
                         "수서",
                         "복정",
                         "가천대",
                         "삼성중앙",
                         "봉은사",
                         "종합운동장",
                         "삼전",
                         "석촌고분",
                         "석촌",
                         "송파나루",
                         "삼성",
                         "잠실새내",
                         "대치",
                         "학여울",
                         "대청",
                         "일원",
                         "가락시장",
                         "경찰병원",
                         "오금",
                         "잠실",
                         "문정",
                         "장지"]
    // 검색 결과를 담는 배열
    private var filteredItems: [String] = []
    // checkButton 선택 셀 index
    private var previousIndexPath: IndexPath?
    private var selectedIndexPath: IndexPath?
    
    var selectedIndexPaths: Set<IndexPath> = []
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "역을 선택해 주세요"
        label.textColor = .black
        label.font = UIFont.pretendard(.bold, size: 32)
        return label
    }()
    
    private let subLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor(hex: "808497")
        label.font = UIFont.pretendard(.medium, size: 16)
        return label
    }()
    
    private lazy var searchBar : UISearchBar = {
        let search = UISearchBar()
        let placeholderAttributes = [NSAttributedString.Key.font: UIFont.pretendard(.bold, size: 16), NSAttributedString.Key.foregroundColor : UIColor(hex: "BFC3D4")]
        let placeholderText = "역을 선택해 주세요"
        search.delegate = self
        search.searchBarStyle = .minimal
        search.showsCancelButton = true
        search.searchTextField.backgroundColor = UIColor(hex: "EEF0F8")
        search.searchTextField.layer.cornerRadius = 10
        search.searchTextField.borderStyle = .none
        search.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: placeholderAttributes)
        search.searchTextField.textAlignment = .left
        return search
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        //        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = UIColor(hex: "BFC3D4")
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.pretendard(.medium, size: 18)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(nextButtonIsClicked), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.configureNavBar()
        self.configureLabel()
        self.configureSearchBar()
        self.configureButton()
        self.configureTableView()
        
        self.reload()
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .gray
    }
    
    private func configureLabel() {
        [titleLabel, subLabel].forEach(self.view.addSubview(_:))
        
        titleLabel.snp.makeConstraints({
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalToSuperview().offset(20)
        })
        
        subLabel.snp.makeConstraints({
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(20)
        })
    }
    
    private func configureSearchBar() {
        self.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints({
            $0.top.equalTo(subLabel.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
            //            $0.height.equalTo(33)
            $0.height.equalToSuperview().multipliedBy(0.061)
        })
        
    }
    
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(StationCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints({
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(21)
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        })
    }
    
    private func reload() {
        self.tableView.reloadData()
    }
    
    private func configureButton() {
        self.view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(20)
            //            $0.height.equalTo(53)
            $0.height.equalToSuperview().multipliedBy(0.061)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-23)
        })
    }
    
    private func nextButtonIsOn() {
        nextButton.isUserInteractionEnabled = true
        nextButton.backgroundColor = UIColor(hex: "D7F2K1")
    }
    
    private func nextButtonIsOff() {
        nextButton.isUserInteractionEnabled = false
        nextButton.backgroundColor = UIColor(hex: "BFC3D4")
    }
    
    @objc private func nextButtonIsClicked() {
        let nextVC = ViewController()
        
        nextVC.locationArray = locationTemp
        //self.navigationController?.pushViewController(nextVC, animated: true)
        
        print("nextbutton tapped")
        print("lat: \(nextVC.locationArray[0]), lng: \(nextVC.locationArray[1])")
        nextVC.firstLocationTitle.text = locationName
        
        if let text = nextVC.firstLocationTitle.text {
            _ = completionHandler?(self.locationName ?? "")
        }

        //self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.pushViewController(nextVC, animated: true)
    }

    var completionHandler : ((String) -> (Void))?
    
}

extension SelectMyStationViewController: UISearchBarDelegate {
    //외부 탭시 키보드 내림.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // 리턴 키 입력 시 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterItems(with: searchText)
        self.reload()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 취소 버튼을 누를 때 검색어를 초기화하고 테이블 뷰를 갱신합니다.
        searchBar.text = nil
        searchBar.resignFirstResponder() // 키보드 내림
        filterItems(with: "")
        self.reload()
    }
    
    private func filterItems(with searchText: String) {
        if searchText.isEmpty {
            filteredItems = items // 검색어가 비어있으면 모든 항목을 포함
        } else {
            filteredItems = items.filter { $0.range(of: searchText, options: .caseInsensitive) != nil }
            // 검색어를 기준으로 items 배열을 필터링하여 검색 결과를 filteredItems에 저장
        }
    }
}

extension SelectMyStationViewController {
    func updateCellSelectionState(_ cell: StationCell, at indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            cell.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            nextButtonIsOn()
        } else {
            cell.checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            // 다른 선택된 셀이 있는지 확인하여 nextButton의 상태 업데이트
            if selectedIndexPaths.isEmpty {
                nextButtonIsOff()
            }
        }
        print("selectedIndexPath \(selectedIndexPath)")
    }
    
    private func updateNextButtonState() {
        if selectedIndexPaths.isEmpty {
            nextButtonIsOff()
        } else {
            nextButtonIsOn()
        }
        
        
    }
}

extension SelectMyStationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionTitles = getSectionTitles()
        return sectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredItemsInSection = getFilteredItemsInSection(section)
        return filteredItemsInSection.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StationCell
            
            let filteredItemsInSection = getFilteredItemsInSection(indexPath.section)
            let item = filteredItemsInSection[indexPath.row]
            cell.textLabel?.text = item
            cell.selectionStyle = .none
            
            if selectedIndexPaths.contains(indexPath) {
                cell.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                cell.checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            }
            
            return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
                selectedIndexPaths.remove(indexPath)
            } else {
                // 하나의 셀만 선택될 수 있도록 이전에 선택된 셀을 모두 해제합니다.
                selectedIndexPaths.removeAll()
                selectedIndexPaths.insert(indexPath)
            }
        
            tableView.reloadData() // 선택 상태 업데이트
            updateNextButtonState()
        
        // 선택된 셀의 정보 가져오기
           if let cell = tableView.cellForRow(at: indexPath) as? StationCell {
               if let stationName = cell.textLabel?.text {
                   print("Selected cell's nameLabel: \(stationName)")
                   
                   locationName = stationName
                   locationTemp = stationDictionary["\(stationName)"
                                                    //, default: [37.4485553966264, 127.126686575598]
                   ]!
                   
               }
           }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 섹션 헤더에 표시할 문자열을 반환합니다.
        let sectionTitles = getSectionTitles()
        if section < sectionTitles.count {
            return sectionTitles[section]
        }
        return nil
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    private func getSectionTitles() -> [String] {
        // 이름의 첫 글자로 이루어진 섹션 타이틀 배열을 반환합니다.
        let sectionTitles = items.map { name -> String in
            if let firstCharacter = name.first, let unicodeScalar = firstCharacter.unicodeScalars.first {
                let scalarValue = unicodeScalar.value
                if (0xAC00 <= scalarValue && scalarValue <= 0xD7A3) { // 첫 글자가 한글인 경우
                    let unicodeValue = scalarValue - 0xAC00
                    let choseongIndex = Int(unicodeValue / (21 * 28))
                    let choseong = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
                    let choseongCharacter = choseong[choseongIndex]
                    return choseongCharacter
                } else { // 첫 글자가 한글이 아닌 경우
                    return name.prefix(1).uppercased()
                }
            } else { // 이름이 비어있는 경우
                return ""
            }
        }
        
        let uniqueTitles = Array(Set(sectionTitles)).sorted()
        return uniqueTitles
    }
    
    private func getFilteredItemsInSection(_ section: Int) -> [String] {
        let sectionTitles = getSectionTitles()
        let sectionTitle = sectionTitles[section]
        
        let filteredItemsInSection: [String]
        if searchBarIsEmpty() {
            filteredItemsInSection = items.filter { item -> Bool in
                if let firstCharacter = item.first, let unicodeScalar = firstCharacter.unicodeScalars.first {
                    let scalarValue = unicodeScalar.value
                    if (0xAC00 <= scalarValue && scalarValue <= 0xD7A3) { // 첫 글자가 한글인 경우
                        let unicodeValue = scalarValue - 0xAC00
                        let choseongIndex = Int(unicodeValue / (21 * 28))
                        let choseong = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
                        let choseongCharacter = choseong[choseongIndex]
                        return "\(choseongCharacter)" == sectionTitle
                    } else { // 첫 글자가 한글이 아닌 경우
                        return item.prefix(1).uppercased() == sectionTitle
                    }
                } else { // 이름이 비어있는 경우
                    return sectionTitle.isEmpty
                }
            }
        } else {
            filteredItemsInSection = filteredItems.filter { item -> Bool in
                if let firstCharacter = item.first, let unicodeScalar = firstCharacter.unicodeScalars.first {
                    let scalarValue = unicodeScalar.value
                    if (0xAC00 <= scalarValue && scalarValue <= 0xD7A3) { // 첫 글자가 한글인 경우
                        let unicodeValue = scalarValue - 0xAC00
                        let choseongIndex = Int(unicodeValue / (21 * 28))
                        let choseong = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
                        let choseongCharacter = choseong[choseongIndex]
                        return "\(choseongCharacter)" == sectionTitle
                    } else { // 첫 글자가 한글이 아닌 경우
                        return item.prefix(1).uppercased() == sectionTitle
                    }
                } else { // 이름이 비어있는 경우
                    return sectionTitle.isEmpty
                }
            }
        }
        
        return filteredItemsInSection
    }
    
}

//// MARK: - PREVIEW
//
// @available(iOS 17.0, *)
// #Preview("SelectStationVC") {
//     SelectMyStationViewController()
// }
