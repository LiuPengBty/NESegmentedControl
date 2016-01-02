//
//  NESegmentedControl.m
//  NECustomerSegmentControl
//
//  Created by BtyLiuPeng on 1/1/16.
//  Copyright © 2016 BtyLiuPeng. All rights reserved.
//

#import "NESegmentedControl.h"

@interface NESegmentedControl ()
{
    UIColor *_titlesCustomeColor;
    UIColor *_titlesHeightLightColor;
    UIColor *_backgroundHeightLightColor;
    UIColor *_tintColor;
    
    UIFont *_titleFont;
    
    CGFloat _duration;
    
}

@property (nonatomic, strong, nullable) NSMutableArray *bottomLabels;
@property (nonatomic, strong, nullable) NSMutableArray *topLabels;
@property (nonatomic, strong, nullable) NSMutableArray *topButtons;

@property (nonatomic, strong, nonnull) UIView *heightColoreView;
@property (nonatomic, strong, nonnull) UIView *heightTopView;

@end

@implementation NESegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentIdx = 0;
        
        _bottomLabels = [NSMutableArray array];
        _topLabels = [NSMutableArray array];
        _topButtons = [NSMutableArray array];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self maskViewLayer];
    }
    return self;
}

- (void)maskViewLayer
{
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    
    maskLayer.frame=self.bounds;
    maskLayer.path=maskPath.CGPath;
    
    self.layer.mask=maskLayer;
    
    self.layer.masksToBounds=YES;
}

- (void)updateConstraintsIfNeeded
{
    [super updateConstraintsIfNeeded];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    NSLog(@"%@", NSStringFromCGRect(self.frame));
    [self updateBottomLabels];
    [self updateTopLabel];
    [self updateTopButtons];
}

/**
 *  计算当前高亮的Frame
 *
 *  @param index 当前点击按钮的Index
 *
 *  @return 返回当前点击按钮的Frame
 */
- (CGRect) currentRectWithIndex:(NSInteger)idx
{
    return  CGRectMake(self.bounds.size.width * idx / _titles.count, 0, self.bounds.size.width / _titles.count, self.bounds.size.height);
}

/**
 *  根据索引创建Label
 *
 *  @param index     创建的第几个Index
 *  @param textColor Label字体颜色
 *
 *  @return 返回创建好的label
 */
- (UILabel *)createLabel
{
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.minimumScaleFactor = 0.1f;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    return tempLabel;
}

- (void)createBottomLabels
{
    for (int i = 0; i < _titles.count; i++) {
        UILabel *tempLabel = [self createLabel];
        [self addSubview:tempLabel];
        [self.bottomLabels addObject:tempLabel];
    }
}

- (void)createTopLabels
{
    
    _heightColoreView = [[UIView alloc] init];
    _heightColoreView.clipsToBounds = YES;
    
    _heightTopView = [[UIView alloc] init];
    [_heightColoreView addSubview:_heightTopView];
    
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *label = [self createLabel];
        [_heightTopView addSubview:label];
        [self.topLabels addObject:label];
    }
    [self addSubview:_heightColoreView];
}

/**
 *  创建按钮
 */
- (void) createTopButtons {
    for (int i = 0; i < _titles.count; i ++) {
        UIButton *tempButton = [[UIButton alloc] init];
//        [tempButton setBackgroundImage:[self getImageFromColor:_backgroundHeightLightColor] forState:UIControlStateHighlighted];
        
        tempButton.tag = i;
        [tempButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topButtons addObject:tempButton];
        [self addSubview:tempButton];
    }
}

- (void)updateBottomLabels
{
    for (int i = 0; i < self.bottomLabels.count; i++) {
        UILabel *label = self.bottomLabels[i];
        label.frame = [self currentRectWithIndex:i];
    }
}

- (void)updateTopLabel
{
    CGRect heightColoreViewFrame = [self currentRectWithIndex:self.currentIdx];
    _heightColoreView.frame = heightColoreViewFrame;
    
    _heightTopView.frame = CGRectMake(0, 0, heightColoreViewFrame.size.width, heightColoreViewFrame.size.height);
    
    
    int beganIdx = -(int)self.currentIdx;
    int endIdx = -(int)self.currentIdx + (int)self.topLabels.count;
    
    for (int i = beganIdx; i < endIdx; i++) {
        UILabel *topLabel = self.topLabels[i + self.currentIdx];
        topLabel.frame = [self currentRectWithIndex:i];
        NSLog(@"%d %@",i, NSStringFromCGRect([self currentRectWithIndex:i]));
    }
}

- (void)updateTopButtons
{
    for (int i = 0; i < self.topButtons.count; i++) {
        UIButton *button = self.topButtons[i];
        button.frame = [self currentRectWithIndex:i];
    }
}

- (void)tapButton:(UIButton *)sender
{   
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItemAtIndex:)]) {
        [self.delegate didSelectedItemAtIndex:sender.tag];
    }
    
    [self setCurrentIdx:sender.tag animated:YES];
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    
    if (_titles != titles) {
        _titles = [titles copy];
        
        [self createBottomLabels];
        [self createTopLabels];
        [self createTopButtons];
        
        
        for (int i = 0; i < _titles.count; i++) {
            UILabel *label = self.bottomLabels[i];
            label.text = _titles[i];
            
            UILabel *topLabel = self.topLabels[i];
            topLabel.text = _titles[i];
        }
    }
}


