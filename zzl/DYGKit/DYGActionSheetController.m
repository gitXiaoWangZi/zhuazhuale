//
//  DYGAlertSheetController.m
//  test
//
//  Created by Mr_Du on 2017/10/29.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGActionSheetController.h"

@interface DYGActionSheetController ()

@end

@implementation DYGActionSheetController

+(instancetype)actionSheetVcWithArray:(NSArray *)array{
    DYGActionSheetController *vc = [DYGActionSheetController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *title in array) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([vc.delegate respondsToSelector:@selector(actionHandlerWith:)]) {
                [vc.delegate actionHandlerWith:action];
            }
        }];
        [vc addAction:action];
    }
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    return vc;
}
@end
