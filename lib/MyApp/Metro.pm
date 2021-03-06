package MyApp::Metro;

use strict;
use warnings;
use Mouse;
use URI;
use LWP::UserAgent;
use JSON;
use Data::Dumper;
use Encode;

use constant END_POINT => 'https://api.tokyometroapp.jp/api/v2/';

has 'api_key' => (is => 'rw',isa => 'Str',required => 1);

sub datapoints{
 my $self = shift;
 my $uri = END_POINT.'datapoints';
 my $url = URI->new($uri);
 my $param = {
  "acl:consumerKey" => $self->api_key,
  "rdf:type" => "odpt:Railway",
 };
 $url->query_form(%$param);
 $url =~ s/%3A/:/g;
 my $ua = LWP::UserAgent->new;
 my $res = $ua->get($url);
 my $json = JSON::decode_json($res->decoded_content);
 return $json;
}

sub line{
  my $self = shift;
  my $metro_line = [];
  for my $metro(@{$self->datapoints}){
    my $stations = [];
    $metro->{'owl:sameAs'} =~ s/odpt:Railway://;
    for my $station(@{$metro->{'odpt:stationOrder'}}){
      push @$stations,$station->{'odpt:station'};
    }
  push @$metro_line,{$metro->{'owl:sameAs'} => $stations};
  }
  return $metro_line;
}

sub station{
 my $self = shift;
 my $station_json = '[{"AoyamaItchome":"青山一丁目","Akasaka":"赤坂","AkasakaMitsuke":"赤坂見附","AkabaneIwabuchi":"赤羽岩淵","Akihabara":"秋葉原","Asakusa":"浅草","AzabuJuban":"麻布十番","Ayase":"綾瀬","Awajicho":"淡路町","Iidabashi":"飯田橋","Ikebukuro":"池袋","Ichigaya":"市ケ谷","Inaricho":"稲荷町","Iriya":"入谷","Ueno":"上野","UenoHirokoji":"上野広小路","Urayasu":"浦安","Edogawabashi":"江戸川橋","Ebisu":"恵比寿","Oji":"王子","OjiKamiya":"王子神谷","Otemachi":"大手町","Ogikubo":"荻窪","Oshiage":"押上<スカイツリー前>","Ochiai":"落合","Ochanomizu":"御茶ノ水","OmoteSando":"表参道","Gaiemmae":"外苑前","Kagurazaka":"神楽坂","Kasai":"葛西","Kasumigaseki":"霞ケ関","Kanamecho":"要町","Kamiyacho":"神谷町","Kayabacho":"茅場町","Kanda":"神田","KitaAyase":"北綾瀬","KitaSando":"北参道","KitaSenju":"北千住","Kiba":"木場","Gyotoku":"行徳","Kyobashi":"京橋","KiyosumiShirakawa":"清澄白河","Ginza":"銀座","GinzaItchome":"銀座一丁目","Kinshicho":"錦糸町","Kudanshita":"九段下","Kojimachi":"麴町","Korakuen":"後楽園","Gokokuji":"護国寺","KotakeMukaihara":"小竹向原","KokkaiGijidomae":"国会議事堂前","Kodemmacho":"小伝馬町","Komagome":"駒込","Sakuradamon":"桜田門","Shibuya":"渋谷","Shimo":"志茂","Shirokanedai":"白金台","ShirokaneTakanawa":"白金高輪","ShinOtsuka":"新大塚","ShinOchanomizu":"新御茶ノ水","ShinKiba":"新木場","ShinKoenji":"新高円寺","Shinjuku":"新宿","ShinjukuGyoemmae":"新宿御苑前","ShinjukuSanchome":"新宿三丁目","Shintomicho":"新富町","ShinNakano":"新中野","Shimbashi":"新橋","Jimbocho":"神保町","Suitengumae":"水天宮前","Suehirocho":"末広町","Sumiyoshi":"住吉","Senkawa":"千川","Sendagi":"千駄木","Zoshigaya":"雑司が谷","Takadanobaba":"高田馬場","Takebashi":"竹橋","Tatsumi":"辰巳","TameikeSanno":"溜池山王","Tawaramachi":"田原町","ChikatetsuAkatsuka":"地下鉄赤塚","ChikatetsuNarimasu":"地下鉄成増","Tsukiji":"築地","Tsukishima":"月島","Tokyo":"東京","Todaimae":"東大前","Toyocho":"東陽町","Toyosu":"豊洲","Toranomon":"虎ノ門","NakaOkachimachi":"仲御徒町","Nagatacho":"永田町","Nakano":"中野","NakanoSakaue":"中野坂上","NakanoShimbashi":"中野新橋","NakanoFujimicho":"中野富士見町","NakaMeguro":"中目黒","NishiKasai":"西葛西","Nishigahara":"西ケ原","NishiShinjuku":"西新宿","NishiNippori":"西日暮里","NishiFunabashi":"西船橋","NishiWaseda":"西早稲田","Nijubashimae":"二重橋前","Nihombashi":"日本橋","Ningyocho":"人形町","Nezu":"根津","Nogizaka":"乃木坂","Hatchobori":"八丁堀","BarakiNakayama":"原木中山","Hanzomon":"半蔵門","HigashiIkebukuro":"東池袋","HigashiGinza":"東銀座","HigashiKoenji":"東高円寺","HigashiShinjuku":"東新宿","Hikawadai":"氷川台","Hibiya":"日比谷","HiroO":"広尾","Heiwadai":"平和台","Honancho":"方南町","HongoSanchome":"本郷三丁目","HonKomagome":"本駒込","Machiya":"町屋","Mitsukoshimae":"三越前","MinamiAsagaya":"南阿佐ケ谷","MinamiGyotoku":"南行徳","MinamiSunamachi":"南砂町","MinamiSenju":"南千住","Minowa":"三ノ輪","Myogadani":"茗荷谷","Myoden":"妙典","MeijiJingumae":"明治神宮前<原宿>","Meguro":"目黒","MonzenNakacho":"門前仲町","Yurakucho":"有楽町","Yushima":"湯島","Yotsuya":"四ツ谷","YotsuyaSanchome":"四谷三丁目","YoyogiUehara":"代々木上原","YoyogiKoen":"代々木公園","Roppongi":"六本木","RoppongiItchome":"六本木一丁目","Wakoshi":"和光市","Waseda":"早稲田"}]';
 my $data = JSON::decode_json($station_json);
 return $data;
}

