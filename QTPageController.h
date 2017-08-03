
#import <UIKit/UIKit.h>

@interface QTPageController : UIViewController

/// 标题栏 高度

@property (nonatomic, assign) CGFloat titleHeight;

/// 标题栏 字体

@property (nonatomic, strong) UIFont *titleFont;

/// 标题栏 文字 选中颜色

@property (nonatomic, strong) UIColor *titleSelectColer;

/// 标题栏 文字 未选中颜色

@property (nonatomic, strong) UIColor *titleUnSelectColor;

/// 标题栏 下划线 高度

@property (nonatomic, assign) CGFloat underlineHeight;

/// 标题栏 下划线 颜色

@property (nonatomic, strong) UIColor *underlineColor;

/// 控制器 数组

@property (nonatomic, strong) NSArray <UIViewController *> *ControllerArray;

/// 根据 index 控制 title 和 内容 View

- (void)makeTitlePageWithIndex:(NSInteger)index;

@end
