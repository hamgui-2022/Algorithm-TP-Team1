//
//  ViewController.swift
//  Algorithm-Team1
//
//  Created by 이재혁 on 11/28/23.
//

import UIKit
import SnapKit
import NMapsMap
import Then

class ViewController: UIViewController {
    
    var locationString: String = ""
    var locationArray: Array<Double> = []
    var locationCount: Int = 0
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureMap()
        configureLocationView()
        configureButton()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        view.reloadInputViews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.frame = CGRect(x: view.frame.size.width - 70, y: view.frame.size.height - 80, width: 48, height: 48)
    }
    
    // MARK: - LAYOUT CONSTRAINT
    private func configureButton() {
        self.view.addSubview(addButton)
        
        addButton.snp.makeConstraints({
            $0.top.equalTo(view.snp.top).offset(60)
            $0.leading.equalTo(NaverMapView.snp.trailing).offset(16)
        })
        
        self.view.addSubview(finalMeetButton)
        finalMeetButton.snp.makeConstraints({
            $0.top.equalTo(locationView.snp.bottom).offset(10)
            //$0.centerX.equalToSuperview().offset(-40)
            $0.leading.equalTo(locationView)
            $0.width.equalTo(280)
        })
    }
    
    private func configureMap() {
        view.addSubview(NaverMapView)
        NaverMapView.snp.makeConstraints({
            //$0.width.equalTo(350)
            $0.height.equalTo(500)
            //$0.centerX.centerY.equalToSuperview()
            $0.top.leading.trailing.equalToSuperview()
        })
    }
    
    private func configureLocationView() {
        view.addSubview(locationView)
        locationView.snp.makeConstraints({
            $0.top.equalTo(NaverMapView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(245)
        })
        
        [firstLocationLabel, firstLocationView, firstLocationTitle, addFirstMarkerButton].forEach(locationView.addSubview(_:))
        
        firstLocationLabel.snp.makeConstraints({
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().inset(15)
        })
        
        firstLocationView.snp.makeConstraints({
            $0.leading.equalTo(firstLocationLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(firstLocationLabel)
            $0.width.equalTo(200)
            $0.height.equalTo(firstLocationLabel)
        })
        
        firstLocationTitle.snp.makeConstraints({
            $0.leading.equalTo(firstLocationView).inset(10)
            $0.centerY.equalTo(firstLocationLabel)
        })
        
        addFirstMarkerButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(firstLocationLabel)
        })
        

        [secondLocationLabel, secondLocationView, secondLocationTitle,  addSecondMarkerButton].forEach(locationView.addSubview(_:))
        
         secondLocationLabel.snp.makeConstraints({
             $0.top.equalTo(firstLocationLabel.snp.bottom).offset(20)
             $0.leading.equalToSuperview().inset(15)
         })
         
         secondLocationView.snp.makeConstraints({
             $0.leading.equalTo(firstLocationView)
             $0.centerY.equalTo(secondLocationLabel)
             $0.width.equalTo(200)
             $0.height.equalTo(secondLocationLabel)
         })
         
         secondLocationTitle.snp.makeConstraints({
             $0.leading.equalTo(firstLocationTitle)
             $0.centerY.equalTo(secondLocationLabel)
         })
        
         addSecondMarkerButton.snp.makeConstraints({
             $0.trailing.equalToSuperview().inset(20)
             $0.centerY.equalTo(secondLocationLabel)
         })
         
        
        [thirdLocationLabel, thirdLocationView, thirdLocationTitle, addThirdMarkerButton].forEach(locationView.addSubview(_:))
        
         thirdLocationLabel.snp.makeConstraints({
             $0.top.equalTo(secondLocationLabel.snp.bottom).offset(20)
             $0.leading.equalToSuperview().inset(15)
         })
         
         thirdLocationView.snp.makeConstraints({
             $0.leading.equalTo(firstLocationView)
             $0.centerY.equalTo(thirdLocationLabel)
             $0.width.equalTo(200)
             $0.height.equalTo(thirdLocationLabel)
         })
         
         thirdLocationTitle.snp.makeConstraints({
             $0.leading.equalTo(firstLocationTitle)
             $0.centerY.equalTo(thirdLocationLabel)
         })
        
         addThirdMarkerButton.snp.makeConstraints({
             $0.trailing.equalToSuperview().inset(20)
             $0.centerY.equalTo(thirdLocationLabel)
         })
        
        [FourthLocationLabel, FourthLocationView, fourthLocationTitle, addFourthMarkerButton].forEach(locationView.addSubview(_:))
        
         FourthLocationLabel.snp.makeConstraints({
             $0.top.equalTo(thirdLocationLabel.snp.bottom).offset(20)
             $0.leading.equalToSuperview().inset(15)
         })
         
         FourthLocationView.snp.makeConstraints({
             $0.leading.equalTo(firstLocationView)
             $0.centerY.equalTo(FourthLocationLabel)
             $0.width.equalTo(200)
             $0.height.equalTo(FourthLocationLabel)
         })
         
         fourthLocationTitle.snp.makeConstraints({
             $0.leading.equalTo(firstLocationTitle)
             $0.centerY.equalTo(FourthLocationLabel)
         })
        
         addFourthMarkerButton.snp.makeConstraints({
             $0.trailing.equalToSuperview().inset(20)
             $0.centerY.equalTo(FourthLocationLabel)
         })
         
    }
    
    // MARK: - Component
    private lazy var addButton : UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(hex: "59B8FF")
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        button.configuration = config
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let NaverMapView: NMFMapView = {
        let view = NMFMapView()
        // 기본위치 가천대역으로
        view.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.4485553966264, lng: 127.126686575598)))
        
        //let marker = NMFMarker()
        //marker.position = NMGLatLng(lat: 37.4485553966264, lng: 127.126686575598)
        //marker.mapView = view
        
        return view
    }()
    
    private let locationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "59B8FF")
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let firstLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(.extraBold, size: 32)
        label.textColor = UIColor(hex: "FFFFFF")
        label.text = "1."
        
        return label
    }()
    
    private let firstLocationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let firstLocationTitle: UILabel = {
        let label = UILabel()
        label.text = "어디"
        label.font = UIFont.pretendard(.bold, size: 28)
        label.textColor = UIColor(hex: "59B8FF")
        
        return label
    }()
    
    private let addFirstMarkerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "m.circle.fill"), for: .normal)
        button.tintColor = UIColor(hex: "FFFFFF")
        button.addTarget(self, action: #selector(addFirstMarker), for: .touchUpInside)
        
        return button
    }()
    
    private let secondLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(.extraBold, size: 32)
        label.textColor = UIColor(hex: "FFFFFF")
        label.text = "2."
        
        return label
    }()
    
    private let secondLocationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let secondLocationTitle: UILabel = {
        let label = UILabel()
        label.text = "어디"
        label.font = UIFont.pretendard(.bold, size: 28)
        label.textColor = UIColor(hex: "59B8FF")
        
        return label
    }()
    
    private let addSecondMarkerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "m.circle.fill"), for: .normal)
        button.tintColor = UIColor(hex: "FFFFFF")
        button.addTarget(self, action: #selector(addSecondMarker), for: .touchUpInside)
        
        return button
    }()
    
    private let thirdLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(.extraBold, size: 32)
        label.textColor = UIColor(hex: "FFFFFF")
        label.text = "3."
        
        return label
    }()
    
    private let thirdLocationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let thirdLocationTitle: UILabel = {
        let label = UILabel()
        label.text = "어디"
        label.font = UIFont.pretendard(.bold, size: 28)
        label.textColor = UIColor(hex: "59B8FF")
        
        return label
    }()
    
    private let addThirdMarkerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "m.circle.fill"), for: .normal)
        button.tintColor = UIColor(hex: "FFFFFF")
        button.addTarget(self, action: #selector(addThirdMarker), for: .touchUpInside)

        return button
    }()
    
    private let FourthLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(.extraBold, size: 32)
        label.textColor = UIColor(hex: "FFFFFF")
        label.text = "4."
        
        return label
    }()
    
    private let FourthLocationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let fourthLocationTitle: UILabel = {
        let label = UILabel()
        label.text = "어디"
        label.font = UIFont.pretendard(.bold, size: 28)
        label.textColor = UIColor(hex: "59B8FF")
        
        return label
    }()
    
    private let addFourthMarkerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "m.circle.fill"), for: .normal)
        button.tintColor = UIColor(hex: "FFFFFF")
        button.addTarget(self, action: #selector(addFourthMarker), for: .touchUpInside)

        return button
    }()

    private let finalMeetButton: UIButton = {
        let button = UIButton()
        button.setTitle("우리 어디서 만나?", for: .normal)
        button.titleLabel?.font = UIFont.pretendard(.extraBold, size: 32)
        button.titleLabel?.textColor = UIColor(hex: "FFFFFF")
        button.layer.cornerRadius = 15
        //button.layer.backgroundColor = UIColor(hex: "59B8FF").cgColor
        button.layer.backgroundColor = UIColor(hex: "D7F2K1").cgColor
        
        return button
    }()
    
    // MARK: - func
    @objc private func addButtonTapped() {
        let selectVC = SelectMyStationViewController()
        print("tapped")
        locationCount += 1
        
        switch locationCount {
        case 1:
            selectVC.completionHandler = {
                text in
                self.firstLocationTitle.text = text
            }
        case 2:
            selectVC.completionHandler = {
                text in
                self.secondLocationTitle.text = text
            }
        case 3:
            selectVC.completionHandler = {
                text in
                self.thirdLocationTitle.text = text
            }
        case 4:
            selectVC.completionHandler = {
                text in
                self.fourthLocationTitle.text = text
            }
        default:
            break
        }
       
        self.navigationController?.pushViewController(selectVC, animated: true)
    }
    
    @objc func addFirstMarker() {
        loadLocation(station: firstLocationTitle.text!)
    }
    
    @objc func addSecondMarker() {
        loadLocation(station: secondLocationTitle.text!)
    }
    
    @objc func addThirdMarker() {
        loadLocation(station: thirdLocationTitle.text!)
    }
    
    @objc func addFourthMarker() {
        loadLocation(station: fourthLocationTitle.text!)
    }
    
    func loadLocation(station: String) {
        let tempArr = stationDictionary["\(station)"]!
        
        // MARKER 추가
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: tempArr[0], lng: tempArr[1])
        marker.mapView = NaverMapView
        // 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: tempArr[0], lng: tempArr[1]))
        cameraUpdate.animation = .easeIn
        NaverMapView.moveCamera(cameraUpdate)
    }
    
}

// MARK: - PREVIEW

 @available(iOS 17.0, *)
 #Preview("MapVC") {
     ViewController()
 }
