//
//  MovieViewController.m
//  Flixter
//
//  Created by Marty Nodado on 5/16/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"

@interface MovieViewController ()
@property (strong, nonatomic) NSArray *movies;
@end

@implementation MovieViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
               
               [self.tableView reloadData];
           }
       }];
    [task resume];
    
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 173;
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
//    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    
    NSString *movieTitle = movie[@"title"];
    NSString *movieSynopsis = movie[@"overview"];
        
    cell.titleLabel.text = movieTitle;
    cell.synopsisLabel.text = movieSynopsis;
    
    
    return cell;
}

@end
