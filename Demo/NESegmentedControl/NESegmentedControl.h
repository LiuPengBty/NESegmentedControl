//
//  NESegmentedControl.h
//  NECustomerSegmentControl
//
//  Created by BtyLiuPeng on 1/1/16.
//  Copyright © 2016 BtyLiuPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NESegmentedControlDelegate;

@interface NESegmentedControl : UIView

@property (nonatomic, strong, nullable) NSArray<NSString *> *titles;

@property (nonatomic, assign, nullable) id<NESegmentedControlDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIdx;

@end

@interface NESegmentedControl (NEColorCategory)

/// color
@property (nonatomic, nullable) UIColor *titlesCustomeColor;
@property (nonatomic, nullable) UIColor *titlesHeightLightColor;
@property (nonatomic, nullable) UIColor *backgroundHeightLightColor;

/// tint color and white
@property (nonatomic, nullable) UIColor *tintColor;

@end

@interface NESegmentedControl (NEFont)

@property (nonatomic, nullable) UIFont *titleFont; // default : default system font, 17 font size.

@end

@interface NESegmentedControl (NEAnimation)

@property (nonatomic) CGFloat duration;  /// animation duration

- (void)setCurrentIdx:(NSUInteger)currentIdx animated:(BOOL)animate;

@end

@protocol NESegmentedControlDelegate <NSObject>

- (void)didSelectedItemAtIndex:(NSInteger)idx;

@end
