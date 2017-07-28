//
//  QTPageTitleView.m
//  FindProjectDemo
//
//  Created by I on 2017/5/5.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTPageTitleView.h"

@interface QTPageTitleView ()

@property (strong, nonatomic) NSArray *titleArray;

@property (assign, nonatomic) NSInteger oldIndex;

@property (strong, nonatomic) NSMutableArray *titleLabelArray;

@property (strong, nonatomic) UIView *scrollLine;

@property (nonatomic, strong) UIFont *titleFont; // 标题 字体 大小

@property (nonatomic, strong) UIColor *titleSelectColer; // 标题 选中 颜色

@property (nonatomic, strong) UIColor *titleUnSelectColor; // 标题 未选中 颜色

@property (nonatomic, strong) UIColor *underlineColor; // 下划线 颜色

@property (nonatomic, assign) CGFloat underlineHeight; // 下划线 高度

@end

@implementation QTPageTitleView

#pragma mark - lazy

- (NSMutableArray *)titleLabelArray
{
    if (_titleLabelArray == nil) {
        _titleLabelArray = [NSMutableArray array];
    }
    
    return _titleLabelArray;
}

- (UIView *)scrollLine
{
    if (_scrollLine == nil) {
        _scrollLine = [[UIView alloc] init];
        _scrollLine.backgroundColor = self.underlineColor;
    }
    
    return _scrollLine;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleFont:(UIFont *)titleFont titleSelectColor:(UIColor *)selectColor titleUnSelectColor:(UIColor *)unSelectColor underlineHeight:(CGFloat)underlineHeight underlineColor:(UIColor *)underlineColor
{
    
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.titleFont = titleFont;
        self.titleSelectColer = selectColor;
        self.titleUnSelectColor = unSelectColor;
        self.underlineHeight = underlineHeight;
        self.underlineColor = underlineColor;
        self.titleArray = titles;
        
        [self setUpSubViews];
    }
    
    return self;
}

#pragma mark - setUpSubViews

- (void)setUpSubViews
{
    [self setupTitleLabels];
    [self setupBottomLine];
}

- (void)setupTitleLabels
{
    CGFloat labelW = self.frame.size.width / self.titleArray.count;
    CGFloat labelH = self.frame.size.height - self.underlineHeight;
    CGFloat labelY = 0;
    
    for (int i = 0; i < self.titleArray.count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        
        label.tag = i;
        CGFloat labelX = labelW * i;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        label.font = self.titleFont;
        label.text = self.titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGes];
        
        [self addSubview:label];
        [self.titleLabelArray addObject:label];
        
        if (i == 0)
        {
            self.oldIndex = 0;
            
            label.textColor = self.titleSelectColer;
            
            // 添加下划线

            // 计算 title 的 text 的 width
            
            NSDictionary *attriDict = @{NSFontAttributeName : self.titleFont};
            
            
            CGFloat labelTextWidth = ceil([label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, labelH) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attriDict context:nil].size.width);
            
            
            self.scrollLine.qt_width = labelTextWidth + 5;
            self.scrollLine.qt_height = self.underlineHeight;
            self.scrollLine.qt_centerX = label.qt_centerX;
            self.scrollLine.qt_y = self.qt_height - self.scrollLine.qt_height;
            
            [self addSubview:self.scrollLine];
            
        }
    }
}

- (void)setupBottomLine
{
    // 底线
    
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    
    bottomLine.frame = CGRectMake(0, self.frame.size.height - 0.5 * SCALE_6S_HEIGHT, SCREEN_WIDTH, 0.5 * SCALE_6S_HEIGHT);
    
    [self addSubview:bottomLine];
}

#pragma mark - SEL

- (void)titleLabelClick:(UITapGestureRecognizer *)tapGes
{
    UILabel *currentLabel = (UILabel *)tapGes.view;
    
    if (self.oldIndex == currentLabel.tag)
    {
        return;
    }
    
    UILabel *oldLabel = self.titleLabelArray[self.oldIndex];

    self.oldIndex = currentLabel.tag;
    
    [self makeTitleLabelChangeWithOldLabel:oldLabel NowLabel:currentLabel];
    
    // block 传值
    
    if (self.qtTitleBlock) {
        
        self.qtTitleBlock(currentLabel);
    }
}

#pragma mark - label 根据 collectionView 改变

- (void)setTitleIndex:(NSInteger)index
{
    if (self.oldIndex == index)
    {
        return;
    }
    
    UILabel *nowLabel = self.titleLabelArray[index];
    
    UILabel *oldLabel = self.titleLabelArray[self.oldIndex];
    
    self.oldIndex = index;
    
    [self makeTitleLabelChangeWithOldLabel:oldLabel NowLabel:nowLabel];
    
}

#pragma mark - 私有方法

- (void)makeTitleLabelChangeWithOldLabel:(UILabel *)oldLabel NowLabel:(UILabel *)nowLabel
{
    oldLabel.textColor = self.titleUnSelectColor;
    nowLabel.textColor = self.titleSelectColer;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.scrollLine.qt_centerX = nowLabel.qt_centerX;
    }];
}

@end
