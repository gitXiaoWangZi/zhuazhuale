//
//  DYGTextView.m
//  CS2.1
//
//  Created by Mr_Du on 2017/8/10.
//  Copyright © 2017年 Mr_Du. All rights reserved.
//

#import "DYGTextView.h"

//@implementation DYGTextView

@interface DYGTextView () {
    BOOL _shouldDrawPlaceholder;
}

@end

@implementation DYGTextView

#pragma mark - 重写父类方法
- (void)setText:(NSString *)text {
    [super setText:text];
    [self drawPlaceholder];
    return;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (![placeholder isEqual:_placeholder]) {
        _placeholder = placeholder;
        [self drawPlaceholder];
    }
    return;
}

#pragma mark - 父类方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureBase];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureBase];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_shouldDrawPlaceholder) {
        [_placeholderTextColor set];
        [_placeholder drawInRect:CGRectMake(Px(8), 8.0f, self.width, self.height) withAttributes:@{NSFontAttributeName :self.font,NSForegroundColorAttributeName : _placeholderTextColor}];
    }
    return;
}

- (void)configureBase {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    _shouldDrawPlaceholder = NO;
    return;
}

- (void)drawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
    return;
}

- (void)textChanged:(NSNotification *)notification {
    [self drawPlaceholder];
    return;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    return;
}

@end
