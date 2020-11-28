import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }

    
    override func loadView() {
        print("hello from loadView()")
        // create a map view
        mapView = MKMapView()
        
        // set it as *the* view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // Option 1
        
        //        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        
        // Option 2
        
        //        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        
        // Option 3
        
        let topConstraint =
        segmentedControl.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        
        // Option 1 -- No margins
        //        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        //
        //        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        // Option 2 -- Margins
        let margins = view.layoutMarginsGuide
        
        let leadingConstraint =
        segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        let trailingConstraint =
        segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        
        // Set constraints to be active
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        
    } // end func loadView
    
    // Fucntion for changing the map type
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satelliteFlyover
        default:
            break
        } // end switch
    } // end func mapTypeChanged
    
} // end class
