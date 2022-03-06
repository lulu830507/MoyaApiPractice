//
//  ReminderListViewController.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2022/3/5.
//

import UIKit

class ReminderListViewController: UIViewController {

    var infoView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.3)
        view.layer.cornerRadius = 50
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
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
