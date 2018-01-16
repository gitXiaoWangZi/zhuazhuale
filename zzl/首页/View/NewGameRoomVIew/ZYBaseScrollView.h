//
//  ZYBaseScrollView.h
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/1.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZYBaseScrollView : UIScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end
