//
//  MovieAPIManager.h
//  Flixter
//
//  Created by Marthan Nodado on 6/20/22.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MovieAPIManager : NSObject

- (void)fetchMovies:(void(^)(NSArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