use utf8;
my $line_name_eng_2_jap_map = {
  'TokyoMetro.Marunouchi' => Encode::encode_utf8('丸の内線'),
  'TokyoMetro.MarunouchiBranch' => Encode::encode_utf8('分岐'),
  'TokyoMetro.Hibiya' => Encode::encode_utf8('日比谷線'),
  'TokyoMetro.Ginza' => Encode::encode_utf8('銀座線'),
  'TokyoMetro.Tozai' => Encode::encode_utf8('東西線'),
  'TokyoMetro.Chiyoda' => Encode::encode_utf8('千代田線'),
  'TokyoMetro.Yurakucho' => Encode::encode_utf8('有楽町線'),
  'TokyoMetro.Hanzomon' => Encode::encode_utf8('半蔵門線'),
  'TokyoMetro.Namboku' => Encode::encode_utf8('南北線'),
  'TokyoMetro.Fukutoshin' => Encode::encode_utf8('副都心'),
};


sub line_station_jap{
  my $self = shift;
  my $line = $self->line;
  my $line_info = [];
  for my $info(@$line){
    my $station = {};
    for my $key(keys %$info){
       if($key =~ m/odpt.Railway:((?:\w+).(?:\w+))/){
          $station->{linename} = $line_name_eng_2_jap_map->{$1};
       }
       my $station_list = [];
       for my $eng_station(@{$info->{$key}}){
          my $station_jap = {};
          $eng_station =~ s/odpt.Station:(TokyoMetro.(?:\w+).(\w+))//;
          my $jap = $self->station->[0]->{$2};
          $station_jap->{jap} = $jap;
          $station_jap->{eng} = $1;
          push @$station_list,$station_jap;
       }
       $station->{station} = $station_list;
    }
    push @$line_info,$station;
  }
  return $line_info;
}

no utf8;

sub line_japanese{
 my $self = shift;
 my $line = $self->line;
 my $lines = [];
 my $station = $self->station;
 for my $metro(@{$line}){
  for my $key (%$metro){
   next if (not defined $metro->{$key});
   my $hash = {};
   my $japanese_line = [];
   for my $metro_line(@{$metro->{$key}}){
     $metro_line =~ s/odpt.Station://;
     $metro_line =~ s/(\w+).(\w+).(\w+)/$3/;
     my $line_hash = {};
     $line_hash->{line} = $metro_line;
     $line_hash->{japanese} = $station->[0]->{$metro_line};
     push @$japanese_line,$line_hash;
  }
  $key =~ s/odpt.Railway://;
  $hash->{linename} = $key;
  $hash->{line} = $japanese_line;
  push @$lines,$hash;
 }
}
  return $lines;
}

