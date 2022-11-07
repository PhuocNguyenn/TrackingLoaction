//
//  HomeViewController.swift
//  TrackingLocation
//
//  Created by Phuoc Nguyen on 05/11/2022.
//

import UIKit
import CoreLocation
import MapKit
import RxCocoa
import RxSwift

class HomeViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var viewModel = HomeViewModel()
    var localLocations: [CLLocation] = []
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var showListLocationButton: UIButton!
    @IBOutlet private weak var stackViewTrallingConstant: NSLayoutConstraint!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        binding()
    }
    
    private func configUI() {
        // MapView
        mapView.showsUserLocation = true
        
        // stackView
        stackView.layer.cornerRadius = 5
        
        // TableView
        tableView.alpha = 0.7
        let nib = UINib(nibName: "LocationTableViewCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
    }
    
    private func binding() {
        let localLocationsObs = UserDefaults.standard.rx
            .observe([[String: Double]].self, UserDefaultsKey.localLocations.rawValue)
//            .skip(1)
            .compactMap { $0 }
            .map { locations in
                return locations.compactMap { CLLocation($0) }
            }
            .filter { !$0.isEmpty }
            
        // Display all local location into MapView
        localLocationsObs
            .subscribe(onNext: { self.addLocationAnotations($0) })
            .disposed(by: disposeBag)
        
        // Show list local locations into tableview
        localLocationsObs
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: LocationTableViewCell.self)) { (index, element, cell) in
                cell.location = element
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CLLocation.self)
            .subscribe(onNext: { self.moveMapView(to: $0) })
            .disposed(by: disposeBag)
        
        // currentLocationButton actions
        currentLocationButton.rx.tap
            .subscribe(onNext: {
                self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
            })
            .disposed(by: disposeBag)
        
        // showListLocationButton actions
        showListLocationButton.rx.tap
            .subscribe(onNext: { self.showOrHiddenListLocation() })
            .disposed(by: disposeBag)
    }
    
    private func moveMapView(to location: CLLocation) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.001,
                longitudeDelta: 0.001)
        )
        self.mapView.setRegion(region, animated: true)
        self.showOrHiddenListLocation()
    }
    
    private func addLocationAnotations(_ locations: [CLLocation]) {
        func createAnnotation(_ location: CLLocation) -> MKAnnotation {
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            return pin
        }
        let pins = locations.map { createAnnotation($0) }
        mapView.addAnnotations(pins)
        localLocations = locations
    }
    
    private func showOrHiddenListLocation() {
        let isShow = stackViewTrallingConstant.constant > 30
        stackViewTrallingConstant.constant = isShow ? 30 : self.tableView.frame.width + 30
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
