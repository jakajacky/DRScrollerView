//
//  DRImgScrollerView.swift
//  DRImgScrollerView
//
//  Created by xqzh on 16/6/20.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

// 定义闭包
typealias SendValueClosure = (index:CGFloat) -> Void

class DRImgScrollerView: UIView {
    
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    var num:Int = 0
    var yesToLoad:Int = 0
    
    
    var imgArray:NSMutableArray?
    
    var timer:NSTimer?
    
    // 声明一个闭包
    var sendValue:SendValueClosure?
    
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
        
        // 正式页
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
        
        // 时间触发器
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(DRImgScrollerView.run), userInfo: nil, repeats: true)
        self.performSelector(#selector(DRImgScrollerView.fire), withObject: nil, afterDelay: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 时间器触发动作
    func run() -> Void {
        var index:Int = pageControl.currentPage + 1
        index += 1
        print(index)
        
        if index == 6 {
            scrollView.setContentOffset(CGPointMake(CGFloat(2) * width, 0), animated: false)
        }
        else if index == 5 {
            scrollView.setContentOffset(CGPointMake(CGFloat(index) * width, 0), animated: true)
            
            self.performSelector(#selector(DRImgScrollerView.delay), withObject: nil, afterDelay: 1)
            
        }
        else {
            scrollView.setContentOffset(CGPointMake(CGFloat(index) * width, 0), animated: true)
        }
    }
    
    // 延时首尾切换
    func delay() -> Void {
        scrollView.setContentOffset(CGPointMake(CGFloat(1) * width, 0), animated: false)
    }
    
    // 延时启动时间器
    func fire() -> Void {
        timer?.fire()
    }
    
}

// DRImgScrollerView延展，遵循代理
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
        
        if round(pageNum) == pageNum {
            // 闭包传值
            sendValue?(index: pageNum)
        }
        
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // 取消timer
        timer?.pauseTimer()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // 开始timer
        timer?.resumeTimer()
        
        let pageNum = scrollView.contentOffset.x / width
        if pageNum < 0.5 {
            scrollView.setContentOffset(CGPointMake(CGFloat(num) * width, 0), animated: false)
        }
        else if pageNum > 4.5 {
            scrollView.setContentOffset(CGPointMake(width, 0), animated: false)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        yesToLoad += 1
    }

    
}

// 扩展NSTimer方法
extension NSTimer {
    
    func pauseTimer() -> Void {
        if !self.valid {
            return
        }
        
        self.fireDate = NSDate.distantFuture()
    }
    
    func resumeTimer() -> Void {
        if !self.valid {
            return
        }
        
        self.fireDate = NSDate()
    }
}
