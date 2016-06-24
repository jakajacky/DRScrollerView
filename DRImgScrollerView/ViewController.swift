//
//  ViewController.swift
//  DRImgScrollerView
//
//  Created by xqzh on 16/6/20.
//  Copyright © 2016年 xqzh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var arr = NSMutableArray()
        for i in 0..<4 {
            let str = "image\(i)"
            let img = UIImage(named: str)
            arr.addObject(img!)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let imgView = DRImgScrollerView(frame: CGRectMake(0, 0, 375, 200), imgArray: arr)
        self.view.addSubview(imgView)
        
        // 闭包实现 轮播监听图片页码
        imgView.sendValue = { (page:CGFloat) -> Void in
            print("当前页：\(page)")
        }
        
        // 或者 以将函数赋给闭包，因为闭包可以理解无名字的函数是一样的
        // imgView.sendValue = sendValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sendValue(pageNum:CGFloat) -> Void {
        print("当前页：\(pageNum)")
    }

}

