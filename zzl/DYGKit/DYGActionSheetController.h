//
//  DYGAlertSheetController.h
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DYGActionSheetControllerDelegate<NSObject>
-(void)actionHandlerWith:(UIAlertAction *)action;
@end
@interface DYGActionSheetController : UIAlertController

+(instancetype)actionSheetVcWithArray:(NSArray *)array;
@property(nonatomic,weak)id<DYGActionSheetControllerDelegate> delegate;

@end
