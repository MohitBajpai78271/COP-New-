//
//  ApiMapsViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 11/07/24.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftCSV

class ApiMapsViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var policeStationLabel: UILabel!
    @IBOutlet weak var policeStationButton: dropDownButton!
    @IBOutlet weak var crimTypeLabel: UILabel!
    @IBOutlet weak var criimeTypeButton: dropDownButton!
    
    private var hotspotButton: UIButton!
    
    var tapGesture : UITapGestureRecognizer!
    
    @IBOutlet weak var dateText: UILabel!
    var crimes: [Crime] = []
    var crimesLabel: UILabel!
    
    var datePicker: UIDatePicker!
    private var transparentView : UIView?

    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var polygonColors = [MKPolygon: UIColor]()
    var locationPolygons = [String: MKPolygon]()
    
    var hasCentredOnUser = false
    var coordinatesAlipur: [LatLon] = []
    var coordinatesBawana : [LatLon] = []
    var coordinatesBhalswa : [LatLon] = []
    var coordinatesNarela: [LatLon] = []
    var coordinatesNIA: [LatLon] = []
    var coordinatesSamaypur: [LatLon] = []
    var coordinatesSwaroop: [LatLon] = []
    var coordinatesShahbad: [LatLon] = []
    
    let delhiCenter = CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090)
      let delhiBoundaryRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCrimeLabel()
        setMapRegionToDelhi()
        criimeTypeButton.delegate = self
        policeStationButton.delegate = self
     
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        underLinetexts()
        setupMapView()
        setupLocationManager()
        showOptions()
        
        fetchCrimeData(selectedDate: nil)
        displayAllRegions()
        mapView.setRegion(delhiBoundaryRegion, animated: true)
        setupHotspotButton()
        let camera = MKMapCamera(lookingAtCenter: delhiCenter, fromDistance: 50000, pitch: 0, heading: 0)
           mapView.setCamera(camera, animated: true)
     
    }
    
    private func setupHotspotButton() {
        // 1. Create the button
        hotspotButton = UIButton(type: .system)
        // Use a system icon or text
        hotspotButton.setImage(UIImage(systemName: "flame.fill"), for: .normal)
        hotspotButton.tintColor = .white
        hotspotButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.8)
        hotspotButton.layer.cornerRadius = 25
        hotspotButton.clipsToBounds = true

        // 2. Add target
        hotspotButton.addTarget(self, action: #selector(hotspotButtonTapped), for: .touchUpInside)

        // 3. Add to view hierarchy
        hotspotButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hotspotButton)

        // 4. Pin to bottom-right of the mapView (or superview)
        NSLayoutConstraint.activate([
            hotspotButton.widthAnchor.constraint(equalToConstant: 50),
            hotspotButton.heightAnchor.constraint(equalToConstant: 50),
            hotspotButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            hotspotButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16)
        ])
    }

    @objc private func hotspotButtonTapped() {
        print("Hotspot button tapped") // Confirm this shows in console

        let vc = HotspotViewController()
        let navVC = UINavigationController(rootViewController: vc) // ✅ wrap it in nav controller

//        navVC.modalPresentationStyle = .fullScreen // Optional, for full-screen view
        present(navVC, animated: true, completion: nil)
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            enforceDelhiBoundary()
        }
    
    
    func displayAllRegions() {
        mapView.removeOverlays(mapView.overlays)
        
        coordinatesAlipur = loadCSV(from: Places.crimesLocation[0])
        coordinatesNIA = loadCSV(from: Places.crimesLocation[4])
        coordinatesNarela = loadCSV(from: Places.crimesLocation[3])
        coordinatesShahbad = loadCSV(from: Places.crimesLocation[6])
        coordinatesSamaypur = loadCSV(from: Places.crimesLocation[5])
        coordinatesBhalswa = loadCSV(from: Places.crimesLocation[2])
        coordinatesBawana = loadCSV(from: Places.crimesLocation[1])
        coordinatesSwaroop = loadCSV(from: Places.crimesLocation[7])
        
        setMapViewBoundaries(for: coordinatesAlipur, color: UIColor.label)
        setMapViewBoundaries(for: coordinatesNIA, color: UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesNarela, color: UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesShahbad, color: UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesSamaypur, color: UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesBhalswa, color: UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesBawana, color: UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesSwaroop, color: UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1.0))

    }

    func setMapRegionToDelhi() {
        let delhiCenter = CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: delhiCenter, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.mapType = .standard
    }
    
    func loadCSV(from csvName: String) -> [LatLon] {
        var csvToStruct = [LatLon]()
        
        guard let filePath = Bundle.main.path(forResource: csvName, ofType: "csv") else {
            return []
        }
        
        do {
            let data = try String(contentsOfFile: filePath,encoding: .utf8)
            let rows = data.components(separatedBy: "\n")

            for row in rows {
                let csvColumns = row.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                if csvColumns.count == 2,
                   let lat = Double(csvColumns[0]),
                   let lon = Double(csvColumns[1]) {
                   let latLonStruct = LatLon(latitude: lat, longitude: lon)
                    csvToStruct.append(latLonStruct)
                }
            }
        } catch {
      #if DEBUG
      print("Error reading CSV file: \(error.localizedDescription)")
      #endif
        }
        
        return csvToStruct
    }

    func setMapViewBoundaries(for coordinates: [LatLon], color: UIColor) {
        guard !coordinates.isEmpty else {
            return
        }
        var coords = [CLLocationCoordinate2D]()
        var minLatitude = Double.greatestFiniteMagnitude
        var maxLatitude = Double.leastNormalMagnitude
        var minLongitude = Double.greatestFiniteMagnitude
        var maxLongitude = Double.leastNormalMagnitude

        for coord in coordinates {
            let lat = coord.latitude
            let lon = coord.longitude
            coords.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
            minLatitude = min(minLatitude, lat)
            maxLatitude = max(maxLatitude, lat)
            minLongitude = min(minLongitude, lon)
            maxLongitude = max(maxLongitude, lon)
        }
        let polygon = ColoredPolygon(coordinates: &coords, count: coords.count)
        polygon.color = color
        mapView.addOverlay(polygon)

        let centerLatitude = (minLatitude + maxLatitude) / 2
        let centerLongitude = (minLongitude + maxLongitude) / 2
        let spanLatitude = (maxLatitude - minLatitude) * 1.1
        let spanLongitude = (maxLongitude - minLongitude) * 1.1

        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude), span: MKCoordinateSpan(latitudeDelta: spanLatitude, longitudeDelta: spanLongitude))
        mapView.setRegion(region, animated: true)
    }


    
    func showOptions(){
        criimeTypeButton.options = CrimesAndPoliceStations.crimeType
        policeStationButton.options = CrimesAndPoliceStations.policeStationPlace
        
    }
    
    func setupCrimeLabel(){
        
        crimesLabel = UILabel()
        crimesLabel.text = "Crimes: 0"
        crimesLabel.font = UIFont.boldSystemFont(ofSize: 16)
        crimesLabel.textColor = UIColor.label
        crimesLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(crimesLabel)
        
        NSLayoutConstraint.activate([
            crimesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            crimesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    func setupMapView() {
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        let initialLocation = CLLocationCoordinate2D(latitude: 28.748633, longitude: 77.114327)
        mapView.setRegion(MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    }
    
    
    //MARK: - UnderLine Texts
    
    func underLinetexts(){
        
        let labelTextCrime = crimTypeLabel.text ?? "All"
        let labelTextPoliceStation = policeStationLabel.text ?? "All"
        
        let labelCrime = crimTypeLabel
        let labelPoliceStation = policeStationLabel
        
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedStringCrime = NSAttributedString(string: labelTextCrime, attributes: underlineAttribute)
        let attributedStringpoliceStation = NSAttributedString(string: labelTextPoliceStation, attributes: underlineAttribute)
        
        labelCrime?.attributedText = attributedStringCrime
        labelPoliceStation?.attributedText = attributedStringpoliceStation
        
    }
    
    //MARK: - Calender Popped
    
    @IBAction func calenderButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Select Date", message: nil, preferredStyle: .alert)
        alertController.view.addSubview(datePicker)
        
        alertController.addAction(UIAlertAction(title: "Reset", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.dateText.text = "No date selected"
            self.datePicker.date = Date()
            self.fetchCrimeData(selectedDate: nil)
        })
        
        alertController.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let selectedDate = self.datePicker.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: selectedDate)
            self.dateText.text = formattedDate
            self.fetchCrimeData(selectedDate: formattedDate)
        })
        
        present(alertController, animated: true) { [weak self] in
            guard let self = self else { return }
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alertController.view.superview?.addGestureRecognizer(self.tapGesture!)
        }
    }
    
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
        if let tapGesture = tapGesture{
            self.view.window?.removeGestureRecognizer(tapGesture)
        }
    }
    
    func isCrimeWithinRegion(crime: Crime, regionCoordinates: [LatLon]) -> Bool {
        guard let crimeLatitude = Double(crime.latitude),
              let crimeLongitude = Double(crime.longitude) else {
            return false
        }

        let crimeLocation = CLLocation(latitude: crimeLatitude, longitude: crimeLongitude)

        for coordinate in regionCoordinates {
            let regionLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            if crimeLocation.distance(from: regionLocation) < 1000 {
                return true
            }
        }

        return false
    }
    
    //MARK: - FetchCrimeData and Add Annotation
    
    func fetchCrimeData(selectedDate: String?) {
        let place = policeStationLabel.text ?? "All"
        let crimeType = crimTypeLabel.text ?? "All"
        
        // Prepare parameters based on current filters
        var parameters: [String: String] = [:]
        if let date = selectedDate, date != "No date selected" {
            parameters["date"] = date
        }
        if place != "All" {
            parameters["place"] = place
        }
        if crimeType != "All" {
            parameters["crimeType"] = crimeType
        }
        
        showLoadingView(mapview: mapView)

        var components = URLComponents(string: "\(ApiKeys.baseURL)")!
        components.queryItems = parameters.isEmpty ? nil : parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let apiUrl = components.url else {
            dismissLoadingView()
            return
        }
        
        AF.request(apiUrl, parameters: parameters).responseDecodable(of: [Crime].self) { response in
            self.dismissLoadingView()
            
            switch response.result {
            case .success(let crimes):
                self.crimes = crimes
                let filteredCrimes = crimes.filter { crime in
                    let crimeTypeFromAPI = crime.crimeType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    let filteredCrimeType = crimeType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    let matchDate = selectedDate == nil || crime.date == selectedDate
                    let matchPlace = place == "All" || crime.beat.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == place.lowercased()
                    let matchCrimeType = filteredCrimeType == "all" || crimeTypeFromAPI == filteredCrimeType
                    
                    return matchDate && matchPlace && matchCrimeType
                }
                
                DispatchQueue.main.async {
                    self.addCrimeAnnotations(crimes: filteredCrimes)
                    self.crimesLabel.text = "Crimes: \(filteredCrimes.count)"
                    
                    if place != "All" {
                        self.displayRegionForPlace(place)
                    } else {
                        self.displayAllRegions()
                    }
                }
                
            case .failure(_):
                break
            }
        }
    }

    func displayRegionForPlace(_ place: String) {
        mapView.removeOverlays(mapView.overlays)
        
        let coordinates: [LatLon]
        let color: UIColor
        
        switch place {
        case "ALIPUR":
            coordinates = loadCSV(from: Places.crimesLocation[0])
            color = UIColor.label
        case "NARELA Industrial Area":
            coordinates = loadCSV(from: Places.crimesLocation[4])
            color = UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0)
        case "NARELA":
            coordinates = loadCSV(from: Places.crimesLocation[3])
            color = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0)
        case "SHAHBAD DAIRY":
            coordinates = loadCSV(from: Places.crimesLocation[6])
            color = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0)
        case "SAMAYPUR BADLI":
            coordinates = loadCSV(from: Places.crimesLocation[5])
            color = UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1.0)
        case "BHALSWA DAIRY":
            coordinates = loadCSV(from: Places.crimesLocation[2])
            color = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0)
        case "BAWANA":
            coordinates = loadCSV(from: Places.crimesLocation[1])
            color = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1.0)
        case "SWAROOP NAGAR":
            coordinates = loadCSV(from: Places.crimesLocation[7])
            color = UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1.0)
        default:
            return
        }
        
        setMapViewBoundaries(for: coordinates, color: color)
    }

    func addCrimeAnnotations(crimes: [Crime]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for crime in crimes {
            guard let latitude = Double(crime.latitude), let longitude = Double(crime.longitude) else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = crime.crimeType
            annotation.subtitle = "\(crime.date) - \(crime.beat)"
            mapView.addAnnotation(annotation)
        }
        
        if let firstCrime = crimes.first, let latitude = Double(firstCrime.latitude), let longitude = Double(firstCrime.longitude) {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
            
            DispatchQueue.main.async {
                self.mapView.setRegion(coordinateRegion, animated: true)
            }
        }
    }

    private func enforceDelhiBoundary() {
        let mapBoundaryLatitudeRange = 27.8...29.4
        let mapBoundaryLongitudeRange = 76.5...78.0
        
        var centerCoordinate = mapView.region.center
        var span = mapView.region.span
        if !mapBoundaryLatitudeRange.contains(centerCoordinate.latitude) {
            centerCoordinate.latitude = max(min(centerCoordinate.latitude, mapBoundaryLatitudeRange.upperBound), mapBoundaryLatitudeRange.lowerBound)
        }
    
        if !mapBoundaryLongitudeRange.contains(centerCoordinate.longitude) {
            centerCoordinate.longitude = max(min(centerCoordinate.longitude, mapBoundaryLongitudeRange.upperBound), mapBoundaryLongitudeRange.lowerBound)
        }
        
        let maxLatitudeDelta: CLLocationDegrees = 1.0
        let maxLongitudeDelta: CLLocationDegrees = 1.0
        span.latitudeDelta = min(span.latitudeDelta, maxLatitudeDelta)
        span.longitudeDelta = min(span.longitudeDelta, maxLongitudeDelta)
        
        let adjustedRegion = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(adjustedRegion, animated: true)
    }
}

