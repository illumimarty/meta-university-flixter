//
//  MovieAPIManager.m
//  Flixter
//
//  Created by Marthan Nodado on 6/20/22.
//

#import "MovieAPIManager.h"
#import "Movie.h"

@interface MovieAPIManager ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation MovieAPIManager

- (id)init {
    self = [super init];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    return self;
    
}

- (void)fetchMovies:(void (^)(NSArray *movies, NSError *error))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=35a7cf82e598703e220a9b9924350685"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
             
           }
           else {
                // TODO: Get the array of movies
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // TODO: Store the movies in a property to use elsewhere
               // Initialize space for movies array
               
               NSArray *dictionaries = dataDictionary[@"results"];
               NSArray *movies = [Movie moviesWithDictionaries:dictionaries];
               
               completion(movies, nil);
           }
       }];
    [task resume];
}


@end
