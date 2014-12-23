//
//  SKBouncyMenu.h
//  SKBouncySample
//
//  Created by steven on 2014/12/19.
//  Copyright (c) 2014年 steven. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SKBouncyMenuItemImageKey;
extern NSString *const SKBouncyMenuItemTitleKey;

@interface Icon : UIView

@property (assign, nonatomic) CGFloat delta;
@end

@interface BouncyAnimationView : UIView

@property (retain, nonatomic) id switchView;
@property (retain, nonatomic) id responseView;
@property (assign, nonatomic) CGFloat delta;
@end

@protocol SKBouncyMenuDelegate <NSObject>

- (void)tapItemWithIndex:(NSUInteger)index;

@end

@interface SKBouncyMenu : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
{
	UIView *sideHelperView;
	UIView *centerHelperView;
	UIView *contentView;
	UIView *iconHelpView;
	
	CADisplayLink *displayLoop;
	NSUInteger animationCount;
	BOOL isOpen;
	
	BouncyAnimationView *animationView;
	Icon *iconView;
	
	NSArray *itemInfo;
	NSString *cellIdentifier;
	
	__weak id<SKBouncyMenuDelegate> delegate;
}

- (id)initWithFrame:(CGRect)frame withItemInfo:(NSArray *)inItemInfo;
- (void)toogleMenu;

@property (weak, nonatomic) id<SKBouncyMenuDelegate> delegate;
@end
