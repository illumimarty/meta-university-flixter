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
               
//               // Creating the Alert Controller and actions
//               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No network connection" message:@"You are not connected to the internet" preferredStyle:(UIAlertControllerStyleAlert)];
//
//               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                   // handles response here
//               }];
//
//               // Adding actions to alert controller
//               [alert addAction:okAction];
//
//               [self presentViewController:alert animated:YES completion:^{
//                   // code
//               }];
           }
           else {
                // TODO: Get the array of movies
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // TODO: Store the movies in a property to use elsewhere

               
               // Initialize space for movies array
               
               NSArray *dictionaries = dataDictionary[@"results"];
               NSArray *movies = [Movie moviesWithDictionaries:dictionaries];
               
//               if (!self.movies) {
//                   self.movies = [[NSMutableArray alloc] init];
//               }
               
//               for (NSDictionary *movie in dataDictionary[@"results"]) {
//                   Movie *newMovie = [[Movie alloc] initWithDictionary:movie];
//                   [self.movies addObject:newMovie];
//               }
               
//               self.filteredMovies = self.movies;

               // TODO: Reload your table view data
//               [self.tableView reloadData];
               
               completion(movies, nil);
           }
       }];
    [task resume];
}


@end
