//
//  SlidingContainerSliderView.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit
//let selectedColor = UIColor(red: 24/255.0, green: 89/255.0, blue: 118/255.0, alpha: 1.0)
//let selectedColor = UIColor(red: 25/255.0, green: 89/255.0, blue: 119/255.0, alpha: 1.0)
let selectedColor = UIColor.white
//let selectedTextColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
let selectedTextColor = UIColor.white

//let selectedColor = UIColor(red: 24/255.0, green: 89/255.0, blue: 118/255.0, alpha: 1.0)
//let selectedTextColor = UIColor(red: 24/255.0, green: 89/255.0, blue: 118/255.0, alpha: 1.0)

let bottomSelectorColor = UIColor.gray

struct SlidingContainerSliderViewAppearance {
    
    var backgroundColor: UIColor
    
    var font: UIFont
    var selectedFont: UIFont
    
    var textColor: UIColor
    var selectedTextColor: UIColor
    
    var outerPadding: CGFloat
    var innerPadding: CGFloat
    
    var selectorColor: UIColor
    var selectorHeight: CGFloat
    
    var fixedWidth: Bool
}

protocol SlidingContainerSliderViewDelegate {
    func slidingContainerSliderViewDidPressed (_ slidingtContainerSliderView: SlidingContainerSliderView, atIndex: Int)
}

class SlidingContainerSliderView: UIScrollView, UIScrollViewDelegate {
   
    // MARK: Properties
    
    var appearance: SlidingContainerSliderViewAppearance! {
        didSet {
            draw()
        }
    }
    
    var shouldSlide: Bool = true
    
    let sliderHeight: CGFloat = 35
    var titles: [String]!
    
    var labels: [UILabel] = []
    var selector: UIView!

    var sliderDelegate: SlidingContainerSliderViewDelegate?
    
    
    // MARK: Init
    
    init (width: CGFloat, titles: [String]) {
        super.init(frame: CGRect (x: 0, y: 0, width: width, height: sliderHeight))
        self.titles = titles
        let border = CALayer()
        border.backgroundColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: screenWidth, height: 1)
        self.layer.addSublayer(border)
        
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        scrollsToTop = false
        
        appearance = SlidingContainerSliderViewAppearance (
            backgroundColor: UIColor(hex: "FC6621"),
            
            font: UIFont (name: "Helvetica-Bold", size: 16)!,
            selectedFont: UIFont (name: "Helvetica-Bold", size: 16)!,
            
            textColor: selectedTextColor,
            selectedTextColor: selectedTextColor,
            
            outerPadding: 10,
            innerPadding: 10,
            
            selectorColor: selectedColor,
            selectorHeight: 7,
            fixedWidth: false)
        
        draw()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    
    // MARK: Draw
    
    func draw () {
        
        // clean
        if labels.count > 0 {
            for label in labels {
                
                label.removeFromSuperview()
                
                if selector != nil {
                    selector.removeFromSuperview()
                    selector = nil
                }
            }
        }
        
        labels = []
        backgroundColor = appearance.backgroundColor
        
        if appearance.fixedWidth {
            var labelTag = 0
            let width = CGFloat(frame.size.width) / CGFloat(titles.count)
            
            for title in titles {
                let label = labelWithTitle(title)
                label.frame.origin.x = (width * CGFloat(labelTag))
                label.frame.size = CGSize(width: width, height: label.frame.size.height)
                label.center.y = frame.size.height/2
                labelTag += 1
                label.tag = labelTag
                
                addSubview(label)
                labels.append(label)
            }
            
            let selectorH = appearance.selectorHeight
            selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: width, height: selectorH))
            selector.backgroundColor = bottomSelectorColor
            addSubview(selector)
            
            contentSize = CGSize (width: frame.size.width, height: frame.size.height)
        } else {
            var labelTag = 0
            var currentX = appearance.outerPadding
            
            for title in titles {
                let label = labelWithTitle(title)
                label.frame.origin.x = currentX
                label.center.y = frame.size.height/2
                labelTag += 1
                label.tag = labelTag
                label.backgroundColor = UIColor.black
                addSubview(label)
                labels.append(label)
                currentX += label.frame.size.width + appearance.outerPadding
            }
            
            let selectorH = appearance.selectorHeight
            selector = UIView (frame: CGRect (x: 0, y: frame.size.height - selectorH, width: 100, height: selectorH))
            selector.backgroundColor = bottomSelectorColor
            
            addSubview(selector)
            
            contentSize = CGSize (width: currentX, height: frame.size.height)
        }
        
    }
    
    func labelWithTitle (_ title: String) -> UILabel {
        
        let label = UILabel (frame: CGRect (x: 0, y: 0, width: 0, height: 0))
        label.text = title
        label.font = appearance.font
        label.textColor = appearance.textColor
        label.textAlignment = .center

        label.sizeToFit()
        label.frame.size.width += appearance.innerPadding * 2
        
        label.addGestureRecognizer(UITapGestureRecognizer (target: self, action: #selector(SlidingContainerSliderView.didTap(_:))))
        label.isUserInteractionEnabled = true
        
        return label
    }
    
    
    // MARK: Actions
    
    func didTap (_ tap: UITapGestureRecognizer) {
        self.sliderDelegate?.slidingContainerSliderViewDidPressed(self, atIndex: tap.view!.tag - 1)
    }
    
    
    // MARK: Menu
    
    func selectItemAtIndex (_ index: Int) {
        
        // Set Labels
        
        for i in 0..<self.labels.count {
            let label = labels[i]
            
            if i == index {
                
                label.textColor = appearance.selectorColor
                label.frame.origin.y = 0
                label.frame.size.height = self.frame.size.height
                //label.backgroundColor =  UIColor(red: 210/255.0, green: 242/255.0, blue: 244/255.0, alpha: 1.0)
                label.backgroundColor = UIColor(hex: "FC6621")
                label.font = appearance.selectedFont
                
                if !appearance.fixedWidth {
                    label.sizeToFit()
                    label.frame.size.width += appearance.innerPadding * 2
                }

                // Set selector
                
                UIView.animate(withDuration: 0.3, animations: {
                    [unowned self] in
                    self.selector.frame = CGRect (
                        x: label.frame.origin.x,
                        y: self.selector.frame.origin.y,
                        width: label.frame.size.width,
                        height: self.appearance.selectorHeight)
                })
                
            } else {
                
                label.textColor = appearance.textColor
                label.font = appearance.font
                  label.backgroundColor =  UIColor.clear
                if !appearance.fixedWidth {
                    label.sizeToFit()
                    label.frame.size.width += appearance.innerPadding * 2
                }
            }
        }
    }

}

