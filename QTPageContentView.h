//
//  QTPageContentView.h
//  FindProjectDemo
//
//  Created by I on 2017/5/5.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QTContentBlockType)(UIScrollView *scrollView);

@interface QTPageContentView : UIView

@property (strong, nonatomic) UICollectionView *pageCollectionView;

@property (nonatomic, copy) QTContentBlockType qtContentBlock;

- (instancetype)initWithFrame:(CGRect)contentFrame childVcArray:(NSArray *)childVcArray parentViewController:(UIViewController *)parentController;

@end
