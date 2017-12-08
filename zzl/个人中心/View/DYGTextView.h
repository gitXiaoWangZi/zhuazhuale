//
//  DYGTextView.h
//  CS2.1
//
//  Created by Mr_Du on 2017/8/10.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYGTextView : UITextView
/*!
 * @brief 继承于UITextView，添加了placeholder支持，就像UITextField一样的拥有placeholder功能
 * @author huangyibiao
 */
/*!
 * 占位符文本,与UITextField的placeholder功能一致
 */
@property (nonatomic, strong) NSString *placeholder;

/*!
 * @brief 占位符文本颜色
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;
@end
