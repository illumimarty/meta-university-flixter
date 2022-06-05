//
//  PosterViewController.h
//  Flixter
//
//  Created by Marthan Nodado on 6/5/22.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (strong, nonatomic) NSDictionary *movie;
@end

NS_ASSUME_NONNULL_END
