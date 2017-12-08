//
//  AppDelegate.h
//  zzl
//
//  Created by Mr_Du on 2017/10/30.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol wxDelegate<NSObject>

- (void)loginSuccessByCode:(NSString *)code;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,weak) id<wxDelegate>delegate;


@end

