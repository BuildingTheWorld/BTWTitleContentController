
#import <UIKit/UIKit.h>

typedef void(^BTWDidEndDecelerateBlock)(CGFloat offsetX);

@interface BTWPageContentView : UIView

@property (nonatomic, strong, readonly) UICollectionView *pageCollectionView;

- (instancetype)initWithFrame:(CGRect)contentFrame
                 childVcArray:(NSArray *)childVcArray
         parentViewController:(UIViewController *)parentController;

@property (nonatomic, strong) BTWDidEndDecelerateBlock didEndDecelerateBlock;

@end
