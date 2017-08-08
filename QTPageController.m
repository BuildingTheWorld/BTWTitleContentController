
#import "QTPageController.h"

#import "QTPageTitleView.h"

#import "QTPageContentView.h"

@interface QTPageController ()

@property (strong, nonatomic) QTPageTitleView *pageTitleView; // 标题栏View

@property (strong, nonatomic) QTPageContentView *pageContentView; // 内容View

@end

@implementation QTPageController

#pragma mark - lazy

- (QTPageTitleView *)pageTitleView
{
    if (_pageTitleView == nil)
    {
        
        CGFloat titleHeight = self.titleHeight;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        
        [self.ControllerArray enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [tempArray addObject:obj.title];
        }];
        
        
        NSArray *titleArray = tempArray;
        
        UIFont *titleFont = self.titleFont;
        
        UIColor *titleSelectColor = self.titleSelectColer;
        
        UIColor *titleUnSelectColor = self.titleUnSelectColor;
        
        CGFloat underlineHeight = self.underlineHeight;
        
        UIColor *underlineColor = self.underlineColor;
        
        
        _pageTitleView = [[QTPageTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight) titles:titleArray titleFont:titleFont titleSelectColor:titleSelectColor titleUnSelectColor:titleUnSelectColor underlineHeight:underlineHeight underlineColor:underlineColor];
        
    }
    
    return _pageTitleView;
}

- (QTPageContentView *)pageContentView
{
    if (_pageContentView == nil)
    {
        NSArray *childVcArray = self.ControllerArray;
        
        _pageContentView.titleHeight = self.titleHeight;
        
        _pageContentView = [[QTPageContentView alloc] initWithFrame:CGRectZero childVcArray:childVcArray parentViewController:self];
        
        
        _pageContentView.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _pageContentView;
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.pageContentView];
    
    [self.view addSubview:self.pageTitleView];

    
    
    
    [self.pageContentView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.pageTitleView.mas_bottom);
        make.left.right.offset(0);
        make.bottom.equalTo(self.view);
    }];
    
    
    
    [self controlUI];
    
    
}

#pragma mark - 私有方法


- (void)controlUI
{
    
    __weak typeof(self) weakSelf = self;
    
    
    self.pageTitleView.qtTitleBlock = ^(UILabel *titleLabel) {
        
        
        // 点击 title 时, 调整 collectionView 偏移量
        
        CGFloat offsetX = titleLabel.tag * weakSelf.pageContentView.frame.size.width;
        
        [weakSelf.pageContentView.pageCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    };
    
    
    self.pageContentView.qtContentBlock = ^(UIScrollView *scrollView) {
        
        
        // 滚动 collectionView 时 , 选中相应的 title
        
        NSInteger i = scrollView.contentOffset.x / SCREEN_WIDTH;
        
        [weakSelf.pageTitleView setTitleIndex:i];
        
    };
    
}


- (void)makeTitlePageWithIndex:(NSInteger)index // 如果 调用了 这个方法 设置 PageVC, 就会先懒加载两个控件, 但此时 得到的 self.view.bounds.size.height 是不准确的 (在 viewWillLayoutSubviews 中是准确的), 所以暂时将 pageContentView 的 初始化 方法 的 高度 设置为 SCREEN_HEIGHT - 64 - pageTitleHeight (原来为 self.view.bounds.size.height - self.titleHeight)
{
    [self.pageTitleView setTitleIndex:index];
    
    
    CGFloat offsetX = index * self.pageContentView.frame.size.width;
    
    [self.pageContentView.pageCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
