//
//  WhereViewController.swift
//  Algorithm-Team1
//
//  Created by 이재혁 on 12/2/23.
//

import UIKit
import SnapKit
import NMapsMap

class WhereViewController: UIViewController {

    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        configureMap()
        configureTopLogo()
        configureDestination()
    }
    
    // MARK: - Components
    private let whereView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor(hex: "D7F2K1").cgColor
        
        return view
    }()
    
    private let whereLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 어디서 만나?"
        label.font = UIFont.pretendard(.extraBold, size: 26)
        label.textColor = UIColor(hex: "59B8FF")
        return label
    }()

    let NaverMapView2: NMFMapView = {
        let view = NMFMapView()
        // 기본위치 가천대역으로
        view.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.4485553966264, lng: 127.126686575598)))
        
        return view
    }()
    
    private let destinationLabel1: UILabel = {
        let label = UILabel()
        label.text = "우리"
        label.font = UIFont.pretendard(.extraBold, size: 32)
        label.textColor = UIColor(hex: "000000")
        
        return label
    }()
    
    var middlePointName: String = ""
    
    private let destinationLabel2: UILabel = {
        let label = UILabel()
        label.text = "무슨역에서"
        label.font = UIFont.pretendard(.extraBold, size: 32)
        label.textColor = UIColor(hex: "000000")
        
        return label
    }()
    
    private let destinationLabel3: UILabel = {
        let label = UILabel()
        label.text = "만나??"
        label.font = UIFont.pretendard(.extraBold, size: 32)
        label.textColor = UIColor(hex: "000000")
        
        return label
    }()
    
    private let addMarkerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "m.circle.fill"), for: .normal)
        button.tintColor = UIColor(hex: "D7F2K1")
        button.addTarget(self, action: #selector(addMarker), for: .touchUpInside)

        return button
    }()
    
    @objc func addMarker() {
        dijkstraForTeam1()
    }
    
    func loadLocation(station: String) {
        let tempArr = stationDictionary["\(station)"]!
        
        // MARKER 추가
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: tempArr[0], lng: tempArr[1])
        marker.mapView = NaverMapView2
        // 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: tempArr[0], lng: tempArr[1]))
        cameraUpdate.animation = .easeIn
        NaverMapView2.moveCamera(cameraUpdate)
    }
    
    // MARK: - configure UI
    private func configureMap() {
        view.addSubview(NaverMapView2)
        NaverMapView2.snp.makeConstraints({
            $0.height.equalTo(500)
            $0.top.leading.trailing.equalToSuperview()
        })
    }
    
    private func configureTopLogo() {
        view.addSubview(whereView)
        whereView.snp.makeConstraints({
            $0.top.equalTo(NaverMapView2.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(220)
            $0.height.equalTo(50)
        })
        
        whereView.addSubview(whereLabel)
        whereLabel.snp.makeConstraints({
            $0.centerY.centerX.equalToSuperview()
        })
    }
    
    private func configureDestination() {
        [destinationLabel1, destinationLabel2, destinationLabel3, addMarkerButton].forEach(view.addSubview(_:))
        
        destinationLabel1.snp.makeConstraints({
            $0.top.equalTo(whereView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        })
        
        destinationLabel2.snp.makeConstraints({
            $0.top.equalTo(destinationLabel1.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        })
        
        destinationLabel3.snp.makeConstraints({
            $0.top.equalTo(destinationLabel2.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        })
        
        addMarkerButton.snp.makeConstraints({
            $0.top.equalTo(destinationLabel3.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        })
        
    }
    
    // MARK: - func
    func dijkstraForTeam1() {
        let numStations = numberOfStations
        let selectedStations = WhereStations
        let graph = createGraph(subwayStations: stationDictionary)
        
        // Use Dijkstra's algorithm to calculate the shortest paths and distances
        var shortestPaths = [String]()
        var totalDistances = [Double]()
        for i in 0..<numStations - 1 {
            let sourceStation = selectedStations[i]
            let targetStation = selectedStations[i + 1]

            // Check if entered station names are valid
            guard stationDictionary.keys.contains(sourceStation), stationDictionary.keys.contains(targetStation) else {
                print("Error: Invalid subway station names (\(sourceStation) or \(targetStation)).")
                return
            }

            let distance = dijkstra(graph: graph, start: sourceStation, end: targetStation)
            shortestPaths.append("\(sourceStation) -> \(targetStation)")
            totalDistances.append(distance)
        }

        // Calculate midpoint
        let selectedStationsCoordinates = selectedStations.compactMap { stationDictionary[$0] }
        let (midLat, midLon) = calculateMidpoint(coordinates: selectedStationsCoordinates)

        // Find the nearest subway station to the halfway point
        let midpointCoordinates = (midLat, midLon)
        let nearestStation = findNearestStation(subwayStations: stationDictionary, coordinates: midpointCoordinates)

        // Display results
        for i in 0..<numStations - 1 {
            print("The shortest route (\(selectedStations[i]) to \(selectedStations[i + 1])): \(shortestPaths[i])")
            print("Total travel distance (\(selectedStations[i]) to \(selectedStations[i + 1])): \(totalDistances[i]) km")
        }

        print("The midway point: \(midpointCoordinates)")
        if let nearestStation = nearestStation {
            print("The nearest subway station to the halfway point: \(nearestStation)")
        } else {
            print("The shortest route and nearest subway station could not be found")
        }
        
        self.destinationLabel2.text = "\(nearestStation!)역에서"
        self.destinationLabel3.text = "만나!!"
        
        loadLocation(station: nearestStation!)
    }
}



@available(iOS 17.0, *)
#Preview("FinalVC") {
    WhereViewController()
}
