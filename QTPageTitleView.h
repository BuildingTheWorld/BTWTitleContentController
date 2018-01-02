//
//  QTPageTitleView.h
//  FindProjectDemo
//
//  Created by I on 2017/5/5.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QTTitleBlockType)(UILabel *titleLabel);

@interface QTPageTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleFont:(UIFont *)titleFont titleSelectColor:(UIColor *)selectColor titleUnSelectColor:(UIColor *)unSelectColor underlineHeight:(CGFloat)underlineHeight underlineColor:(UIColor *)underlineColor isShowBottomLine:(BOOL)isShowBottomLine;

@property (nonatomic, copy) QTTitleBlockType qtTitleBlock;

- (void)setTitleIndex:(NSInteger)index;

@end
