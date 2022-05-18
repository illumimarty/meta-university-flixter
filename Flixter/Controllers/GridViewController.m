//
//  GridViewController.m
//  Flixter
//
//  Created by Marty Nodado on 5/18/22.
//

#import "GridViewController.h"
#import "PosterCell.h"
#import "UIImageView+AFNetworking.h"

@interface GridViewController ()
@property (strong, nonatomic) NSArray *movies;
@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Network Request;
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
               self.movies = dataDictionary[@"results"];
               NSLog(@"Results: %@", self.movies);
               // TODO: Reload your table view data
               
               [self.collectionView reloadData];
           }
       }];
    [task resume];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PosterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PosterCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w185";
    NSString *posterPath = movie[@"poster_path"];
    NSString *posterUrlString = [NSString stringWithFormat: @"%@%@", baseUrl, posterPath];
    NSURL *posterUrl = [NSURL URLWithString:posterUrlString];
    
    [cell.posterImageView setImageWithURL: posterUrl];
    
    return cell;
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
