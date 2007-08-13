package WebService::Recruit::Dokoiku;
use strict;
use Class::Accessor::Fast;
use XML::OverHTTP;
use base qw( Class::Accessor::Fast );
use vars qw( $VERSION );
$VERSION = '0.07';

my $PARAMS = [qw( key pagesize )];
my $TPPCFG = [qw( user_agent lwp_useragent http_lite utf8_flag )];
__PACKAGE__->mk_accessors( @$PARAMS, @$TPPCFG );

sub new {
    my $package = shift;
    my $self    = {@_};
    $self->{user_agent} ||= __PACKAGE__."/$VERSION ";
    bless $self, $package;
    $self;
}

sub init_treepp_config {
    my $self = shift;
    my $api  = shift;
    my $treepp = $api->treepp();
    foreach my $key ( @$TPPCFG ) {
        next unless exists $self->{$key};
        next unless defined $self->{$key};
        $treepp->set( $key => $self->{$key} );
    }
}

sub init_query_param {
    my $self = shift;
    my $api  = shift;
    foreach my $key ( @$PARAMS ) {
        next unless exists $self->{$key};
        next unless defined $self->{$key};
        $api->add_param( $key => $self->{$key} );
    }
}

package WebService::Recruit::Dokoiku::API;
use strict;
use base qw( XML::OverHTTP );
use vars qw( $VERSION );
$VERSION = $WebService::Recruit::Dokoiku::VERSION;

sub default_param { { format => 'xml' }; }
sub notnull_param { [qw( key )]; }
sub attr_prefix { ''; }
sub root_elem { 'results'; }

sub is_error {
    my $self = shift;
    my $root = $self->root();
    $root->status();                # 0 means ok
}
sub total_entries {
    my $self = shift;
    my $root = $self->root() or return;
    $root->{totalcount} || 0;
}
sub entries_per_page {
    my $self = shift;
    my $root = $self->root() or return;
    $root->{pagesize} || 10;
}
sub current_page {
    my $self = shift;
    my $root = $self->root() or return;
    $root->{pagenum} || 1;
}
sub page_param {
    my $self = shift;
    my $page = shift || $self->current_page();
    my $size = shift || $self->entries_per_page();
    my $hash = shift || {};
    $hash->{pagenum}  = $page if defined $page;
    $hash->{pagesize} = $size if defined $size;
    $hash;
}

package WebService::Recruit::Dokoiku;           # again
use strict;

use WebService::Recruit::Dokoiku::SearchPOI;
use WebService::Recruit::Dokoiku::GetLandmark;
use WebService::Recruit::Dokoiku::GetStation;

sub searchPOI {
    my $self = shift or return;
    $self = $self->new() unless ref $self;
    my $api = WebService::Recruit::Dokoiku::SearchPOI->new();
    $self->init_treepp_config( $api );
    $self->init_query_param( $api );
    $api->add_param( @_ );
    $api->request();
    $api;
}

sub getLandmark {
    my $self = shift or return;
    $self = $self->new() unless ref $self;
    my $api = WebService::Recruit::Dokoiku::GetLandmark->new();
    $self->init_treepp_config( $api );
    $self->init_query_param( $api );
    $api->add_param( @_ );
    $api->request();
    $api;
}

sub getStation {
    my $self = shift or return;
    $self = $self->new() unless ref $self;
    my $api = WebService::Recruit::Dokoiku::GetStation->new();
    $self->init_treepp_config( $api );
    $self->init_query_param( $api );
    $api->add_param( @_ );
    $api->request();
    $api;
}

=head1 NAME

WebService::Recruit::Dokoiku - A Interface for Dokoiku Web Service Beta

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
    my $list = $res->root->poi;
    foreach my $poi ( @$list ) {
        print "name: ", $poi->name, "\n";
        print "addr: ", $poi->address, "\n";
        print "web:  ", $poi->dokopcurl, "\n";
        print "map:  ", $poi->dokomapurl, "\n";
        print "\n";
    }

=head1 DESCRIPTION

This module is a interface for the Dokoiku Web Service I<Beta>,
provided by Recruit Co., Ltd., Japan.
It provides three API methods: L</searchPOI>, L</getLandmark>
and L</getStation>.
With these methods, you can find almost all of shops, restaurants
and many other places in Japan.

=head3 searchPOI

See L<WebService::Recruit::Dokoiku::SearchPOI> for details.

    my $res = $doko->searchPOI( lmcode => 4212, name => 'ATM' );

=head3 getLandmark

See L<WebService::Recruit::Dokoiku::GetLandmark> for details.

    my $res = $doko->getLandmark( name => 'SHIBUYA 109' );

=head3 getStation

See L<WebService::Recruit::Dokoiku::GetStation> for details.

    my $res = $doko->getStation( lon_jgd => 139.758, lat_jgd => 35.666 );

=head2 PAGING

Each API response also provides paging methods following:

=head3 page

C<page> method returns a L<Data::Page> instance.

    my $page = $res->page();
    print "Total: ", $page->total_entries, "\n";
    print "Page: ", $page->current_page, "\n";
    print "Last: ", $page->last_page, "\n";

=head3 pageset

C<pageset> method returns a L<Data::Pageset> instance

    my $pageset = $res->pageset( 'fixed' );
    $pageset->pages_per_set($pages_per_set);
    my $set = $pageset->pages_in_set();
    foreach my $num ( @$set ) {
        print "$num ";
    }

=head3 page_param

C<page_param> method returns a hash to specify the page for the next request.

    my %hash  = $res->page_param( $page->next_page );

=head3 page_query

C<page_query> method returns a query string to specify the page for the next request.

    my $query = $res->page_query( $page->prev_page );

=head2 TreePP CONFIG

This modules uses L<XML::TreePP> module internally.
Following methods are available to configure it.

    my $doko = WebService::Recruit::Dokoiku->new();
    $doko->utf8_flag( 1 );
    $doko->user_agent( 'Foo-Bar/1.0 ' );
    $doko->lwp_useragent( LWP::UserAgent->new() );
    $doko->http_lite( HTTP::Lite->new() );

=head1 SEE ALSO

http://www.doko.jp/api/

=head1 AUTHOR

Yusuke Kawasaki L<http://www.kawa.net/>

This module is unofficial and released by the authour in person.

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2007 Yusuke Kawasaki. All rights reserved.
This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
1;
