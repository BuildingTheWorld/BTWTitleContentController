//
//  QTPageContentView.h
//  FindProjectDemo
//
//  Created by I on 2017/5/5.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^qtContentBlockType)(UIScrollView *scrollView);

@interface QTPageContentView : UIView

@property (strong, nonatomic) UICollectionView *pageCollectionView;

@property (nonatomic, copy) qtContentBlockType qtContentBlock;

- (instancetype)initWithFrame:(CGRect)frame childVcArray:(NSArray *)childVcArray parentViewController:(UIViewController *)parentController;

@end
