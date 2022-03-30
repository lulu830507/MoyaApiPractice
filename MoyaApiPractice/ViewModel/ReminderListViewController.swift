//
//  ReminderListViewController.swift
//  MoyaApiPractice
//
//  Created by linssuning on 2022/3/5.
//

import UIKit
import Moya

class ReminderListViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        selectedIndex = viewController.view.tag
        segmentControl.selectedSegmentIndex = selectedIndex
        let pageIndex = viewController.view.tag - 1
        if pageIndex < 0 {
            return nil
        }
        return viewControllerArr[pageIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        selectedIndex = viewController.view.tag
        segmentControl.selectedSegmentIndex = selectedIndex
        let pageIndex = viewController.view.tag + 1
        if pageIndex > 2 {
            return nil
        }
        return viewControllerArr[pageIndex]
    }
    
    var containerView = UIView() // 測試commit
    var segmentControl = UISegmentedControl()
    var pageViewControl = UIPageViewController()
    var viewControllerArr = Array<UIViewController>()
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        initSegmentControl()
        setPageViewControl()
        controlArray()
    }
    
    func initSegmentControl() {
        segmentControl = UISegmentedControl(items: ["Today", "Future", "All"])
        segmentControl.backgroundColor = UIColor.lightGray
        segmentControl.frame = CGRect.init(x: 100, y: 50, width: view.frame.width / 2, height: 30)
        segmentControl.addTarget(self, action: #selector(segmentedChange), for: .valueChanged)
        segmentControl.selectedSegmentIndex = selectedIndex
        self.view.addSubview(segmentControl)
        
    }
    
    @objc func segmentedChange(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        print(sender.titleForSegment(at: sender.selectedSegmentIndex)!)
        pageViewControl.setViewControllers([viewControllerArr[sender.selectedSegmentIndex]], direction: .forward, animated: false, completion: nil)
    }
    
    func setPageViewControl() {
        pageViewControl = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewControl.view.frame = CGRect.init(x: 0, y: 80, width: Int(self.view.frame.width), height: Int(self.view.frame.height - 300))
        pageViewControl.delegate = self
        pageViewControl.dataSource = self
        self.addChild(pageViewControl)
        self.view.addSubview(pageViewControl.view)
    }
    
    func controlArray() { //暫時設定
        let viewController1 = UIViewController()
        viewController1.view.backgroundColor = UIColor.red
        viewController1.view.tag = 0
        viewController1.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let viewController2 = UIViewController()
        viewController2.view.backgroundColor = UIColor.yellow
        viewController2.view.tag = 1
        viewController2.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let viewController3 = UIViewController()
        viewController3.view.backgroundColor = UIColor.green
        viewController3.view.tag = 2
        viewController3.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        viewControllerArr.append(viewController1)
        viewControllerArr.append(viewController2)
        viewControllerArr.append(viewController3)
        
        pageViewControl.setViewControllers([viewControllerArr[0]], direction: .forward, animated: false, completion: nil)
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
