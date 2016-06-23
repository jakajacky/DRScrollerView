//
//  DRImgScrollerView.swift
//  DRImgScrollerView
//
//  Created by xqzh on 16/6/20.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class DRImgScrollerView: UIView {
    
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    var num:Int = 0
    var yesToLoad:Int = 0
    
    
    var imgArray:NSMutableArray?
    
    var scrollView:UIScrollView
    
    var pageControl:UIPageControl
    
    override init(frame: CGRect) {
        
        scrollView = UIScrollView(frame: frame)
        pageControl = UIPageControl(frame: CGRectMake(0, 180, 375, 10))
        super.init(frame: frame)
    }
    
    convenience init(frame:CGRect, imgArray:NSArray) {
        
        
        self.init(frame: frame)
        
        width = frame.size.width
        height = frame.size.height
        
        let count = imgArray.count
        num = count
        
        scrollView.contentSize = CGSizeMake(frame.size.width * CGFloat(count + 2), 0)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
        
        // 首页
        var imgView = UIImageView(image: imgArray[count - 1] as? UIImage)
        imgView.frame = CGRectMake(0, 0, width, height)
        scrollView.addSubview(imgView)
        
        for i in 0..<count {
            imgView = UIImageView(image: imgArray[i] as? UIImage)
            imgView.frame = CGRectMake(CGFloat(i + 1) * width, 0, width, height)
            scrollView.addSubview(imgView)
        }
        
        // 尾页
        imgView = UIImageView(image: imgArray[0] as? UIImage)
        imgView.frame = CGRectMake(CGFloat(count + 1) * width, 0, width, height)
        scrollView.addSubview(imgView)
        
        scrollView.setContentOffset(CGPointMake(width, 0), animated: true)
        
        self.addSubview(scrollView)
        
        pageControl.numberOfPages = count
        print("-------\(pageControl.currentPage)")
        self.addSubview(pageControl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DRImgScrollerView : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let pageNum = scrollView.contentOffset.x / width
        if pageNum < 0.5 {
            pageControl.currentPage = num - 1
        }
        else if pageNum > 4.5 {
            pageControl.currentPage = 0
        }
        else {
            pageControl.currentPage = Int(round(pageNum - 1))
        }
        
    }

    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNum = scrollView.contentOffset.x / width
        if pageNum < 0.5 {
            scrollView.setContentOffset(CGPointMake(CGFloat(num) * width, 0), animated: false)
        }
        else if pageNum > 4.5 {
            scrollView.setContentOffset(CGPointMake(width, 0), animated: false)
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        yesToLoad += 1
    }

    
}
