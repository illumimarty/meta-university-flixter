//
//  MovieCell.m
//  Flixter
//
//  Created by Marty Nodado on 5/16/22.
//

#import "MovieCell.h"
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

@end
