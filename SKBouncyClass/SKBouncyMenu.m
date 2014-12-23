//
//  SKBouncyMenu.m
//  SKBouncySample
//
//  Created by steven on 2014/12/19.
//  Copyright (c) 2014年 steven. All rights reserved.
//

#import "SKBouncyMenu.h"

@interface MenuCollectioinViewLayout : UICollectionViewFlowLayout

@end

@implementation MenuCollectioinViewLayout

- (void)prepareLayout
{
	self.itemSize = CGSizeMake(50.0, 50.0);
	self.sectionInset = UIEdgeInsetsMake(44.0, 0.0, 0.0, 0.0);
	[super prepareLayout];
}

- (NSUInteger)collectionViewItemCount
{
	NSUInteger sectionCount = [self.collectionView numberOfSections];
	NSUInteger cellCount = 0;
	for (NSUInteger index = 0; index < sectionCount; index ++) {
		cellCount += [self.collectionView numberOfItemsInSection:index];
	}
	return cellCount;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
	UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
	NSUInteger itemRow = path.row;
	attributes.frame = CGRectMake((self.collectionView.frame.size.width - self.itemSize.width) / 2.0,self.sectionInset.top + itemRow * (self.itemSize.height + 20.0), self.itemSize.width, self.itemSize.height);
	
	return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray* attributes = [NSMutableArray array];
	for (NSInteger index = 0 ; index < [self collectionViewItemCount]; index++) {
		NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
		[attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
	}
	return attributes;
}


@end

@interface MenuCollectionCell : UICollectionViewCell
{
	CALayer *iconLayer;
	CATextLayer *titleLayer;
}
- (void)setIcon:(UIImage *)inIcon;
- (void)setTitle:(NSString *)inTitle;
@end


@implementation MenuCollectionCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		iconLayer = [[CALayer alloc] init];
		iconLayer.frame = CGRectMake(10.0, 0.0, 30.0, 30.0);
		iconLayer.contentsScale = [UIScreen mainScreen].scale;
		[self.layer addSublayer:iconLayer];
		
		titleLayer = [[CATextLayer alloc] init];
		titleLayer.frame = CGRectMake(0.0, 30.0, 50.0, 20.0);
		titleLayer.font = (__bridge CFTypeRef)([UIFont boldSystemFontOfSize:8.0]);
		titleLayer.alignmentMode = kCAAlignmentCenter;
		titleLayer.fontSize = 8.0;
		titleLayer.foregroundColor = [UIColor whiteColor].CGColor;
		titleLayer.contentsScale = [UIScreen mainScreen].scale;
		[self.layer addSublayer:titleLayer];
	}
	return self;
}

- (void)setIcon:(UIImage *)inIcon
{
	iconLayer.contents = (id)inIcon.CGImage;
}

- (void)setTitle:(NSString *)inTitle
{
	titleLayer.string = inTitle;
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	if (highlighted) {
		titleLayer.foregroundColor = [UIColor redColor].CGColor;
	}
	else {
		titleLayer.foregroundColor = [UIColor whiteColor].CGColor;
	}
}
@end

@implementation BouncyAnimationView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (responseView) {
		return [responseView hitTest:point withEvent:event];
	}
	return [super hitTest:point withEvent:event];
}
- (void)drawRect:(CGRect)rect
{
	CGFloat limitWidth = rect.size.width - 50.0;
	if (delta > 50.0) {
		delta = 50.0;
	}
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(limitWidth, 0.0)];
	[path addQuadCurveToPoint:CGPointMake(limitWidth, rect.size.height) controlPoint:CGPointMake(limitWidth + delta, rect.size.height / 2.0)];
	[path addLineToPoint:CGPointMake(limitWidth, rect.size.height)];
	[path addLineToPoint:CGPointMake(0.0, rect.size.height)];
	[path addLineToPoint:CGPointMake(0.0, 0.0)];
	[path closePath];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	CGContextAddPath(context, path.CGPath);
	[[UIColor whiteColor] set];
	CGContextStrokePath(context);
}
@synthesize responseView;
@synthesize delta;
@end

NSString *const SKBouncyMenuItemImageKey = @"image";
NSString *const SKBouncyMenuItemTitleKey = @"title";

@implementation SKBouncyMenu

