//
//  ViewController.swift
//  MachineTest_QuantumIT
//
//  Created by ROHIT DAS on 03/05/24.
//

import UIKit

class TabBarController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create tab bar controller
        let tabBarController = UITabBarController()
        
        // Create view controllers for each tab
        let homeViewController = HomeViewController()
        homeViewController.view.backgroundColor = .white
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
        
        let secondViewController = SecondViewController()
        secondViewController.view.backgroundColor = .white
        secondViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "dumbbell"), selectedImage: nil)
    
        let chartViewController = ChartViewController() // Initialize ChartViewController
        chartViewController.view.backgroundColor = .white
        chartViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "chart.bar.xaxis"), selectedImage: nil)
        
        let fourthViewController = UIViewController()
        fourthViewController.view.backgroundColor = .white
        fourthViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "doc"), selectedImage: nil)
        
        // Set view controllers for the tab bar controller
        tabBarController.setViewControllers([homeViewController, secondViewController, chartViewController, fourthViewController], animated: false)
        tabBarController.tabBar.tintColor = .black
        
        // Adding the tab bar controller as a child view controller
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
       
        tabBarController.view.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
}
