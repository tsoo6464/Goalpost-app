//
//  UIViewControllerExt.swift
//  Goalpost-app
//
//  Created by Nan on 2018/2/12.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        animated(subType: kCATransitionFromRight)
        // animated 為false 因為已經自己設定了動畫 若設定為true會使用預設的動畫
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    // 讓下一個視圖dismiss的時候忽略此視圖
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        guard let presentedViewController = presentedViewController else { return }
        
        presentedViewController.dismiss(animated: false) {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
    }
    
    func dismissDetail() {
        animated(subType: kCATransitionFromLeft)
        // animated 為false 因為已經自己設定了動畫 若設定為true會使用預設的動畫
        dismiss(animated: false, completion: nil)
    }
    
    func animated(subType: String) {
        let transition = CATransition()
        // 動畫秒數
        transition.duration = 0.3
        // 設定動畫呈現的類型
        transition.type = kCATransitionPush
        // ex:kCATransitionFromRight 就是從右側到左邊 Left反之
        transition.subtype = subType
        // 將指定的動畫物件加入到圖層
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }
    
}
