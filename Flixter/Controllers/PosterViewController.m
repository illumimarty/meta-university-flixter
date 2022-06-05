//
//  PosterViewController.m
//  Flixter
//
//  Created by Marthan Nodado on 6/5/22.
//

#import "PosterViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PosterViewController ()
@end

@implementation PosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.posterImageView setImageWithURL:self.movieURL];
    self.view.backgroundColor = UIColorFromRGB(0x121212);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x181818);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tabBarController.tabBar.barTintColor = UIColorFromRGB(0x121212);
    self.tabBarController.tabBar.tintColor = UIColor.whiteColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
