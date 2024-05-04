//
//  ImageDetailViewController.swift
//  MachineTest_QuantumIT
//
//  Created by ROHIT DAS on 04/05/24.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        view.backgroundColor = .clear
        
        // Add blur effect background
        addBlurEffect()
        
        // Create and configure the image view
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        // Add tap gesture to dismiss the view controller
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true // Hide the status bar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addBlurEffect() {
        // Create blur effect view
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView) 
    }
}
