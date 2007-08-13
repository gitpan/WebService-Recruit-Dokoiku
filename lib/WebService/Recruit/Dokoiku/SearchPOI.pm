package WebService::Recruit::Dokoiku::SearchPOI;
use strict;
use vars qw( $VERSION );
use base qw( WebService::Recruit::Dokoiku::API );
$VERSION = '0.07';

sub url { 'http://api.doko.jp/v1/searchPOI.do'; }
sub force_array { [qw( poi )]; }
sub elem_class { 'WebService::Recruit::Dokoiku::SearchPOI::Element'; }
sub query_class { 'WebService::Recruit::Dokoiku::SearchPOI::Query'; }

package WebService::Recruit::Dokoiku::SearchPOI::Query;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw(
    key format callback pagenum pagesize keyword name tel
    lat_jgd lon_jgd radius lmcode iarea order
));

package WebService::Recruit::Dokoiku::SearchPOI::Element;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( results ));

package WebService::Recruit::Dokoiku::SearchPOI::Element::results;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( status totalcount pagenum poi ));

package WebService::Recruit::Dokoiku::SearchPOI::Element::poi;
use strict;
use base qw( Class::Accessor::Fast );
__PACKAGE__->mk_accessors(qw( code name kana tel address stationcode
    station distance dokopcurl dokomburl dokomapurl reviewrank tag ));

=head1 NAME

WebService::Recruit::Dokoiku::SearchPOI - Dokoiku Web Service "searchPOI" API

=head1 SYNOPSIS

    use WebService::Recruit::Dokoiku;

    my $doko = WebService::Recruit::Dokoiku->new();
    $doko->key( 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' );

    my $param = {
        lat_jgd =>  '35.6686',
        lon_jgd =>  '139.7593',
        name    =>  'ATM',
    };
    my $res = $doko->searchPOI( %$param );
    die "error!" if $res->is_error;

    my $list = $res->root->poi;
    foreach my $poi ( @$list ) {
        print "name: ", $poi->name, "\n";
        print "addr: ", $poi->address, "\n";
        print "web:  ", $poi->dokopcurl, "\n";
        print "map:  ", $poi->dokomapurl, "\n";
        print "\n";
    }

    my $root = $res->root;

=head1 DESCRIPTION

The request to this API requires one or some of query parameters below:

    my $param = {
        pagenum     =>  '1',
        pagesize    =>  '10',
        keyword     =>  'keyword for place',
        name        =>  'name of place',
        tel         =>  '03-3575-1111',
        lat_jgd     =>  '35.6686',
        lon_jgd     =>  '139.7593',
        radius      =>  '1000',
        lmcode      =>  '1908',
        iarea       =>  '05800',
        order       =>  '1',
    };

The response from this API is tree structured and provides methods below:

    $root->status
    $root->totalcount
    $root->pagenum
    $root->poi->[0]->code
    $root->poi->[0]->name
    $root->poi->[0]->kana
    $root->poi->[0]->tel
    $root->poi->[0]->address
    $root->poi->[0]->stationcode
    $root->poi->[0]->station
    $root->poi->[0]->distance
    $root->poi->[0]->dokopcurl
    $root->poi->[0]->dokomburl
    $root->poi->[0]->dokomapurl
    $root->poi->[0]->reviewrank
    $root->poi->[0]->tag

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
