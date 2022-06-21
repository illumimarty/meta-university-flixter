//
//  Movie.m
//  Flixter
//
//  Created by Marthan Nodado on 6/20/22.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    self.posterPath = dictionary[@"poster_path"];
    
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w185";
    NSString *posterUrlString = [NSString stringWithFormat: @"%@%@", baseUrl, self.posterPath];
    self.posterUrl = [NSURL URLWithString:posterUrlString];
    
    return self;
}

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    
    // 1. Initialize an empty output array
    NSMutableArray *movies = [NSMutableArray array];
    
    // 2. Parse through the different dictionaries
    for (NSDictionary *dictionary in dictionaries) {
        
        // 3. Create a Movie object from dictionary
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        
        // 4. Append new movie obj to output array
        [movies addObject: movie];
    }
    
    return movies;
    
}


@end
