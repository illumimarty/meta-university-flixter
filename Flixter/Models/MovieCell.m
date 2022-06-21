//
//  MovieCell.m
//  Flixter
//
//  Created by Marty Nodado on 5/16/22.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.contentView.backgroundColor = UIColorFromRGB(0x252525);
    } else {
        self.contentView.backgroundColor = UIColorFromRGB(0x181818);
    }
}

- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;
    
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
    
    self.posterImage.image = nil;
    if (self.movie.posterUrl) {
        [self.posterImage setImageWithURL:self.movie.posterUrl];
    }
    
    self.titleLabel.textColor = UIColor.whiteColor;
    self.synopsisLabel.textColor = UIColor.whiteColor;

    
}

@end
