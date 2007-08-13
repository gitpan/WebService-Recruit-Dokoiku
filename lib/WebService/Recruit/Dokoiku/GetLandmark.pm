package WebService::Recruit::Dokoiku::GetLandmark;
use strict;
use vars qw( $VERSION );
use base qw( WebService::Recruit::Dokoiku::API );
$VERSION = '0.07';

sub url { 'http://api.doko.jp/v1/getLandmark.do'; }
sub force_array { [qw( landmark )]; }
sub elem_class { 'WebService::Recruit::Dokoiku::GetLandmark::Element'; }
sub query_class { 'WebService::Recruit::Dokoiku::GetLandmark::Query'; }

package WebService::Recruit::Dokoiku::GetLandmark::Query;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw(
    key format callback pagenum pagesize name code lat_jgd lat_jgd radius iarea
));

package WebService::Recruit::Dokoiku::GetLandmark::Element;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( results ));

package WebService::Recruit::Dokoiku::GetLandmark::Element::results;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( status totalcount pagenum landmark ));

package WebService::Recruit::Dokoiku::GetLandmark::Element::landmark;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( code name dokopcurl dokomburl dokomapurl ));

=head1 NAME

WebService::Recruit::Dokoiku::GetLandmark - Dokoiku Web Service "getLandmark" API

=head1 SYNOPSIS

    use WebService::Recruit::Dokoiku;

    my $doko = WebService::Recruit::Dokoiku->new();
    $doko->key( 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );

    my $param = {
        name    =>  'SHIBUYA109',
    };
    my $res = $doko->getLandmark( %$param );
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