//MARK: - DropDown Button

extension ApiMapsViewController: dropDownButtonDelegate{
    
    func dropDownButtonShowOptions(_ button: dropDownButton, alertController: UIAlertController) {
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene})
            .flatMap({$0.windows})
            .first(where: { $0.isKeyWindow })?.rootViewController{
            rootViewController.present(alertController, animated: true,completion: nil)
        }
        present(alertController,animated: true,completion: nil)
    }
    
    func dropDownButtonShowOptions(_ button: dropDownButton) {
//        print("show option")
    }
    
    func dropDownButtonHideOptions(_ button: dropDownButton) {
//        print("hide option")
    }
    
    func dropDownButton(_ button: dropDownButton, didSelectOption option: String) {
        if button == criimeTypeButton{
            crimTypeLabel.text = option
        }else if button == policeStationButton{
            policeStationLabel.text = option
        }
        let date : String? = dateText.text == "No date selected" ? nil : dateText.text
        fetchCrimeData(selectedDate: date)
    }
}

//MARK: - CLLocation Manager

extension ApiMapsViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            if !hasCentredOnUser {
                mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
                hasCentredOnUser = true
            }
        }
       }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showLocationPermissionAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
     func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location manager did fail with error : \(error.localizedDescription)")
    }
    
    private func showLocationPermissionAlert() {
         let alert = UIAlertController(title: "Location Access Denied",
                                       message: "Please enable location access in Settings to use this feature.",
                                       preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }
}

