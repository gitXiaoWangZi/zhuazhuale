//
//  FXTaskModel.h
//  zzl
//
//  Created by Mr_Du on 2017/11/23.
//  Copyright © 2017年 Mr.Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXTaskModel : NSObject

@property (nonatomic,copy) NSString *award_num;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *sign_name;
@property (nonatomic,copy) NSString *sign_type;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *status;

/*
 {
 "award_num" = 10;
 id = 1;
 img = "http://wawa.admin.fanx.xin/Public/common/update_img/20171118/1.jpg";
 "sign_name" = "\U8fdb\U884c\U6e38\U620f";
 "sign_type" = "march_game";
 sort = 1;
 status = 0;
 }
 */
@end
