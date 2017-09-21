//
//  ContainerViewController.swift
//  HackerPiper
//
//  Created by mohan on 9/21/17.
//  Copyright © 2017 mohan. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, SlidingContainerViewControllerDelegate,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var slidingContainerViewController : SlidingContainerViewController!
    var vc1 : ItemDetailViewController?
    var vc2 : WebViewController?
    var currentController: ItemDetailViewController?
    var scrollerViewControllerOriginY : CGFloat =  100
    var isAlreadyMovedUp : Bool = true
    var isAlreadyMovedDown : Bool = false

    var itemModel: Item!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initialSetup(){
    
        vc1 = UIStoryboard.itemDetailViewController()
        vc1?.itemModel = itemModel
        
        vc2  = UIStoryboard.webViewController()
        vc2?.urlString = itemModel.url ?? ""
        
        slidingContainerViewController = SlidingContainerViewController (
            parent: self,
            contentViewControllers: [vc1!, vc2!],
            titles: ["COMMENTS", "ARTICEL"] , frame : CGRect(x: 0, y: scrollerViewControllerOriginY, width: screenWidth, height: screenHeight - scrollerViewControllerOriginY))
        
        
        slidingContainerViewController.view.clipsToBounds = true
        
        view.addSubview(slidingContainerViewController.view)
        slidingContainerViewController.sliderView.appearance.outerPadding = 0
        slidingContainerViewController.sliderView.appearance.innerPadding = 0
        slidingContainerViewController.sliderView.appearance.fixedWidth = true
        slidingContainerViewController.setCurrentViewControllerAtIndex(0)
        slidingContainerViewController.delegate = self
        currentController = vc1
        
    }

}


extension ContainerViewController{
    func scrollViewDidScrollDelegate(scrollView : UIScrollView)
    {
        //if self.bannerArray.count > 0{
        
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).y < 0)
        {
            
            if(isAlreadyMovedDown)
            {
                if(scrollView.contentOffset.y > threshholdScrollerValue)
                {
                    isAlreadyMovedDown = true
                    UIView.animate(withDuration: 0.5, animations: {
                        self.slidingContainerViewController.view.frame = CGRect(x: 0, y:  navigationHeight - 44, width: screenWidth, height: screenHeight + 44 - (navigationHeight))
                    }, completion: { (isComplete) in
                        if isComplete
                        {
                            self.isAlreadyMovedUp = true
                        }
                    })
                }
            }
        }
        else
        {
            if isAlreadyMovedUp
                
            {
                if(scrollView.contentOffset.y < threshholdScrollerValue)
                {
                    isAlreadyMovedUp = false
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.slidingContainerViewController.view.frame = CGRect(x: 0, y: self.scrollerViewControllerOriginY, width: screenWidth, height: screenHeight - self.scrollerViewControllerOriginY)
                    }, completion: { (isComplete) in
                        if isComplete
                        {
                            self.isAlreadyMovedDown = true
                        }
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.slidingContainerViewController.view.frame = CGRect(x: 0, y: navigationHeight, width: screenWidth, height: screenHeight - (navigationHeight))
                    }, completion: { (isComplete) in
                        if isComplete
                        {
                            self.isAlreadyMovedDown = true
                        }
                    })
                }
            }
        }
        //}
        
    }
    
    // MARK: SlidingContainerViewControllerDelegate
    
    func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {
        
    }
    
    func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController) {
        
        
    }
    
    
    
    func slidingContainerViewControllerDidMoveToViewController (_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int)
    {
        
    }
    
}



