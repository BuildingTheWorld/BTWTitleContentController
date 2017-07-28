//
//  QTPageTitleView.h
//  FindProjectDemo
//
//  Created by I on 2017/5/5.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^qtTitleBlockType)(UILabel *titleLabel);

@interface QTPageTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleFont:(UIFont *)titleFont titleSelectColor:(UIColor *)selectColor titleUnSelectColor:(UIColor *)unSelectColor underlineHeight:(CGFloat)underlineHeight underlineColor:(UIColor *)underlineColor;

@property (nonatomic, copy) qtTitleBlockType qtTitleBlock;

- (void)setTitleIndex:(NSInteger)index;

@end
