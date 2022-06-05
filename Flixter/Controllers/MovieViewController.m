//
//  MovieViewController.m
//  Flixter
//
//  Created by Marty Nodado on 5/16/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@interface MovieViewController ()
@property (strong, nonatomic) NSArray *movies;
@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.activityIndicator startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=35a7cf82e598703e220a9b9924350685"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
               
               // Creating the Alert Controller and actions
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This is a title" message:@"This is a subtitle" preferredStyle:(UIAlertControllerStyleAlert)];
               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                   // dismisses the view
               }];
               UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   // handles response here
               }];
               
               // Adding actions to alert controller
               [alert addAction:cancelAction];
               [alert addAction:okAction];
               
               [self presentViewController:alert animated:YES completion:^{
                   // code 
               }];
           }
           else {
                // TODO: Get the array of movies
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

               // TODO: Store the movies in a property to use elsewhere
               self.movies = dataDictionary[@"results"];
//               NSLog(@"Results: %@", self.movies);
               // TODO: Reload your table view data
               [self.tableView reloadData];
           }
       }];
    [task resume];
    
    [self.activityIndicator stopAnimating];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.view.backgroundColor = UIColorFromRGB(0x121212);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x181818);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.backgroundColor = UIColorFromRGB(0x181818);
    self.tabBarController.tabBar.barTintColor = UIColorFromRGB(0x121212);
    self.tabBarController.tabBar.tintColor = UIColor.whiteColor;
//    self.tabBarController.moreNavigationController.navigationBar.tintColor =
//    navigationController.navigationBar.tintColor = [UIColor blackColor];



    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];

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
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    
    NSString *movieTitle = movie[@"title"];
    NSString *movieSynopsis = movie[@"overview"];
    
    NSString *baseUrl = @"https://image.tmdb.org/t/p/w185";
    NSString *posterPath = movie[@"poster_path"];
    NSString *posterUrlString = [NSString stringWithFormat: @"%@%@", baseUrl, posterPath];
    NSURL *posterUrl = [NSURL URLWithString:posterUrlString];
    
    cell.titleLabel.text = movieTitle;
    cell.synopsisLabel.text = movieSynopsis;
    [cell.posterImage setImageWithURL: posterUrl];
    
    cell.titleLabel.textColor = UIColor.whiteColor;
    cell.synopsisLabel.textColor = UIColor.whiteColor;

    
    return cell;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        // Create NSURL and NSURLRequest
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=35a7cf82e598703e220a9b9924350685"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
           // ... Use the new data to update the data source ...

           // Reload the tableView now that there is new data
            [self.tableView reloadData];

           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];

        }];
    
        [task resume];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