- (void)setCurrentIdx:(NSInteger)currentIdx
{
    [self setCurrentIdx:currentIdx animated:NO];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat labelWidth = self.bounds.size.width / self.titles.count;
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat viewHeight = self.bounds.size.height;
    
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:CGRectMake(.5, .5, viewWidth - 1, viewHeight - 1)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(5, 5)];

    for (int i = 1; i < self.titles.count; i++) {
        [maskPath moveToPoint:CGPointMake(labelWidth * i, 0)];
        [maskPath addLineToPoint:CGPointMake(labelWidth * i, viewHeight)];
    }
    
    [maskPath closePath];
    
    [_tintColor setStroke];
    [maskPath stroke];
}

@end

@implementation NESegmentedControl (NEColorCategory)

@dynamic titlesCustomeColor;
@dynamic titlesHeightLightColor;
@dynamic backgroundHeightLightColor;
@dynamic tintColor;

- (void)setTitlesCustomeColor:(UIColor *)titlesCustomecolor
{
    if (_titlesCustomeColor != titlesCustomecolor) {
        _titlesCustomeColor = titlesCustomecolor;
        [self.bottomLabels makeObjectsPerformSelector:@selector(setTextColor:) withObject:_titlesCustomeColor];
    }
}

- (UIColor *)titlesCustomeColor
{
    return _titlesCustomeColor;
}

- (void)setTitlesHeightLightColor:(UIColor *)titlesHeightLightColor
{
    if (_titlesHeightLightColor != titlesHeightLightColor) {
        _titlesHeightLightColor = titlesHeightLightColor;
        [self.topLabels makeObjectsPerformSelector:@selector(setTextColor:) withObject:_titlesHeightLightColor];
    }
}

- (UIColor *)titlesHeightLightColor
{
    return _titlesHeightLightColor;
}

- (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originColor
{
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @{@"R":@(r),
             @"G":@(g),
             @"B":@(b),
             @"A":@(a)};
}

- (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha
{
    NSDictionary *rgba = [self getRGBDictionaryByColor:color];
    NSString *red = rgba[@"R"];
    NSString *green = rgba[@"G"];
    NSString *blue = rgba[@"B"];
    return [UIColor colorWithRed:red.doubleValue green:green.doubleValue blue:blue.doubleValue alpha:alpha];
}

- (UIImage *)getImageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setBackgroundHeightLightColor:(UIColor *)backgroundHeightLightColor
{
    if (_backgroundHeightLightColor != backgroundHeightLightColor) {
        _backgroundHeightLightColor = backgroundHeightLightColor;
        _heightColoreView.backgroundColor = _backgroundHeightLightColor;
        
        UIColor *newColor = [self colorWithColor:backgroundHeightLightColor alpha:0.2];
        
        for (UIButton *btn in self.topButtons) {
            [btn setBackgroundImage:[self getImageFromColor:newColor] forState:UIControlStateHighlighted];
        }
    }
}

- (UIColor *)backgroundHeightLightColor
{
    return _backgroundHeightLightColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        
        self.titlesCustomeColor = tintColor;
        self.titlesHeightLightColor = [UIColor whiteColor];
        self.backgroundHeightLightColor = tintColor;
    }
}

- (UIColor *)tintColor
{
    return _tintColor;
}

@end

@implementation NESegmentedControl (NEFont)

@dynamic titleFont;

- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        
        [self.bottomLabels makeObjectsPerformSelector:@selector(setFont:) withObject:titleFont];
        [self.topLabels makeObjectsPerformSelector:@selector(setFont:) withObject:titleFont];
    }
}

- (UIFont *)titleFont
{
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:17.0];
    }
    return _titleFont;
}

@end

@implementation NESegmentedControl (NEAnimation)

@dynamic duration;

- (void)setDuration:(CGFloat)duration
{
    if (_duration != duration) {
        _duration = duration;
    }
}

- (CGFloat)duration
{
    if (!_duration) {
        _duration = 0.35f;
    }
    return _duration;
}

- (void)setCurrentIdx:(NSUInteger)currentIdx animated:(BOOL)animate
{
    if (_currentIdx == currentIdx) {
        return;
    }
    
    NSInteger moveIdx = currentIdx - _currentIdx;
    
    _currentIdx = currentIdx;
    
    CGRect baganFrame = self.heightColoreView.frame;
    CGRect beganTopFrame = self.heightTopView.frame;
    
    CGFloat moveWidth = self.bounds.size.width/_titles.count * moveIdx;
    
    baganFrame.origin.x += moveWidth;
    beganTopFrame.origin.x -= moveWidth;
    
    
    self.duration = self.duration ?: .35f;
    if (animate) {
        
        [UIView animateWithDuration:self.duration animations:^{
            _heightColoreView.frame = baganFrame;
            _heightTopView.frame = beganTopFrame;
        }];
    }
    else {
        _heightColoreView.frame = baganFrame;
        _heightTopView.frame = beganTopFrame;
    }
}

@end
