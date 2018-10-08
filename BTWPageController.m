
#import "BTWPageController.h"

#import "BTWPageTitleView.h"
#import "BTWPageContentView.h"

#import <Masonry.h>

@interface BTWPageController ()

@property (strong, nonatomic) BTWPageTitleView *pageTitleView; // 标题栏View
@property (strong, nonatomic) BTWPageContentView *pageContentView; // 内容View

@end

@implementation BTWPageController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.pageTitleView];
    [self.view addSubview:self.pageContentView];
    
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.height.offset(self.titleHeight);
    }];
    [self.pageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageTitleView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.equalTo(self.view);
    }];
    
    [self controlUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - public

- (void)changeTitleContentWithIndex:(NSInteger)index
{
    [self.pageTitleView selectTitleWithIndex:index];
    
    CGFloat offsetX = index * self.view.bounds.size.width;
    
    [self.pageContentView.pageCollectionView layoutIfNeeded];
    
    [self.pageContentView.pageCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}

#pragma mark - private

- (void)controlUI
{
    __weak typeof(self) weakSelf = self;
    
    self.pageTitleView.titleDidClickBlock = ^(NSInteger index) {
        
        // 点击 title 时, 调整 collectionView 偏移量
        
        CGFloat offsetX = index * weakSelf.pageContentView.frame.size.width;
        
        [weakSelf.pageContentView.pageCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    };
    
    self.pageContentView.didEndDecelerateBlock = ^(CGFloat offsetX) {
        
        // 滚动 collectionView 时 , 选中相应的 title
        
        NSInteger i = offsetX / self.view.bounds.size.width;
        
        [weakSelf.pageTitleView selectTitleWithIndex:i];
    };
}

#pragma mark - lazy

- (BTWPageTitleView *)pageTitleView {
    if (_pageTitleView == nil) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        [self.controllerArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray addObject:obj.title];
        }];
        
        NSArray *titleArray = tempArray;
        
        UIFont *titleSelectFont = self.titleSelectFont;
        UIFont *titleUnselectFont = self.titleUnselectFont;
        
        UIColor *titleSelectColor = self.titleSelectColer;
        UIColor *titleUnSelectColor = self.titleUnSelectColor;
        
        CGFloat underlineWidth = self.underlineWidth;
        CGFloat underlineHeight = self.underlineHeight;
        UIColor *underlineColor = self.underlineColor;
        
        BOOL showBottomLine = self.isShowBottomLine;
        BOOL syncUnderlineTitleWidth = self.isSyncUnderlineLabelWidth;
        
        _pageTitleView = [[BTWPageTitleView alloc] initWithFrame:CGRectZero
                                                          titles:titleArray
                                                 titleSelectFont:titleSelectFont
                                               titleUnselectFont:titleUnselectFont
                                                titleSelectColor:titleSelectColor
                                              titleUnSelectColor:titleUnSelectColor
                                                  underlineWidth:underlineWidth
                                                 underlineHeight:underlineHeight
                                                  underlineColor:underlineColor
                                                isShowBottomLine:showBottomLine
                                       isSyncUnderlineTitleWidth:syncUnderlineTitleWidth];
    }
    return _pageTitleView;
}

- (BTWPageContentView *)pageContentView {
    if (_pageContentView == nil) {
        
        NSArray *childVcArray = self.controllerArray;
        
        _pageContentView = [[BTWPageContentView alloc] initWithFrame:CGRectZero childVcArray:childVcArray parentViewController:self];
        
        _pageContentView.backgroundColor = [UIColor whiteColor];
    }
    return _pageContentView;
}

@end
