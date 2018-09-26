
#import "BTWPageContentView.h"

#import "BTWPageTitleView.h"

#import <Masonry.h>

static NSString * const CellID = @"cellid";

@interface BTWPageContentView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIViewController *_parentVC;
}

@property (nonatomic, strong) NSArray *childVCArray;

@property (nonatomic, strong) UICollectionViewFlowLayout *pageFlowLayout;
@property (nonatomic, strong, readwrite) UICollectionView *pageCollectionView;

@end

@implementation BTWPageContentView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)contentFrame childVcArray:(NSArray *)childVcArray parentViewController:(UIViewController *)parentController {
    
    self.childVCArray = childVcArray;
    _parentVC = parentController;
    
    if (self = [super initWithFrame:contentFrame]) {
        
        // 将所有的子控制器添加父控制器中
        for (UIViewController *childVC in self.childVCArray)
        {
            [_parentVC addChildViewController:childVC];
        }

        [self addSubview:self.pageCollectionView];
        [self.pageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    self.pageFlowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

#pragma mark - collectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childVCArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];

    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *childVc = self.childVCArray[indexPath.item];
    
    [cell.contentView addSubview:childVc.view];
    [childVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    return cell;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.didEndDecelerateBlock) { 
        self.didEndDecelerateBlock(scrollView.contentOffset.x);
    }
}

#pragma mark - lazy

- (UICollectionViewFlowLayout *)pageFlowLayout {
    if (_pageFlowLayout == nil) {
        _pageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _pageFlowLayout.minimumLineSpacing = 0;
        _pageFlowLayout.minimumInteritemSpacing = 0;
        _pageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _pageFlowLayout;
}

- (UICollectionView *)pageCollectionView {
    if (_pageCollectionView == nil) {
        _pageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.pageFlowLayout];
        _pageCollectionView.dataSource = self;
        _pageCollectionView.delegate = self;
        _pageCollectionView.scrollsToTop = NO;
        _pageCollectionView.showsHorizontalScrollIndicator = NO;
        _pageCollectionView.bounces = NO;
        _pageCollectionView.pagingEnabled = YES;
        [_pageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
    }
    return _pageCollectionView;
}

@end