//MARK: - MKMapView

extension ApiMapsViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else {
            return nil
        }
        let identifier = K.crimeIdentifier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let crimeType = annotation.title {
            
            switch crimeType {
                
            case CrimesAndPoliceStations.crimeType[1]:
                annotationView?.markerTintColor = .red
            case CrimesAndPoliceStations.crimeType[2]:
                annotationView?.markerTintColor = .orange
            case CrimesAndPoliceStations.crimeType[3]:
                annotationView?.markerTintColor = .purple
            case CrimesAndPoliceStations.crimeType[4]:
                annotationView?.markerTintColor = .green
            case CrimesAndPoliceStations.crimeType[5]:
                annotationView?.markerTintColor = .blue
            default:
                annotationView?.markerTintColor = .yellow
            }
        }
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polygonOverlay = overlay as? ColoredPolygon,
           let color = polygonOverlay.color {
            let renderer = MKPolygonRenderer(polygon: polygonOverlay)
            renderer.strokeColor = color
            renderer.lineWidth = 2
            renderer.fillColor = color.withAlphaComponent(0.2)
            return renderer
        } else {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.strokeColor = UIColor.black
            renderer.lineWidth = 2
            renderer.fillColor = UIColor.black.withAlphaComponent(0.2)
            return renderer
        }
    }
}

class ColoredPolygon: MKPolygon {
    var color: UIColor?
}
