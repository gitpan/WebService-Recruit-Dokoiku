package WebService::Recruit::Dokoiku::GetStation;
use strict;
use vars qw( $VERSION );
use base qw( WebService::Recruit::Dokoiku::API );
$VERSION = '0.07';

sub url { 'http://api.doko.jp/v1/getStation.do'; }
sub force_array { [qw( landmark )]; }
sub elem_class { 'WebService::Recruit::Dokoiku::GetStation::Element'; }
sub query_class { 'WebService::Recruit::Dokoiku::GetStation::Query'; }

package WebService::Recruit::Dokoiku::GetStation::Query;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw(
    key format callback pagenum pagesize name code lat_jgd lat_jgd radius iarea
));

package WebService::Recruit::Dokoiku::GetStation::Element;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( results ));

package WebService::Recruit::Dokoiku::GetStation::Element::results;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( status totalcount pagenum landmark ));

package WebService::Recruit::Dokoiku::GetStation::Element::landmark;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw(
    code name dokopcurl dokomburl dokomapurl lat_jgd lon_jgd lat_tky lon_tky
));

=head1 NAME

WebService::Recruit::Dokoiku::GetStation - Dokoiku Web Service "getStation" API

=head1 SYNOPSIS

    use WebService::Recruit::Dokoiku;

    my $doko = WebService::Recruit::Dokoiku->new();
    $doko->key( 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );

    my $param = {
        lon_jgd     =>  139.758,
        lat_jgd     =>   35.666,
    };
    my $res = $doko->getStation( %$param );
    die "error!" if $res->is_error;

    my $list = $res->root->landmark;
    foreach my $landmark ( @$list ) {
        print "code: ", $landmark->code, "\n";
        print "name: ", $landmark->name, "\n";
        print "web:  ", $landmark->dokopcurl, "\n";
        print "map:  ", $landmark->dokomapurl, "\n";
        print "\n";
    }

    my $root = $res->root;

=head1 DESCRIPTION

The request to this API requires one or some of query parameters below:

    my $param = {
        pagenum     =>  '1',
        pagesize    =>  '10',
        name        =>  'name of station',
        code        =>  '4254',
        lat_jgd     =>  '35.6686',
        lon_jgd     =>  '139.7593',
        radius      =>  '1000',
        iarea       =>  '05800',
    };

The response from this API is tree structured and provides methods below:

    $root->status
    $root->totalcount
    $root->pagenum
    $root->landmark->[0]->code
    $root->landmark->[0]->name
    $root->landmark->[0]->dokopcurl
    $root->landmark->[0]->dokomburl
    $root->landmark->[0]->dokomapurl
    $root->landmark->[0]->lat_jgd
    $root->landmark->[0]->lon_jgd
    $root->landmark->[0]->lat_tky
    $root->landmark->[0]->lon_tky

And paging methods are provided, see L<WebService::Recruit::Dokoiku/PAGING>.
This module is based on L<XML::OverHTTP>.

=head1 SEE ALSO

L<WebService::Recruit::Dokoiku>

=head1 AUTHOR

Yusuke Kawasaki L<http://www.kawa.net/>

This module is unofficial and released by the authour in person.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2007 Yusuke Kawasaki. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
1;
