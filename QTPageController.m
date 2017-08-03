
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
        
        
        _pageTitleView = [[QTPageTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, titleHeight) titles:titleArray titleFont:titleFont titleSelectColor:titleSelectColor titleUnSelectColor:titleUnSelectColor underlineHeight:underlineHeight underlineColor:underlineColor];
        
    }
    
    return _pageTitleView;
}

- (QTPageContentView *)pageContentView
{
    if (_pageContentView == nil)
    {
        NSArray *childVcArray = self.ControllerArray;
        
        CGFloat pageTitleHeight = self.titleHeight;
        
        _pageContentView = [[QTPageContentView alloc] initWithFrame:CGRectMake(0, pageTitleHeight, self.view.bounds.size.width, self.view.bounds.size.height - pageTitleHeight) childVcArray:childVcArray parentViewController:self];
        
        _pageContentView.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _pageContentView;
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpSubViews];
    
    [self controlUI];
    
}

#pragma mark - 私有方法

- (void)setUpSubViews
{
    
    [self.view addSubview:self.pageTitleView];
    
    [self.view addSubview:self.pageContentView];
    
}

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


- (void)makeTitlePageWithIndex:(NSInteger)index
{
    CGFloat offsetX = index * self.pageContentView.frame.size.width;
    
    [self.pageContentView.pageCollectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
    [self.pageTitleView setTitleIndex:index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
