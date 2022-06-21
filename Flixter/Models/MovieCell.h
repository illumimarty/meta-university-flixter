//
//  MovieCell.h
//  Flixter
//
//  Created by Marty Nodado on 5/16/22.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (nonatomic, strong) Movie *movie;
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

- (void)setMovie: (Movie*)movie;

@end

NS_ASSUME_NONNULL_END
