
#import <UIKit/UIKit.h>

/**
 title 点击事件回调

 @param
 */
typedef void(^BTWTitleClickBlock)(NSInteger index);

@interface BTWPageTitleView : UIView

/**
 初始化 titleView

 @param frame titleView 的 frame
 @param titles title 数组
 @param titleSelectFont 选中 label 字体
 @param titleUnselectFont 未选中 lable 字体
 @param selectColor 选中 lable 颜色
 @param unSelectColor 未选中 label 颜色
 @param underlineWidth 下划线宽度
 @param underlineHeight 下划线高度
 @param underlineColor 下划线颜色
 @param isShowBottomLine 是否显示底线 默认为NO
 @param isSyncUnderlineTitleWidth 下划线宽度是否与 label 宽度保持一致
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
              titleSelectFont:(UIFont *)titleSelectFont
            titleUnselectFont:(UIFont *)titleUnselectFont
             titleSelectColor:(UIColor *)selectColor
           titleUnSelectColor:(UIColor *)unSelectColor
               underlineWidth:(CGFloat)bottomLineWidth
              underlineHeight:(CGFloat)underlineHeight
               underlineColor:(UIColor *)underlineColor
             isShowBottomLine:(BOOL)isShowBottomLine
   isSyncUnderlineTitleWidth:(BOOL)isSyncUnderlineTitleWidth;

@property (nonatomic, strong) BTWTitleClickBlock titleDidClickBlock;

/**
 根据 index 选中对应的 title

 @param index titles 数组的索引
 */
- (void)selectTitleWithIndex:(NSInteger)index;

@end