use utf8;
my $line_name_map = {
 '丸の内線' => 'TokyoMetro.Marunouchi',
 '日比谷線' => 'TokyoMetro.Hibiya',
 '銀座線' => 'TokyoMetro.Ginza',
 '東西線' => 'TokyoMetro.Tozai',
 '千代田線' => 'TokyoMetro.Chiyoda',
 '有楽町線' => 'TokyoMetro.Yurakucho',
 '半蔵門線' => 'TokyoMetro.Hanzomon',
 '南北線' => 'TokyoMetro.Namboku',
 '副都心線' => 'TokyoMetro.Fukutoshin'
};

sub get_line_list{
 my $self = shift;
 my $line = {};
 for my $key(keys %$line_name_map){
   $line->{$key} = $line_name_map->{$key};
 }
 return $line;
}

sub get_connectinfo_by_line_station{
 my ($self,$line,$station) = @_;
 my $param = {
  "rdf:type" => "odpt:Station",
  "dc:title" => "$station",
  "odpt:railway" => "odpt.Railway:"."$line",
  "acl:consumerKey" => $self->api_key,
 };
 my $url = END_POINT."datapoints";
 my $railway = URI->new($url);
 $railway->query_form(%$param);
 $railway =~ s/%3A/:/g;
 my $ua = LWP::UserAgent->new;
 my $res = $ua->get($railway);
 my $json = JSON::decode_json($res->decoded_content);
 return $json->[0]->{'odpt:connectingRailway'};
}

sub get_trainInformationText_by_linename{
  my ($self,$linename) = @_; 
  my $param = {
    "rdf:type" => "odpt:TrainInformation",
    "odpt:railway" => "odpt.Railway:"."$linename",
    "acl:consumerKey" => $self->api_key,
 };
 my $url = END_POINT."datapoints";
 my $railway = URI->new($url);
 $railway->query_form(%$param);
 $railway =~ s/%3A/:/g;
 my $ua = LWP::UserAgent->new;
 my $res = $ua->get($railway);
 my $json = JSON::decode_json($res->decoded_content);
 return $json->[0]->{'odpt:trainInformationText'};
}

sub station_englishname_2_japname{
  my($self,$eng) = @_;
  return $self->station->[0]->{$eng};
};

sub station_japname_2_englishname{
  my($self,$jap) = @_;
  $jap = Encode::decode_utf8($jap);
  my $station_map = $self->station->[0];
  for my $key(keys %$station_map){
    return $key if $station_map->{$key} eq $jap;
  }
};

no utf8;

sub get_fare_by_from_to{
 my $self = shift;
 my($from,$to) = @_;
 my $line = $self->line_japanese;
 my $railfare = END_POINT."datapoints";
 my $railurl = URI->new($railfare);
 my $param = {
  "rdf:type" => "odpt:RailwayFare",
  "odpt:fromStation" => "odpt.Station:"."$from",
  "odpt:toStation" => "odpt.Station:"."$to",
  "acl:consumerKey" => $self->api_key,
 };
 $railurl->query_form(%$param);
 $railurl =~ s/%3A/:/g;
 my $ua = LWP::UserAgent->new;
 my $res = $ua->get($railurl); 
 my $json = JSON::decode_json($res->decoded_content);
 return $json->[0]->{'odpt:ticketFare'};
}

sub get_facility_by_to{
  my $self = shift;
  my $to = shift;
  $to = Encode::decode_utf8($to);
  my $line = $self->line_japanese;
  my $station = $self->station;
  my $station_list = $station->[0];
  my $ret;
  for my $station(keys %$station_list){
    $ret = $station if $station_list->{$station} eq $line;
  }
  my $railfare = END_POINT."datapoints";
  my $railurl = URI->new($railfare);
  my $param = {
    "rdf:type" => "odpt:StationFacility",
    "owl:sameAs" => "odpt.StationFacility:"."$ret",
    "acl:consumerKey" => $self->api_key,
  };
  $railurl->query_form(%$param);
  $railurl =~ s/%3A/:/g;
  my $ua = LWP::UserAgent->new;
  my $res = $ua->get($railurl);
  my $json = JSON::decode_json($res->decoded_content);
  return $json->[0]->{"odpt:barrierfreeFacility"};
}

sub get_women_info_by_linetitle{
  my($self,$line_title) = @_;
  $line_title = Encode::decode_utf8($line_title);
  my $railurl = END_POINT."datapoints";
  my $rail = URI->new($railurl);
  my $param = {
   "rdf:type" => "odpt:Railway",
   "dc:title" => $line_title,
   "acl:consumerKey" => $self->api_key,
  };
  $rail->query_form(%$param);
  $rail =~ s/%3A/:/g;
  my $ua = LWP::UserAgent->new;
  my $res = $ua->get($rail);
  my $json = JSON::decode_json($res->decoded_content);
  return $json->[0]->{'odpt:womenOnlyCar'}->[0];
};

1;


