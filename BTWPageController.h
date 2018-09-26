
#import <UIKit/UIKit.h>

@interface BTWPageController : UIViewController

/// 标题栏 高度
@property (nonatomic, assign) CGFloat titleHeight;

/// 标题栏 label 字体 选中状态
@property (nonatomic, strong) UIFont *titleSelectFont;

///  标题栏 label 字体 未选中状态
@property (nonatomic, strong) UIFont *titleUnselectFont;

/// 标题栏 文字 选中颜色
@property (nonatomic, strong) UIColor *titleSelectColer;

/// 标题栏 文字 未选中颜色
@property (nonatomic, strong) UIColor *titleUnSelectColor;

/// 标题栏 下划线 宽度
@property (nonatomic, assign) CGFloat underlineWidth;

/// 标题栏 下划线 高度
@property (nonatomic, assign) CGFloat underlineHeight;

/// 标题栏 下划线 颜色
@property (nonatomic, strong) UIColor *underlineColor;

/// 是否显示底线, 默认为NO
@property (nonatomic, assign, getter=isShowBottomLine) BOOL showBottomLine;

/// 下划线与Label宽度是否保持一致, 默认为NO
@property (nonatomic, assign, getter=isSyncUnderlineLabelWidth) BOOL syncUnderlineLabelWidth;

/// UIViewController 数组
@property (nonatomic, strong) NSArray <UIViewController *> *controllerArray;

/**
 根据 index 改变 title 和 content

 @param index VC 数组索引
 */
- (void)changeTitleContentWithIndex:(NSInteger)index;


@end
