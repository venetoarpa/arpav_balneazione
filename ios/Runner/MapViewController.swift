//
//  MapViewController.swift
//  Runner
//
//  Created by Omar Ceretta on 27/06/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import UIKit
import Flutter
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    public var json_siti = ""
    public var fr : FlutterResult? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    
    var siti : [[String: Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        
         mapView.delegate = self
        do{
            self.siti = try (JSONSerialization.jsonObject(with: convertStringToData(str: json_siti), options: []) as? [[String: Any]])!
        }catch let e  {
            print(e.localizedDescription)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        var primo:CLLocationCoordinate2D? = nil
        for sito in self.siti! {
            
            let coordinates:CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: Double(sito["y_wgs"] as! String)!, longitude:  Double(sito["x_wgs"]as! String)!)

            if primo == nil {
                primo = coordinates
            }
            
            let artwork = Pointer(title: sito["descr"] as! String,
                                  locationName: sito["comune"] as! String,
                                  discipline: "",
                                  coordinate: coordinates)
            
            self.mapView.addAnnotation(artwork)
        }
        
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let region = MKCoordinateRegion(center: primo!, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Mappa")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(done))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    /**
     *    dismiss this view controller
     */
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func done() { // remove @objc for Swift 3
         navigationController?.popViewController(animated: true)
        fr!("result from new view controller");
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func convertStringToData( str : String) -> Data{
        return str.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            var p = annotation as! Pointer
            var thisSito : String = ""
            var sito_obj : [String : Any]?
        
            for sito in self.siti! {
                if(p.title == (sito["descr"] as! String)){
                    sito_obj = sito
                    thisSito = jsonToString(json: sito as AnyObject)
                    break
                }
            }
        
            var image = UIImage(named: "red.png")
        
            if (sito_obj!["statoatt"] as! String == "BLU") {
                image = UIImage(named: "blue.png")
            } else if (sito_obj!["statoatt"] as! String == "GIALLO") {
                image = UIImage(named: "orange.png")
            }
        
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: (sito_obj!["codsqst"] as! String))
        
        
            if annotationView != nil  {
                annotationView?.annotation = annotation
            } else {
                annotationView = MKAnnotationView(annotation:annotation, reuseIdentifier:(sito_obj!["codsqst"] as! String))
                annotationView?.isEnabled = true
                
               
                let btn = UIButton(type: .detailDisclosure)
                btn.accessibilityHint = thisSito
                
                btn.addTarget(self, action: #selector(VediSito(sender:)), for: .touchUpInside)
                
                annotationView?.rightCalloutAccessoryView = btn
               
            }
        
            annotationView?.image = image!
            annotationView?.backgroundColor = UIColor.clear
            annotationView?.canShowCallout = true
        
            print(annotationView?.image)
        return annotationView
    }
    
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString! // <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }

    func VediSito(sender: UIButton) {
        let sito = sender.accessibilityHint
        
        print("sito selected \(sito)")
        
        self.navigationController?.popViewController(animated: true)
        self.fr!(sito)
    }
    
}






class Pointer: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}


