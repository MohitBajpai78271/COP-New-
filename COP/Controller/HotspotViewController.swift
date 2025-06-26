import UIKit
import MapKit



class HotspotViewController: UIViewController, MKMapViewDelegate {
    // Replace with your real ngrok or deployed URL
    let baseURL = ""

    // ← You need to define this:
    // If your FastAPI endpoint is the one that takes a raw source_url, point
    // it at your crime‐data JSON endpoint.
    let sourceURL = ""
    private let mapView = MKMapView()
    private var hotspotList: [Hotspot] = []
    private let annotationColors: [UIColor] = [
        .systemRed, .systemBlue, .systemGreen, .systemOrange,
        .systemPurple, .systemTeal, .systemPink, .systemIndigo,
        .brown, .cyan
    ]
    
    var coordinatesAlipur: [LatLon] = []
    var coordinatesBawana : [LatLon] = []
    var coordinatesBhalswa : [LatLon] = []
    var coordinatesNarela: [LatLon] = []
    var coordinatesNIA: [LatLon] = []
    var coordinatesSamaypur: [LatLon] = []
    var coordinatesSwaroop: [LatLon] = []
    var coordinatesShahbad: [LatLon] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        displayAllRegions()
           
           // Setup navigation bar appearance
           title = "Crime Hotspots"
           navigationItem.rightBarButtonItem = UIBarButtonItem(
               barButtonSystemItem: .done,
               target: self,
               action: #selector(doneButtonTapped)
           )
           
        // Customize nav bar color and text appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray5
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 22) // Increased font size here
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white // Done button color
        
           fetchHotspots()
           setupMapView()
          
    }
    
    func displayAllRegions() {
        coordinatesAlipur = loadCSV(from: Places.crimesLocation[0])
        coordinatesNIA = loadCSV(from: Places.crimesLocation[4])
        coordinatesNarela = loadCSV(from: Places.crimesLocation[3])
        coordinatesShahbad = loadCSV(from: Places.crimesLocation[6])
        coordinatesSamaypur = loadCSV(from: Places.crimesLocation[5])
        coordinatesBhalswa = loadCSV(from: Places.crimesLocation[2])
        coordinatesBawana = loadCSV(from: Places.crimesLocation[1])
        coordinatesSwaroop = loadCSV(from: Places.crimesLocation[7])
        setMapViewBoundaries(for: coordinatesAlipur, color: UIColor(red: 125/255, green: 100/255, blue: 9/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesNIA, color: UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesNarela, color: UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesShahbad, color: UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesSamaypur, color: UIColor(red: 128/255, green: 0/255, blue: 128/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesBhalswa, color: UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesBawana, color: UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1.0))
        setMapViewBoundaries(for: coordinatesSwaroop, color: UIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1.0))

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
        }
        
        return csvToStruct
    }
    
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Set initial region to Delhi
        let delhiCenter = CLLocationCoordinate2D(latitude: 28.6139, longitude: 77.2090)
        let region = MKCoordinateRegion(
            center: delhiCenter,
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        )
        mapView.setRegion(region, animated: false)
    }



    func fetchHotspots() {
      guard var components = URLComponents(string: baseURL) else {
        print("Invalid base URL")
        return
      }
      components.queryItems = [
        URLQueryItem(name: "source_url", value: sourceURL),
        URLQueryItem(name: "eps_km", value: "0.4"),
        URLQueryItem(name: "min_samples", value: "10")
      ]
      guard let url = components.url else {
        print("Failed to build URL")
        return
      }

      let request = URLRequest(url: url)
      URLSession.shared.dataTask(with: request) { data, resp, error in
        if let error = error {
          print("Network error:", error)
          return
        }
        guard
          let http = resp as? HTTPURLResponse,
          (200...299).contains(http.statusCode),
          let data = data
        else {
          print("Server error:", resp ?? "no response")
          return
        }

        do {
          let decoded = try JSONDecoder().decode(HotspotsResponse.self, from: data)
          DispatchQueue.main.async {
            self.updateUI(with: decoded.hotspots)
          }
        } catch {
          print("Decoding error:", error)
        }
      }
      .resume()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let ann = annotation as? HotspotAnnotation else { return nil }

        let identifier = "hotspotMarker"
        let markerView: MKMarkerAnnotationView
        if let dequeued = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            markerView = dequeued
            markerView.annotation = ann
        } else {
            markerView = MKMarkerAnnotationView(annotation: ann, reuseIdentifier: identifier)
            markerView.canShowCallout = true
            // show the cluster ID as a glyph
//            markerView.glyphText = "\(ann.cluster)"
//            markerView.titleVisibility = .visible
//            markerView.subtitleVisibility = .visible
        }

        // pick color by index
        if let idx = hotspotList.firstIndex(where: {
            $0.lat == ann.coordinate.latitude && $0.long == ann.coordinate.longitude
        }) {
            let color = annotationColors[idx % annotationColors.count]
            markerView.markerTintColor = color
        } else {
            markerView.markerTintColor = .gray
        }

        // make it bigger
        markerView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

        return markerView
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
    
    func updateUI(with hotspots: [Hotspot]) {
    
        let sorted = hotspots.sorted { $0.crime_count > $1.crime_count }

        self.hotspotList = sorted

        mapView.removeAnnotations(mapView.annotations)

        for (i, h) in sorted.enumerated() {
            let annotation = HotspotAnnotation(
                lat: h.lat,
                long: h.long,
                crimeCount: h.crime_count
            )
            annotation.title = "Patrol \(i + 1)"
            annotation.subtitle = "\(h.crime_count) crimes"
            mapView.addAnnotation(annotation)
        }
    }


}

struct Hotspot: Codable {
    let cluster: Int
    let lat: Double
    let long: Double
    let crime_count: Int
}

struct HotspotsResponse: Codable {
    let hotspots: [Hotspot]
}

class HotspotAnnotation: MKPointAnnotation {
    let crimeCount: Int
    
    init(lat: Double, long: Double,  crimeCount: Int) {
        self.crimeCount = crimeCount
        super.init()
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        subtitle = "\(crimeCount) crimes"
    }
}
