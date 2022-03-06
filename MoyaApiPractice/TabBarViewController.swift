//
//  TabBarViewController.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2021/11/3.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        
        let mainVC = MainViewController()
       // let forecastVC = ForecastViewController()
        let reminderVC = ReminderListViewController()
        
        mainVC.tabBarItem.image = UIImage(systemName: "cloud.sun.fill")
       // forecastVC.tabBarItem.image = UIImage(systemName: "thermometer.sun.fill")
        reminderVC.tabBarItem.image = UIImage(systemName: "list.bullet.circle.fill")
        
        mainVC.title = "CurrentWeather"
       // forecastVC.title = "Forecast"
        reminderVC.title = "Reminder"
        
        self.tabBar.barTintColor = .clear
        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = .clear
        
        // 將ViewController依序加進TabbarController內
        setViewControllers([mainVC, reminderVC], animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
