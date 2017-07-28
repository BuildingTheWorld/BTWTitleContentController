//
//  QTPageContentView.m
//  FindProjectDemo
//
//  Created by I on 2017/5/5.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTPageContentView.h"

#import "QTPageTitleView.h"

static NSString * const CellID = @"cellid";

@interface QTPageContentView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *childVcArray;

@property (weak, nonatomic) UIViewController *parentVc;

@property (strong, nonatomic) UICollectionViewFlowLayout *pageFlowLayout;

@end

@implementation QTPageContentView

#pragma mark - lazy

- (UICollectionViewFlowLayout *)pageFlowLayout
{
    if (_pageFlowLayout == nil) {
        _pageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _pageFlowLayout.itemSize = self.bounds.size;
        _pageFlowLayout.minimumLineSpacing = 0;
        _pageFlowLayout.minimumInteritemSpacing = 0;
        _pageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return _pageFlowLayout;
}

- (UICollectionView *)pageCollectionView
{
    if (_pageCollectionView == nil)
    {
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.pageFlowLayout];
        _pageCollectionView.dataSource = self;
        _pageCollectionView.delegate = self;
        _pageCollectionView.scrollsToTop = NO;
        _pageCollectionView.bounces = NO;
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.pagingEnabled = YES;
        [_pageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
    }
    
    return _pageCollectionView;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame childVcArray:(NSArray *)childVcArray parentViewController:(UIViewController *)parentController
{
    if (self = [super initWithFrame:frame]){
        self.childVcArray = childVcArray;
        self.parentVc = parentController;
    }
    [self setUpSubViews];
    
    return self;
}

#pragma mark - setUpSubViews

- (void)setUpSubViews
{
    // 将所有的子控制器添加父控制器中
    
    for (UIViewController *childVC in self.childVcArray)
    {
        [self.parentVc addChildViewController:childVC];
    }
    
    // 添加 collectionView
    
    [self addSubview:self.pageCollectionView];
    
    self.pageCollectionView.frame = self.bounds;
}

#pragma mark - collectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childVcArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIViewController *childVc = self.childVcArray[indexPath.item];
    
    [cell.contentView addSubview:childVc.view];
    
    [childVc.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView);
        make.width.equalTo(cell.contentView);
        make.height.equalTo(cell.contentView);
    }];
    
    return cell;
}


#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.qtContentBlock) { // block 传值
        
        self.qtContentBlock(scrollView);
    }
}


@end
