package MyApp::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use MyApp::Metro;
use Data::Dumper;

my $metro = MyApp::Metro->new(api_key => 'e4346dc05e12b8e457bdfe693a858f83aa7a31ebed6af708f410543c4e5e5c4b');

any '/' => sub {
    my ($c) = @_;
    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);
    return $c->render('index.tx', {
        counter => $counter,
    });
};

get '/traininfo/:linename' => sub{
 my ($c,$args) = @_;
 my $text = $metro->get_trainInformationText_by_linename($args->{linename});
 return $c->render('traininfo.tx',{ infotext => $text});
};

get 'fare' => sub{
 my ($c,$args) = @_;
 my $line_info = $metro->line_station_jap;
 return $c->render('fare.tx',{'lineinfo' => $line_info});
};

get '/js/fare' => sub{
 my($c,$args) = @_;
 my $from =  $c->req->param('from');
 my $to   = $c->req->param('to');
 my $fare = $metro->get_fare_by_from_to($from,$to);
 my $fare_structure = {'fare' => $fare."円"};
 return $c->render_json($fare_structure);
};

get '/connect' => sub{
 my($c,$args) = @_;
 my $line =  $metro->get_line_list;
 print Dumper $line;
 return $c->render('connect.tx',{line => $line});
};

get '/js/connect' => sub{
 my($c,$args) = @_;
 my $line =  $c->req->param('linename');
 my $station = $c->req->param('station');
 my $connectingStation = $metro->get_connectinfo_by_line_station($line,$station);
 return $c->render_json({connect => $connectingStation});
};

post '/reset_counter' => sub {
    my $c = shift;
    $c->session->remove('counter');
    return $c->redirect('/');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
