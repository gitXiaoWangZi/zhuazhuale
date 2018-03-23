//
//  LSJGameSecretPopView.h
//  zzl
//
//  Created by Mr_Du on 2018/3/22.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSJGameSecretPopView : UIView

+ (instancetype)shareInstance;

- (void)refreshViewWithDic:(NSDictionary *)dictionary;
@end
