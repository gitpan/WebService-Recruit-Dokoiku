# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 2;
# ----------------------------------------------------------------
{
    use_ok('WebService::Recruit::Dokoiku');
    my $api = WebService::Recruit::Dokoiku->new();
    ok( ref $api, 'WebService::Recruit::Dokoiku->new()' );
}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
