//
//  LSJTaskPopView.h
//  zzl
//
//  Created by Mr_Du on 2018/1/12.
//  Copyright © 2018年 Mr.Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSJTaskPopViewDelegate<NSObject>

- (void)sureBringActionWithNum:(NSInteger)num award_num:(NSString *)award_num;
@end

@interface LSJTaskPopView : UIView

@property (nonatomic,assign) NSInteger num;
@property (nonatomic,strong) NSString *award_num;
- (void)refreshViewWithNum:(NSInteger)num award_num:(NSString *)award_num;

@property (nonatomic,assign) id<LSJTaskPopViewDelegate> delegate;
@end
