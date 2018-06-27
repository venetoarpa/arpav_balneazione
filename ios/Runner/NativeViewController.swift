//  NativeViewController.swift
//

import Foundation
import UIKit


class NativeViewController: UIViewController {
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
    }

    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func sayHello(_ personName: String) -> String {
        let greeting = "Hello, " + personName + "!"
        return greeting
    }
    
    func pushView(){
        print("native view");
    }
    
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
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
        
    }
}
