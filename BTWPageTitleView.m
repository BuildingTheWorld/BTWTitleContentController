
#import "BTWPageTitleView.h"

@interface BTWPageTitleView ()
{
    UIView *_bottomLine;
    
    NSArray *_titleArray;
    
    UIFont *_titleSelectFont;
    UIFont *_titleUnselectFont;
    
    UIColor *_titleSelectColer;
    UIColor *_titleUnSelectColor;
    
    UIColor *_underlineColor;
    CGFloat _underlineWidth;
    CGFloat _underlineHeight;
    
    CGFloat _labelH;

    BOOL _showBottomLine;
    BOOL _syncUnderlineTitleWidth;
    
    NSInteger _oldIndex;
}

@property (strong, nonatomic) NSMutableArray <UILabel *> *titleLabelArray;
@property (strong, nonatomic) UIView *scrollLine;

@end

@implementation BTWPageTitleView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
              titleSelectFont:(UIFont *)titleSelectFont
            titleUnselectFont:(UIFont *)titleUnselectFont
             titleSelectColor:(UIColor *)selectColor
           titleUnSelectColor:(UIColor *)unSelectColor
               underlineWidth:(CGFloat)underlineWidth
              underlineHeight:(CGFloat)underlineHeight
               underlineColor:(UIColor *)underlineColor
             isShowBottomLine:(BOOL)isShowBottomLine
    isSyncUnderlineTitleWidth:(BOOL)isSyncUnderlineTitleWidth {
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor whiteColor];
        
        _titleArray = titles;
        
        _titleSelectFont = titleSelectFont;
        _titleUnselectFont = titleUnselectFont;
        
        _titleSelectColer = selectColor;
        _titleUnSelectColor = unSelectColor;
        
        _underlineWidth = underlineWidth;
        _underlineHeight = underlineHeight;
        _underlineColor = underlineColor;
        
        _showBottomLine = isShowBottomLine;
        _syncUnderlineTitleWidth = isSyncUnderlineTitleWidth;
        
        [self setUpSubViews];
    }
    return self;
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutTitleLabels];
    
    if (_showBottomLine == YES) {
     
        [self layoutBottomLine];
    }
}

- (void)layoutTitleLabels {
    CGFloat labelW = self.bounds.size.width / _titleArray.count;
    CGFloat labelH = self.bounds.size.height;
    _labelH = labelH;
    CGFloat labelY = 0;
    
    [self.titleLabelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat labelX = labelW * idx;
        obj.frame = CGRectMake(labelX, labelY, labelW, labelH);
    }];
    
    UILabel *currectSelectLabel = self.titleLabelArray[_oldIndex];
    
    if (_syncUnderlineTitleWidth == YES) {
        CGFloat labelTextWidth = [self getTextWidth:currectSelectLabel]; // 计算 title 的 text 的 width
        self.scrollLine.width = labelTextWidth + 5;
    } else {
        self.scrollLine.width = _underlineWidth;
    }
    
    self.scrollLine.height = _underlineHeight;
    self.scrollLine.centerX = currectSelectLabel.centerX;
    self.scrollLine.top = labelH - _underlineHeight;
}

- (void)layoutBottomLine {
    
    _bottomLine.frame = CGRectMake(0, self.bounds.size.height - 0.4, self.bounds.size.width, 0.4);
}

#pragma mark - setUpSubViews

- (void)setUpSubViews
{
    [self setupTitleLabels];
    
    if (_showBottomLine == YES) {
        
        [self setupBottomLine];
    }
}

- (void)setupTitleLabels
{
    [_titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [self.titleLabelArray addObject:label];
        
        label.tag = idx;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = _titleUnselectFont;
        label.text = obj;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGes];
        
        if (idx == 0)
        {
            _oldIndex = idx;
            
            label.textColor = _titleSelectColer;
            label.font = _titleSelectFont;
            
            // 添加下划线
            
            [self addSubview:self.scrollLine];
        }
        
    }];
    
}

- (void)setupBottomLine // 是底线, 不是下划线
{
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = [UIColor colorWithRGB:0xE4E7EB];
    
    [self addSubview:_bottomLine];
}

#pragma mark - Action

- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes
{
    UILabel *currentLabel = (UILabel *)tapGes.view;
    
    if (_oldIndex == currentLabel.tag) {
        return;
    }
    
    UILabel *oldLabel = self.titleLabelArray[_oldIndex];

    _oldIndex = currentLabel.tag;
    
    [self makeTitleLabelChangeWithOldLabel:oldLabel NowLabel:currentLabel];
    
    if (self.titleDidClickBlock) {
        self.titleDidClickBlock(currentLabel.tag);
    }
}

#pragma mark - public

- (void)selectTitleWithIndex:(NSInteger)index
{
    if (_oldIndex == index) {
        return;
    }
    
    UILabel *nowLabel = self.titleLabelArray[index];
    UILabel *oldLabel = self.titleLabelArray[_oldIndex];
    
    _oldIndex = index;
    
    [self makeTitleLabelChangeWithOldLabel:oldLabel NowLabel:nowLabel];
}

#pragma mark - private

// 改变 title 颜色 和 下划线 位置 宽度
- (void)makeTitleLabelChangeWithOldLabel:(UILabel *)oldLabel NowLabel:(UILabel *)nowLabel
{
    oldLabel.textColor = _titleUnSelectColor;
    nowLabel.textColor = _titleSelectColer;
    
    oldLabel.font = _titleUnselectFont;
    nowLabel.font = _titleSelectFont;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (_syncUnderlineTitleWidth == YES){
            CGFloat underlineW = [self getTextWidth:nowLabel];
            self.scrollLine.width = underlineW + 5;
        }
        self.scrollLine.centerX = nowLabel.centerX;
    }];
}

// 计算 title 的 text 的 width
- (CGFloat)getTextWidth:(UILabel *)label
{
    NSDictionary *attriDict = @{NSFontAttributeName : _titleSelectColer};
    
    return ceil([label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, _labelH) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attriDict context:nil].size.width);
}

#pragma mark - lazy

- (NSMutableArray *)titleLabelArray {
    if (_titleLabelArray == nil) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (UIView *)scrollLine {
    if (_scrollLine == nil) {
        _scrollLine = [[UIView alloc] init];
        _scrollLine.backgroundColor = _underlineColor;
        _scrollLine.layer.cornerRadius = _underlineHeight / 2;
    }
    return _scrollLine;
}

@end