- (id)initWithFrame:(CGRect)frame withItemInfo:(NSArray *)inItemInfo
{
    self = [super initWithFrame:frame];
    if (self) {
		
		self.clipsToBounds = NO;
		itemInfo = inItemInfo;
		
		sideHelperView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
		sideHelperView.hidden = YES;
		[self addSubview:sideHelperView];
		centerHelperView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
		centerHelperView.hidden = YES;
		[self addSubview:centerHelperView];
		
		contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
		contentView.backgroundColor = [UIColor clearColor];
		[self addSubview:contentView];
		
		animationView = [[BouncyAnimationView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width + 50.0, frame.size.height)];
		animationView.backgroundColor = [UIColor clearColor];
		animationView.responseView = contentView;
		[self addSubview:animationView];
		
		MenuCollectioinViewLayout *layout = [[MenuCollectioinViewLayout alloc] init];
		
		UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height) collectionViewLayout:layout];
		
		collectionView.delegate = self;
		collectionView.dataSource = self;
		
		cellIdentifier = @"myMenuCell";
		[collectionView registerClass:[MenuCollectionCell class] forCellWithReuseIdentifier:cellIdentifier];
		
		[contentView addSubview:collectionView];
		
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
	return [itemInfo count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
	MenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	[cell setIcon:[[itemInfo objectAtIndex:indexPath.row] objectForKey:SKBouncyMenuItemImageKey]];
	[cell setTitle:[[itemInfo objectAtIndex:indexPath.row] objectForKey:SKBouncyMenuItemTitleKey]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if ([delegate respondsToSelector:@selector(tapItemWithIndex:)]) {
		[delegate tapItemWithIndex:indexPath.row];
	}
}

- (void)_resetLaout
{
	CGFloat start = isOpen ? self.frame.size.width : - self.frame.size.width;
	
	sideHelperView.frame = CGRectMake(start, 10.0, 10.0, 10.0);
	centerHelperView.frame = CGRectMake(start, self.frame.size.height / 2.0, 10.0, 10.0);
	animationView.frame = CGRectMake(start, 0.0, self.frame.size.width + 50.0, self.frame.size.height);
	contentView.frame = CGRectMake(start, 0.0, self.frame.size.width, self.frame.size.height);

}

- (void)toogleMenu
{
	[self _resetLaout];
	if (!isOpen) {
		self.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
	}
	else {
		self.frame = CGRectMake(-self.frame.size.width, 0.0, self.frame.size.width, self.frame.size.height);
	}
	
	[self _animationStart];
	[UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.75 initialSpringVelocity:0.8 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
		
		sideHelperView.frame = CGRectMake(0.0, 10.0, 10.0, 10.0);
		
	} completion:^(BOOL finished) {
		[self _animationComplete];
	}];
	
	[self _animationStart];
	[UIView animateWithDuration:0.8 delay:0.2 usingSpringWithDamping:0.3 initialSpringVelocity:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
		
		centerHelperView.frame = CGRectMake(0.0, self.frame.size.height / 2.0, 10.0, 10.0);
		
	} completion:^(BOOL finished) {
		isOpen = !isOpen;
		[self _animationComplete];
	}];

}

- (void)_updateDisplay:(CADisplayLink *)inLink
{
	CALayer *sideDisplayLayer = (CALayer *)sideHelperView.layer.presentationLayer;
	CALayer *centerDisplayLayer = (CALayer *)centerHelperView.layer.presentationLayer;
	
	animationView.frame = CGRectMake(CGRectGetMinX(sideDisplayLayer.frame), 0.0, self.frame.size.width + 50.0, self.frame.size.height);
	if (isOpen) {
		contentView.frame = CGRectMake(CGRectGetMinX(sideDisplayLayer.frame) - 20.0, 0.0, self.frame.size.width, self.frame.size.height);
	}
	else {
		contentView.frame = CGRectMake(CGRectGetMinX(sideDisplayLayer.frame), 0.0, self.frame.size.width, self.frame.size.height);
	}
	
	animationView.delta = CGRectGetMinX(sideDisplayLayer.frame) - CGRectGetMinX(centerDisplayLayer.frame);
	[animationView setNeedsDisplay];
}

- (void)_animationStart
{
	if (!displayLoop) {
		displayLoop = [CADisplayLink displayLinkWithTarget:self selector:@selector(_updateDisplay:)];
		[displayLoop addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	}
	animationCount ++;
}

- (void)_animationComplete
{
	animationCount --;
	if (!animationCount) {
		[displayLoop invalidate];
		displayLoop = nil;
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
}

@synthesize delegate;
@end
