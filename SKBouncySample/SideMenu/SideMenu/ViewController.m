//
//  ViewController.m
//  SideMenu
//
//  Created by steven on 2014/12/22.
//  Copyright (c) 2014年 steven. All rights reserved.
//

#import "ViewController.h"
#import "SKBouncyMenu.h"

@interface ViewController ()
{
	SKBouncyMenu *menu;
}
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	menu = [[SKBouncyMenu alloc] initWithFrame:CGRectMake(-100.0, 50.0, 150.0, self.view.frame.size.height - 50.0) withItemInfo:@[@{SKBouncyMenuItemImageKey : [UIImage imageNamed:@"testMenuItem1"], SKBouncyMenuItemTitleKey : @"Settings"}, @{SKBouncyMenuItemImageKey : [UIImage imageNamed:@"testMenuItem2"], SKBouncyMenuItemTitleKey : @"LISMO"}]];
	[self.view addSubview:menu];
	
//	UIButton *test = [UIButton buttonWithType:UIButtonTypeSystem];
//	test.frame = CGRectMake(200.0, 100.0, 50.0, 20.0);
//	[test setTitle:@"test" forState:UIControlStateNormal];
//	[test setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//	test.layer.borderWidth = 1.0;
//	test.layer.borderColor = [UIColor whiteColor].CGColor;
//	[test addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:test];
	
	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)test
{
	[menu toogleMenu];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
