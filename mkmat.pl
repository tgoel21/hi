#! /usr/bin/perl

# I started to write the mat.h and related files in pure C, and it was
# OK at the beginning with some makro majik.  But I added more and
# more convenience types, which became less easy to handle, and also
# error message from the compiler were more and more unhelpful with
# all the references to macros hiding the actual problem.
#
# So this Perl script is supposed to do the trivial work of generating
# all the stuff.  We'l start with the matrices (which are way more complex)
# and will go to the vectors later.

use strict;
use warnings;
use Data::Dumper;

my $P = 'cp_';
my $I = 'cpmat';
my $FF = '%7.4f';

my $Puc = uc($P);
my $Plc = lc($P);

my @type = (
    {
        name => 'vec2',
        kind => 'vec',
        dim  => 2,
    },
    {
        name => 'vec3',
        kind => 'vec',
        dim  => 3,
        vecs => 'vec2',
    },
    {
        name => 'vec4',
        kind => 'vec',
        dim  => 4,
        vecs => 'vec3',
    },
    {
        name => 'mat2',
        kind => 'mat',
        dim  => 2,
        dimx => 2,
        vecr => 'vec2',
        vec  => 'vec2',
        vecx => 'vec2',
    },
    {
        name => 'mat2w',
        kind => 'matw',
        dim  => 2,
        dimx => 2,
        dimt => 2,
        base => 'mat2',
        vecw => 'vec2',
        vec  => 'vec2',
        vecx => 'vec2',
        vect => 'vec2',
    },
    {
        name => 'mat2i',
        kind => 'mati',
        dim  => 2,
        dimx => 2,
        base => 'mat2',
        vec  => 'vec2',
        vecx => 'vec2',
    },
    {
        name => 'mat2wi',
        kind => 'mati',
        dim  => 2,
        dimx => 2,
        dimt => 2,
        base => 'mat2w',
        vec  => 'vec2',
        vecx => 'vec2',
        vect => 'vec2',
    },
    {
        name => 'mat3',
        kind => 'mat',
        dim  => 3,
        dimx => 3,
        dimt => 2,
        vecr => 'vec3',
        vec  => 'vec3',
        vecx => 'vec3',
        vect => 'vec2',
    },
    {
        name => 'mat3w',
        kind => 'matw',
        dim  => 3,
        dimx => 3,
        dimt => 3,
        base => 'mat3',
        vecw => 'vec3',
        vec  => 'vec3',
        vecx => 'vec3',
        vect => 'vec3',
    },
    {
        name => 'mat3i',
        kind => 'mati',
        dim  => 3,
        dimx => 3,
        dimt => 2,
        base => 'mat3',
        vec  => 'vec3',
        vecx => 'vec3',
        vect => 'vec2',
    },
    {
        name => 'mat3wi',
        kind => 'mati',
        dim  => 3,
        dimx => 3,
        dimt => 3,
        base => 'mat3w',
        vec  => 'vec3',
        vecx => 'vec3',
        vect => 'vec3',
    },
    {
        name => 'mat4',
        kind => 'mat',
        dim  => 4,
        dimx => 3,
        dimt => 3,
        vecr => 'vec4',
        vec  => 'vec4',
        vecx => 'vec3',
        vect => 'vec3',
    },
    {
        name => 'mat4i',
        kind => 'mati',
        dim  => 4,
        dimx => 3,
        dimt => 3,
        base => 'mat4',
        vec  => 'vec4',
        vecx => 'vec3',
        vect => 'vec3',
    },
);
my %type = map { $_->{name} => $_ } @type;
for my $t (@type) {
    if ($t->{base}) {
        $t->{base} = $type{$t->{base}} or die;
    }
    if ($t->{vecw}) {
        $t->{vecw} = $type{$t->{vecw}} or die;
    }
    if ($t->{vecs}) {
        $t->{vecs} = $type{$t->{vecs}} or die;
    }
    if ($t->{vecr}) {
        $t->{vecr} = $type{$t->{vecr}} or die;
    }
    if ($t->{vecx}) {
        $t->{vecx} = $type{$t->{vecx}} or die;
    }
    if ($t->{vect}) {
        $t->{vect} = $type{$t->{vect}} or die;
    }
    if ($t->{vec}) {
        $t->{vec} = $type{$t->{vec}} or die;
    }
}
my @coord = ('x', 'y', 'z', 'w');

my $vec2 = $type{vec2} or die;
my $vec3 = $type{vec3} or die;

sub publish($$$)
{
    my ($oc, $where, $text) = @_;
    push @{ $oc->{out}{$where} }, $text;
}

sub publish_extern($$$)
{
    my ($oc, $proto, $body)= @_;
    publish($oc, 'ext_h', "extern $proto;\n");
    if (defined $body) {
        publish($oc, 'ext_c', "extern $proto\n{\n$body}\n");
    }
}

sub publish_inline($$$)
{
    my ($oc, $proto, $body)= @_;
    publish($oc, 'inl_h', "static inline $proto\n{\n$body}\n");
}

sub coord($)
{
    my ($cnt) = @_;
    return (map { $coord[$_] } 0..$cnt-1);
}

#### TYPE ####

sub gen_vec_arr_types($$)
{
    my ($oc, $t) = @_;
    my $s = '';
    $s.= "typedef X_VEC_T(X_$t->{name}_t) X_v_$t->{name}_t;\n";
    $s.= "typedef X_ARR_T(X_$t->{name}_t) X_a_$t->{name}_t;\n";
    $s.= "typedef X_VEC_T(X_$t->{name}_t*) X_v_$t->{name}_p_t;\n";
    $s.= "typedef X_ARR_T(X_$t->{name}_t*) X_a_$t->{name}_p_t;\n";
    publish($oc, 'tam_h', $s);
}

sub gen_type_vec($$$)
{
    my ($oc, $t, $elem) = @_;

    # basic type:
    my $s = "typedef union {\n";
    $s.= "    X_dim_t v[$t->{dim}];\n";
    $s.= "    struct {\n";
    for my $c (coord($t->{dim})) {
        $s.= "        X_dim_t $c;\n";
    }
    $s.= "    };\n";
    if (my $ts = $t->{vecs}) {
        die unless $ts->{dim} == $t->{dim} - 1;
        $s.= "    struct {\n";
        $s.= "        X_$ts->{name}_t b;\n";
        if ($coord[$ts->{dim}] ne 'w') {
            $s.= "        X_dim_t w;\n";
        }
        $s.= "    };\n";
    }
    $s.= "} X_$t->{name}_t;\n";
    publish($oc, 'tam_h', $s);

    # minmax:
    $s = '';
    $s.= "typedef struct {\n";
    $s.= "    X_$t->{name}_t min,max;\n";
    $s.= "} X_$t->{name}_minmax_t;\n";
    publish($oc, 'tam_h', $s);

    # array types:
    gen_vec_arr_types($oc, $t);
}

sub gen_type_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $s = '';
    $s.= "typedef union {\n";
    $s.= "    X_dim_t v[$t->{dim} * $t->{dim}];\n";
    $s.= "    X_dim_t m[$t->{dim}][$t->{dim}];\n";
    $s.= "    X_$t->{vecr}{name}_t row[$t->{dim}];\n";
    $s.= "} X_$t->{name}_t;\n";
    publish($oc, 'tam_h', $s);
    gen_vec_arr_types($oc, $t);
}

sub gen_type_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    my $s = '';
    $s.= "typedef struct {\n";
    $s.= "    X_dim_t v[$t->{dim} * ($t->{dim} + 1)];\n";
    $s.= "    struct {\n";
    $s.= "       X_$t->{base}{name}_t b;\n";
    $s.= "       X_$t->{vecw}{name}_t w;\n";
    $s.= "    };\n";
    $s.= "} X_$t->{name}_t;\n";
    publish($oc, 'tam_h', $s);
    gen_vec_arr_types($oc, $t);
}

sub gen_type_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my $s = '';
    $s.= "typedef struct {\n";
    $s.= "    X_$t->{base}{name}_t n;\n";
    $s.= "    X_$t->{base}{name}_t i;\n";
    $s.= "    X_det_t d;\n";
    $s.= "} X_$t->{name}_t;\n";
    publish($oc, 'tam_h', $s);
    gen_vec_arr_types($oc, $t);
}

#### GENERIC STUFF ####

my %qual = (
    (map { $_ => '' } qw(r)),
    (map { $_ => 'const' } qw(a b c u v sc)),
);

sub arg_name(@)
{
    return @_[ map {2*$_ } 0..((($#_+1) / 2) - 1) ];
}

sub proto_arg($$)
{
    my ($type, $name) = @_;
    die unless $type;
    die unless $name;
    if (!ref($type)) {
        return "$type $name";
    }
    my $q = $qual{$name};
    die "Unrecognised param name: '$name'" unless defined $q;
    return "X_$type->{name}_t $q* $name";
}

sub proto($$$@)
{
    my ($t, $result, $elem, @arg) = @_;
    die unless $t;
    die unless $result;
    die unless $elem;
    die unless $t->{name};
    my $name = "X_$t->{name}";
    my @a = ();
    while (my ($name, $type) = splice @arg, 0, 2) {
        die unless $name;
        die unless $type;
        push @a, "\n    ".proto_arg($type, $name);
    }
    return "$result ${name}_${elem}(".join(",", @a).")";
}

sub xt(@)
{
    my $t = shift @_;
    return map { $_ => $t } @_;
}

#### LEX_CMP ####

sub gen_lex_cmp($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'int', $elem, a=>$t, b=>$t);
    my $s = "    return X_$elem(a->v, b->v, X_countof(a->v));\n";
    publish_inline($oc, $p, $s);
}

sub gen_lex_cmp_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'int', $elem, a=>$t, b=>$t);
    my $s = "    return X_$t->{base}{name}_$elem(&a->n, &b->n);\n";
    publish_inline($oc, $p, $s);
}

sub gen_lex_cmp_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'int', $elem, a=>$t, b=>$t);
    my $s = '';
    $s .= "    int i = X_$t->{base}{name}_$elem(&a->b, &b->b);\n";
    $s .= "    if (i != 0) { return i; }\n";
    $s .= "    return X_$t->{vecw}{name}_$elem(&a->w, &b->w);\n";
    publish_extern($oc, $p, $s);
}

#### EQU ####

sub gen_equ($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'bool', $elem, a=>$t, b=>$t);
    my $s = "    return X_$t->{name}_lex_cmp(a,b) == 0;\n";
    publish_inline($oc, $p, $s);
}

#### REV ####

sub gen_rev_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t);
    my $s = '';
    $s .= "    X_dim_t h;\n";
    for my $i (0..($t->{dim} >> 1)-1) {
        my $j = $t->{dim} - $i - 1;
        $s .= "    h = a->v[$i];\n";
        $s .= "    r->v[$i] = a->v[$j];\n";
        $s .= "    r->v[$j] = h;\n";
    }
    if ($t->{dim} & 1) {
        my $j = $t->{dim} >> 1;
        $s .= "    r->v[$j] = a->v[$j];\n";
    }
    publish_extern($oc, $p, $s);
}

#### UNIT ####

sub gen_unit_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $name = "X_$t->{name}";
    my $p = proto($t, 'bool', $elem, r=>$t, a=>$t);
    my $s = '';
    $s .= "    X_dim_t l = ${name}_len(a);\n";
    $s .= "    ${name}_div(r, a, l);\n";
    $s .= "    return !X_sqr_equ(l,0);\n";
    publish_extern($oc, $p, $s);
}

#### ADD ####

sub gen_add_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t);
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    r->v[$i] = a->v[$i] + b->v[$i];\n";
    }
    publish_extern($oc, $p, $s);
}

#### SUB ####

sub gen_sub_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t);
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    r->v[$i] = a->v[$i] - b->v[$i];\n";
    }
    publish_extern($oc, $p, $s);
}

#### NEG ####

sub gen_neg_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t);
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    r->v[$i] = -a->v[$i];\n";
    }
    publish_extern($oc, $p, $s);
}

#### MUL ####

sub gen_mul_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>'X_scale_t');
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    r->v[$i] = a->v[$i] * b;\n";
    }
    publish_extern($oc, $p, $s);
}

#### DIV ####

sub gen_div_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>'X_scale_t');
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    r->v[$i] = X_div0(a->v[$i], b);\n";
    }
    publish_extern($oc, $p, $s);
}

#### DOT ####

sub gen_dot_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_sqrdim_t', $elem, a=>$t, b=>$t);
    my $s = '';
    $s .= "    return\n";
    $s .= "        (a->v[0] * b->v[0])";
    for my $i (1..$t->{dim}-1) {
        $s .= " +\n        (a->v[$i] * b->v[$i])";
    }
    $s .= ";\n";
    publish_extern($oc, $p, $s);
}

#### MIN ####

sub gen_min_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t);
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    r->v[$i] = a->v[$i] <= b->v[$i] ? a->v[$i] : b->v[$i];\n";
    }
    publish_extern($oc, $p, $s);
}

#### MAX ####

sub gen_max_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t);
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    r->v[$i] = a->v[$i] >= b->v[$i] ? a->v[$i] : b->v[$i];\n";
    }
    publish_extern($oc, $p, $s);
}

#### MINMAX ####

sub gen_minmax_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>"X_$t->{name}_minmax_t *", a=>$t);
    my $s = '';
    $s.= "    X_$t->{name}_min(&r->min, &r->min, a);\n";
    $s.= "    X_$t->{name}_max(&r->max, &r->max, a);\n";
    publish_extern($oc, $p, $s);
}

#### MAX_ABS_COORD ####

sub gen_max_abs_coord_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_dim_t', $elem, a=>$t);
    my $s = '';
    $s .= "    X_dim_t m = X_abs(a->v[0]);\n";
    $s .= "    X_dim_t p = X_abs(a->v[1]);\n";
    $s .= "    if (p > m) { m = p; }\n";
    for my $i (2..$t->{dim}-1) {
        $s .= "    p = X_abs(a->v[$i]);\n";
        $s .= "    if (p > m) { m = p; }\n";
    }
    $s .= "    return m;\n";
    publish_extern($oc, $p, $s);
}

#### SQR_LEN ####

sub gen_sqr_len_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_sqrdim_t', $elem, a=>$t);
    my $s = "    return X_$t->{name}_dot(a,a);\n";
    publish_inline($oc, $p, $s);
}

#### LEN ####

sub gen_len_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_dim_t', $elem, a=>$t);
    my $s = "    return sqrt(X_$t->{name}_sqr_len(a));\n";
    publish_inline($oc, $p, $s);
}

#### HAS_LEN1 ####

sub gen_has_len1_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'bool', $elem, a=>$t);
    my $s = "    return X_sqr_equ(X_$t->{name}_sqr_len(a), 1);\n";
    publish_inline($oc, $p, $s);
}

#### HAS_LEN0 ####

sub gen_has_len0_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'bool', $elem, a=>$t);
    my $s = '';
    $s .= "    return\n";
    $s .= "        X_equ(a->v[0], 0)";
    for my $i (1..$t->{dim}-1) {
        $s .= " &&\n        X_equ(a->v[$i], 0)";
    }
    $s .= ";\n";
    publish_extern($oc, $p, $s);
}

#### HAS_LEN0_OR_1 ####

sub gen_has_len0_or_1_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'bool', $elem, a=>$t);
    my $s = "    return X_$t->{name}_has_len0(a) || X_$t->{name}_has_len1(a);\n";
    publish_inline($oc, $p, $s);
}

#### SQR_DIST ####

sub gen_sqr_dist_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $name = "X_$t->{name}";
    my $p = proto($t, 'X_sqrdim_t', $elem, a=>$t, b=>$t);
    my $s = '';
    $s .= "    ${name}_t d[1];\n";
    $s .= "    ${name}_sub(d, a, b);\n";
    $s .= "    return ${name}_sqr_len(d);\n";
    publish_extern($oc, $p, $s);
}

#### DIST ####

sub gen_dist_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_dim_t', $elem, a=>$t, b=>$t);
    my $s = "    return sqrt(X_$t->{name}_sqr_dist(a,b));\n";
    publish_inline($oc, $p, $s);
}

#### LERP ####

sub gen_lerp_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $name = "X_$t->{name}";
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t, c=>"X_scale_t");
    my $s = '';
    $s .= "    ${name}_t h[1];\n";
    $s .= "    ${name}_sub(h, b, a);\n";
    $s .= "    ${name}_mul(h, h, c);\n";
    $s .= "    ${name}_add(r, a, h);\n";
    publish_extern($oc, $p, $s);
}

#### DIR ####

sub gen_dir_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $name = "X_$t->{name}";
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t);
    my $s = '';
    $s .= "    ${name}_sub(r, a, b);\n";
    $s .= "    ${name}_unit(r, r);\n";
    publish_extern($oc, $p, $s);
}

#### put ####

sub gen_put_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, s=>"X_stream_t*", a=>$t);
    my $s = '';
    for my $i (0..$t->{dim}-1) {
        $s .= "    X_printf(s, \" $FF\\n\", a->v[$i]);\n";
    }
    publish_extern($oc, $p, $s);
}

sub gen_put_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, s=>"X_stream_t*", a=>$t);
    my $s = '';
    $s.= "    for (X_size_each(y, $t->{dim})) {\n";
    $s.= "        for (X_size_each(x, $t->{dim})) {\n";
    $s.= "            X_printf(s, \" $FF\", a->m[y][x]);\n";
    $s.= "        }\n";
    $s.= "        X_printf(s, \"\\n\");\n";
    $s.= "    }\n";
    publish_extern($oc, $p, $s);
}

sub gen_put_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, s=>"X_stream_t*", a=>$t);
    my $s = '';
    $s.= "    for (X_size_each(y, $t->{dim})) {\n";
    $s.= "        for (X_size_each(x, $t->{dim})) {\n";
    $s.= "            X_printf(s, \" $FF\", a->b.m[y][x]);\n";
    $s.= "        }\n";
    $s.= "        X_printf(s, \" $FF\\n\", a->w.v[y]);\n";
    $s.= "    }\n";
    publish_extern($oc, $p, $s);
}

sub gen_put_matwi($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, s=>"X_stream_t*", a=>$t);
    my $s = '';
    $s.= "    for (X_size_each(y, $t->{dim})) {\n";
    $s.= "        for (X_size_each(x, $t->{dim})) {\n";
    $s.= "            X_printf(s, \" $FF\", a->n.b.m[y][x]);\n";
    $s.= "        }\n";
    $s.= "        X_printf(s, \" $FF  \", a->n.w.v[y]);\n";
    $s.= "        for (X_size_each(x, $t->{dim})) {\n";
    $s.= "            X_printf(s, \" $FF\", a->i.b.m[y][x]);\n";
    $s.= "        }\n";
    $s.= "        X_printf(s, \" $FF\", a->i.w.v[y]);\n";
    $s.= "        if (y == 0) {\n";
    $s.= "            X_printf(s, \"   $FF\", a->d);\n";
    $s.= "        }\n";
    $s.= "        X_printf(s, \"\\n\");\n";
    $s.= "    }\n";
    publish_extern($oc, $p, $s);
}

sub gen_put_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    if ($t->{base}{kind} eq 'matw') {
        return gen_put_matwi($oc, $t, $elem);
    }
    my $p = proto($t, 'void', $elem, s=>"X_stream_t*", a=>$t);
    my $s = '';
    $s.= "    for (X_size_each(y, $t->{dim})) {\n";
    $s.= "        for (X_size_each(x, $t->{dim})) {\n";
    $s.= "            X_printf(s, \" $FF\", a->n.m[y][x]);\n";
    $s.= "        }\n";
    $s.= "        X_printf(s, \"  \");\n";
    $s.= "        for (X_size_each(x, $t->{dim})) {\n";
    $s.= "            X_printf(s, \" $FF\", a->i.m[y][x]);\n";
    $s.= "        }\n";
    $s.= "        if (y == 0) {\n";
    $s.= "            X_printf(s, \"   $FF\", a->d);\n";
    $s.= "        }\n";
    $s.= "        X_printf(s, \"\\n\");\n";
    $s.= "    }\n";
    publish_extern($oc, $p, $s);
}

#### XFORM ####

sub gen_xform_vec($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t->{vec}, 'void', $elem, r=>$t->{vec}, a=>$t, b=>$t->{vec});
    my $s = '';
    $s .= "    X_$t->{vec}{name}_t h = { .v={\n";
    for my $y (0..$t->{dim}-1) {
        $s .= "        ".join(" + ", map { "(a->m[$y][$_] * b->v[$_])"; } 0..$t->{dim}-1).",\n";
    }
    $s .= "    }};\n";
    $s .= "    *r = h;\n";
    publish_extern($oc, $p, $s);
}

sub gen_xform_vecw($$$)
{
    my ($oc, $t, $elem) = @_;
    die unless $t->{name};
    die unless $t->{vec};
    my $mat  = "X_$t->{base}{name}";
    my $matw = "X_$t->{name}";
    my $vec  = "X_$t->{vec}{name}";
    my $p =
        "void ${vec}w_$elem(\n".
        "    ${vec}_t *r,\n".
        "    ${matw}_t const *m,\n".
        "    ${vec}_t const *v)";
    my $s = '';
    $s .= "    ${vec}_xform(r, &m->b, v);\n";
    $s .= "    ${vec}_add(r, r, &m->w);\n";
    publish_extern($oc, $p, $s);
}

#### put ####

# get the main matrix element in the struct
sub get_m($)
{
    my ($t) = @_;
    return "m" if $t->{kind} eq 'mat';
    return "b.m" if $t->{kind} eq 'matw';
    return "n.m" if $t->{kind} eq 'mati';
    return "n.b.m" if $t->{kind} eq 'matwi';
    die;
}

sub gen_scale_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my @c = coord($t->{dimx});

    my $name = "X_$t->{name}";
    my $p = proto($t, 'void', $elem, r=>$t, xt("X_scale_t", @c));

    my $s = '';
    $s .= "    X_ZERO(r);\n";
    my $m = get_m($t);
    for my $i (0..$#c) {
        $s .= "    r->${m}[$i][$i] = $c[$i];\n";
    }
    for my $i ($t->{dimx}..$t->{dim}-1) {
        $s .= "    r->${m}[$i][$i] = 1;\n";
    }

    publish_inline($oc, $p, $s);
}

sub gen_scale_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my @c = coord($t->{dimx});

    my $name = "X_$t->{name}";
    my $p = proto($t, 'void', $elem, r=>$t, xt('X_scale_t', @c));
    my $s = '';
    $s .= "    X_$t->{base}{name}_$elem(&r->n, ".join(", ", @c).");\n";
    $s .= "    X_$t->{base}{name}_$elem(&r->i, ".join(", ", map { "X_div0(1,$_)" } @c).");\n";
    $s .= "    r->d = ".join(" * ", @c).";\n";
    publish_extern($oc, $p, $s);
}

sub gen_scale1_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>'X_scale_t');
    my $s = "    X_$t->{name}_scale(r, ".join(", ", map {"a"} coord($t->{dimx})).");\n";
    publish_inline($oc, $p, $s);
}

sub gen_scale_v_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t->{vecx});
    my $s = "    X_$t->{name}_scale(r, ".join(", ", map {"a->$_"} coord($t->{dimx})).");\n";
    publish_inline($oc, $p, $s);
}

sub gen_unit_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t);
    my $s = "    X_$t->{name}_scale1(r, 1);\n";
    publish_inline($oc, $p, $s);
}

#### TRANS ####

sub gen_trans_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t);
    my $s = '';
    $s .= "    if (r != a) { *r = *a; }\n";
    for my $i (0..$t->{dim}-2) {
        for my $j ($i+1..$t->{dim}-1) {
            $s .= "    X_SWAP(&r->m[$i][$j], &r->m[$j][$i]);\n";
        }
    }
    publish_extern($oc, $p, $s);
}

sub gen_trans_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'bool', $elem, r=>$t, a=>$t);
    my $s = '';
    $s .= "    bool good = X_$t->{vec}{name}_has_len0(&a->w);\n";
    $s .= "    X_$t->{base}{name}_$elem(&r->b, &a->b);\n";
    $s .= "    X_ZERO(&r->w);\n";
    $s .= "    return good;\n";
    publish_extern($oc, $p, $s);
}

sub gen_trans_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p;
    my $s = '';
    $s .= "    r->d = a->d;\n";
    if ($t->{base}{kind} eq 'matw') {
        $p = proto($t, 'bool', $elem, r=>$t, a=>$t);
        $s .= "    (void) X_$t->{base}{name}_$elem(&r->i, &a->i);\n";
        $s .= "    return X_$t->{base}{name}_$elem(&r->n, &a->n);\n";
    }
    else {
        $p = proto($t, 'void', $elem, r=>$t, a=>$t);
        $s .= "    X_$t->{base}{name}_$elem(&r->n, &a->n);\n";
        $s .= "    X_$t->{base}{name}_$elem(&r->i, &a->i);\n";
    }
    publish_extern($oc, $p, $s);
}

#### ROT ####

sub gen_rot_mirror_foo_matw($$$@)
{
    my ($oc, $t, $elem, @arg) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, @arg);
    my $s = '';
    my $as = join(", ",arg_name(@arg));
    $s .= "    X_$t->{base}{name}_$elem(&r->b, $as);\n";
    $s .= "    X_ZERO(&r->w);\n";
    publish_inline($oc, $p, $s);
}

sub gen_rot_foo_mati($$$@)
{
    my ($oc, $t, $elem, @arg) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, @arg);
    my $s = '';
    my $as = join(", ",arg_name(@arg));
    $s .= "    X_$t->{base}{name}_$elem(&r->n, $as);\n";
    $s .= "    X_$t->{base}{name}_trans(&r->i, &r->n);\n";
    $s .= "    r->d = 1;\n";
    publish_extern($oc, $p, $s);
}

sub gen_rot_unit_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    my $p = proto($t, 'void', $elem, r=>$t, u=>$vec3, sc=>$vec2);
    my $b = ($t->{dim} == 4 ? ".b" : "");
    my $s = '';
    if ($t->{dim} == 4) {
        $s .= "    X_ZERO(r);\n";
        $s .= "    r->m[3][3] = 1;\n";
    }
    $s .= "    X_dim3_$elem(&r->row[0]$b, &r->row[1]$b, &r->row[2]$b, u, sc);\n";
    publish_inline($oc, $p, $s);
}

sub gen_rot_unit_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    return gen_rot_mirror_foo_matw($oc, $t, $elem, v=>$vec3, sc=>$vec2);
}

sub gen_rot_unit_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    return gen_rot_foo_mati($oc, $t, $elem, v=>$vec3, sc=>$vec2);
}

sub gen_rot_v_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    my $p = proto($t, 'void', $elem, r=>$t, v=>$vec3, sc=>$vec2);
    my $s = '';
    $s .= "    X_$t->{vecx}{name}_t u;\n";
    $s .= "    X_$t->{vecx}{name}_unit(&u, v);\n";
    $s .= "    X_$t->{name}_rot_unit(r, &u, sc);\n";
    publish_extern($oc, $p, $s);
}

sub gen_rot_unit_into_z_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    my $p = proto($t, 'void', $elem, r=>$t, u=>$vec3);
    my $b = ($t->{dim} == 4 ? ".b" : "");
    my $s = '';
    if ($t->{dim} == 4) {
        $s .= "    X_ZERO(r);\n";
        $s .= "    r->m[3][3] = 1;\n";
    }
    $s .= "    X_dim3_$elem(&r->row[0]$b, &r->row[1]$b, &r->row[2]$b, u);\n";
    publish_inline($oc, $p, $s);
}

sub gen_rot_unit_into_z_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    return gen_rot_mirror_foo_matw($oc, $t, $elem, v=>$vec3);
}

sub gen_rot_unit_into_z_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    return gen_rot_foo_mati($oc, $t, $elem, v=>$vec3);
}

sub gen_rot_into_z_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    return unless $t->{dimx} == 3;
    my $p = proto($t, 'void', $elem, r=>$t, v=>$vec3);
    my $s = '';
    $s .= "    X_$t->{vecx}{name}_t u;\n";
    $s .= "    X_$t->{vecx}{name}_unit(&u, v);\n";
    $s .= "    X_$t->{name}_rot_unit_into_z(r, &u);\n";
    publish_extern($oc, $p, $s);
}

sub gen_rot_ij_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, i=>'size_t', j=>'size_t', sc=>$vec2);
    my $s = '';
    $s .= "    assert(i < $t->{dim});\n";
    $s .= "    assert(j < $t->{dim});\n";
    $s .= "    assert(X_vec2_has_len0_or_1(sc));\n";
    $s .= "    X_dim_t s = sc->v[0];\n";
    $s .= "    X_dim_t c = sc->v[1];\n";
    $s .= "    X_$t->{name}_unit(r);\n";
    $s .= "    r->m[i][i] = c;\n";
    $s .= "    r->m[j][j] = c;\n";
    $s .= "    r->m[i][j] = -s;\n";
    $s .= "    r->m[j][i] = s;\n";
    publish_extern($oc, $p, $s);
}

sub gen_rot_ij_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    return gen_rot_mirror_foo_matw($oc, $t, $elem, i=>'size_t', j=>'size_t', sc=>$vec2);
}

sub gen_rot_ij_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    return gen_rot_foo_mati($oc, $t, $elem, i=>'size_t', j=>'size_t', sc=>$vec2);
}

sub gen_rot_x_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    return if $t->{dim} < 3;
    my $p = proto($t, 'void', $elem, r=>$t, sc=>$vec2);
    my $s = '';
    $s .= "    X_$t->{name}_rot_ij(r, 1, 2, sc);\n";
    publish_inline($oc, $p, $s);
}

sub gen_rot_y_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    return if $t->{dim} < 3;
    my $p = proto($t, 'void', $elem, r=>$t, sc=>$vec2);
    my $s = '';
    $s .= "    X_$t->{name}_rot_ij(r, 2, 0, sc);\n";
    publish_inline($oc, $p, $s);
}

sub gen_rot_xy_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    return if $t->{dim} < 3;
    return gen_rot_mirror_foo_matw($oc, $t, $elem, sc=>$vec2);
}

sub gen_rot_xy_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    return if $t->{dim} < 3;
    return gen_rot_foo_mati($oc, $t, $elem, sc=>$vec2);
}

sub gen_rot_z_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    $elem = 'rot' if $t->{dim} <= 2;
    my $p = proto($t, 'void', $elem, r=>$t, sc=>$vec2);
    my $s = '';
    $s .= "    X_$t->{name}_rot_ij(r, 0, 1, sc);\n";
    publish_inline($oc, $p, $s);
}

sub gen_rot_z_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    $elem = 'rot' if $t->{dim} <= 2;
    return gen_rot_mirror_foo_matw($oc, $t, $elem, sc=>$vec2);
}

sub gen_rot_z_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    $elem = 'rot' if $t->{dim} <= 2;
    return gen_rot_foo_mati($oc, $t, $elem, sc=>$vec2);
}

#### MIRROR ####

sub gen_mirror_unit_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, u=>$t->{vecx});
    my $s = '';
    if ($t->{dimx} == 2) {
        $s .= "    X_dim2_mirror_unit(&r->row[0], &r->row[1], u);\n";
    }
    elsif ($t->{dim} == 3) {
        $s .= "    X_dim3_mirror_unit(&r->row[0], &r->row[1], &r->row[2], u);\n";
    }
    elsif ($t->{dim} == 4) {
        $s .= "    X_ZERO(r);\n";
        $s .= "    r->m[3][3] = 1;\n";
        $s .= "    X_dim3_mirror_unit(&r->row[0].b, &r->row[1].b, &r->row[2].b, u);\n";
    }
    publish_inline($oc, $p, $s);
}

sub gen_mirror_v_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    return gen_rot_mirror_foo_matw($oc, $t, $elem, v=>$t->{vecx});
}

sub gen_mirror_foo_mati($$$@)
{
    my ($oc, $t, $elem, @arg) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, @arg);
    my $s = '';
    my $as = join(", ",arg_name(@arg));
    $s .= "    X_$t->{base}{name}_$elem(&r->n, $as);\n";
    $s .= "    r->i = r->n;\n";
    $s .= "    r->d = -1;\n";
    publish_extern($oc, $p, $s);
}

sub gen_mirror_v_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    return gen_mirror_foo_mati($oc, $t, $elem, v=>$t->{vecx});
}

sub gen_mirror_v_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, v=>$t->{vecx});
    my $s = '';
    $s .= "    X_$t->{vecx}{name}_t u;\n";
    $s .= "    X_$t->{vecx}{name}_unit(&u, v);\n";
    $s .= "    X_$t->{name}_mirror_unit(r, &u);\n";
    publish_extern($oc, $p, $s);
}

#### XLAT ####

sub gen_xlat_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $j = $t->{dimt};
    return unless defined $j;
    my @c = coord($j);
    my $p = proto($t, 'void', $elem, r=>$t, xt('X_dim_t', @c));
    my $s = '';
    $s.= "    X_$t->{name}_unit(r);\n";
    for my $i (0..$#c) {
        $s.= "    r->m[$i][$j] = $c[$i];\n";
    }
    publish_inline($oc, $p, $s);
}

sub gen_xlat_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    my $j = $t->{dimt};
    my @c = coord($j);
    my $p = proto($t, 'void', $elem, r=>$t, xt('X_dim_t', @c));
    my $s = '';
    $s.= "    X_$t->{base}{name}_unit(&r->b);\n";
    $s.= "    X_INIT(&r->w, ".join(", ", @c).");\n";
    publish_inline($oc, $p, $s);
}

sub gen_xlat_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my $j = $t->{dimt};
    return unless defined $j;
    my @c = coord($j);
    my $p = proto($t, 'void', $elem, r=>$t, xt('X_dim_t', @c));
    my $s = '';
    $s.= "    X_$t->{base}{name}_$elem(&r->n, ".join(", ", @c).");\n";
    $s.= "    X_$t->{base}{name}_$elem(&r->i, ".join(", ", map {"-$_" } @c).");\n";
    $s.= "    r->d = 1;\n";
    publish_inline($oc, $p, $s);
}

sub gen_xlat_v_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $j = $t->{dimt};
    return unless defined $j;
    my @c = coord($j);
    my $p = proto($t, 'void', $elem, r=>$t, v=>$t->{vect});
    my $s = '';
    $s.= "    X_$t->{name}_xlat(r, ".join(", ", map { "v->$_" } @c).");\n";
    publish_inline($oc, $p, $s);
}

#### MUL ####

sub matmul($$)
{
    my ($d, $m) = @_;
    my $s = '';
    for my $y (0..$d) {
        for my $x (0..$d) {
            my $h = $m->($d, 'h.', $y, $x, undef);
            if (defined $h) {
                my @s = ();
                for my $i (0..$d) {
                    my $a = $m->($d, 'a->', $y, $i, 1);
                    my $b = $m->($d, 'b->', $i, $x, 1);
                    if (defined $a && defined $b) {
                        if ($b eq '1') {
                            push @s, $a;
                        }
                        elsif ($a eq '1') {
                            push @s, $b;
                        }
                        else {
                            push @s, "($a * $b)";
                        }
                    }
                }
                $s.= "    $h = ".join(" + ", @s).";\n";
            }
        }
    }
    return $s;
}

sub gen_mul_mat_aux($$$$)
{
    my ($oc, $t, $elem, $m) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t);
    my $s = '';
    $s.= "    X_$t->{name}_t h;\n";
    $s.= matmul($t->{dim}, $m);
    $s.= "    *r = h;\n";
    publish_extern($oc, $p, $s);
}

sub m_mat($$$$$)
{
    my ($d, $m, $y, $x, $one) = @_;
    return "${m}m[$y][$x]" if ($x < $d) && ($y < $d);
    return;
}

sub gen_mul_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    return gen_mul_mat_aux($oc, $t, $elem, \&m_mat);
}

sub m_matw($$$$$)
{
    my ($d, $m, $y, $x, $one) = @_;
    return "${m}b.m[$y][$x]" if ($x <  $d) && ($y <  $d);
    return "${m}w.v[$y]"     if ($x == $d) && ($y <  $d);
    return $one              if ($x == $d) && ($y == $d);
    return;
}

sub gen_mul_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    return gen_mul_mat_aux($oc, $t, $elem, \&m_matw);
}

sub gen_mul_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t, b=>$t);
    my $s = '';
    $s.= "    X_$t->{base}{name}_mul(&r->n, &a->n, &b->n);\n";
    $s.= "    X_$t->{base}{name}_mul(&r->i, &b->i, &a->i);\n";
    $s.= "    r->d = a->d * b->d;\n";
    publish_extern($oc, $p, $s);
}

#### INV ####

sub gen_inv_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, '__wur X_det_t', $elem, r=>$t, a=>$t);
    # implementation in mat.c, generated with mkinv.pl.
    publish_extern($oc, $p, undef);
}

sub gen_inv_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, a=>$t);
    my $s = '';
    $s.= "    if (r == a) {\n";
    $s.= "        X_SWAP(&r->n, &r->i);\n";
    $s.= "    } else {\n";
    $s.= "        r->n = a->i;\n";
    $s.= "        r->i = a->n;\n";
    $s.= "    }\n";
    $s.= "    r->d = X_div0(1, r->d);\n";
    publish_extern($oc, $p, $s);
}

#### DET ####

sub gen_det_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_det_t', $elem, a=>$t);
    # implementation in mat.c, generated with mkinv.pl.
    publish_extern($oc, $p, undef);
}

sub gen_det_mati($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_det_t', $elem, a=>$t);
    my $s = '';
    $s.= "    return a->d;\n";
    publish_inline($oc, $p, $s);
}

#### GET_IDX ####

sub gen_get_idx_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'size_t', $elem, x=>'size_t', y=>'size_t');
    my $name = "X_$t->{name}_t";
    my $s = '';
    $s.= "    assert(x < $t->{dim});\n";
    $s.= "    assert(y < $t->{dim});\n";
    $s.= "    return X_offsetof($name, m[y][x]);\n";
    publish_inline($oc, $p, $s);
}

sub gen_get_idx_matw($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'size_t', $elem, x=>'size_t', y=>'size_t');
    my $name = "X_$t->{name}_t";
    my $s = '';
    $s.= "    assert(y < $t->{dim});\n";
    $s.= "    if (x == $t->{dim}) {\n";
    $s.= "        return X_offsetof($name, w.v[y]);\n";
    $s.= "    }\n";
    $s.= "    assert(x < $t->{dim});\n";
    $s.= "    return X_offsetof($name, b.m[y][x]);\n";
    publish_inline($oc, $p, $s);
}

#### GET_PTR ####

sub gen_get_ptr_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_dim_t*', $elem, r=>$t, x=>'size_t', y=>'size_t');
    my $s = '';
    $s.= "    return &r->v[X_$t->{name}_get_idx(x,y)];\n";
    publish_inline($oc, $p, $s);
}

#### GET ####

sub gen_get_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'X_dim_t', $elem, a=>$t, x=>'size_t', y=>'size_t');
    my $s = '';
    $s.= "    return a->v[X_$t->{name}_get_idx(x,y)];\n";
    publish_inline($oc, $p, $s);
}

#### SET ####

sub gen_set_mat($$$)
{
    my ($oc, $t, $elem) = @_;
    my $p = proto($t, 'void', $elem, r=>$t, x=>'size_t', y=>'size_t', c=>'X_dim_t');
    my $s = '';
    $s.= "    *X_$t->{name}_get_ptr(r,x,y) = c;\n";
    publish_inline($oc, $p, $s);
}

# Things to generate:
my @gen = (
    ['t', {
        vec => \&gen_type_vec,
        mat => \&gen_type_mat,
        mati => \&gen_type_mati,
        matw => \&gen_type_matw,
    }],
    ['lex_cmp', {
        vec => \&gen_lex_cmp,
        mat => \&gen_lex_cmp,
        matw => \&gen_lex_cmp,
        mati => \&gen_lex_cmp_mati,
    }],
    ['equ', {
        vec => \&gen_equ,
        mat => \&gen_equ,
        mati => \&gen_equ,
        matw => \&gen_equ,
    }],
    ['rev', {
        vec => \&gen_rev_vec,
    }],
    ['add', {
        vec => \&gen_add_vec,
    }],
    ['neg', {
        vec => \&gen_neg_vec,
    }],
    ['sub', {
        vec => \&gen_sub_vec,
    }],
    ['mul', {
        vec => \&gen_mul_vec,
    }],
    ['div', {
        vec => \&gen_div_vec,
    }],
    ['dot', {
        vec => \&gen_dot_vec,
    }],
    ['min', {
        vec => \&gen_min_vec,
    }],
    ['max', {
        vec => \&gen_max_vec,
    }],
    ['minmax', {
        vec => \&gen_minmax_vec,
    }],
    ['max_abs_coord', {
        vec => \&gen_max_abs_coord_vec,
    }],
    ['sqr_len', {
        vec => \&gen_sqr_len_vec,
    }],
    ['len', {
        vec => \&gen_len_vec,
    }],
    ['has_len0', {
        vec => \&gen_has_len0_vec,
    }],
    ['has_len1', {
        vec => \&gen_has_len1_vec,
    }],
    ['has_len0_or_1', {
        vec => \&gen_has_len0_or_1_vec,
    }],
    ['unit', {
        vec => \&gen_unit_vec,
    }],
    ['sqr_dist', {
        vec => \&gen_sqr_dist_vec,
    }],
    ['dist', {
        vec => \&gen_dist_vec,
    }],
    ['lerp', {
        vec => \&gen_lerp_vec,
    }],
    ['dir', {
        vec => \&gen_dir_vec,
    }],
    ['xform', {
        mat  => \&gen_xform_vec,
        matw => \&gen_xform_vecw,
    }],
    ['put', {
        vec  => \&gen_put_vec,
        mat  => \&gen_put_mat,
        matw => \&gen_put_matw,
        mati => \&gen_put_mati,
    }],
    ['scale', {
        mat  => \&gen_scale_mat,
        matw => \&gen_scale_mat,
        mati => \&gen_scale_mati,
    }],
    ['scale1', {
        mat  => \&gen_scale1_mat,
        matw => \&gen_scale1_mat,
        mati => \&gen_scale1_mat,
    }],
    ['scale_v', {
        mat  => \&gen_scale_v_mat,
        matw => \&gen_scale_v_mat,
        mati => \&gen_scale_v_mat,
    }],
    ['unit', {
        mat  => \&gen_unit_mat,
        matw => \&gen_unit_mat,
        mati => \&gen_unit_mat,
    }],
    ['trans', {
        mat  => \&gen_trans_mat,
        matw => \&gen_trans_matw,
        mati => \&gen_trans_mati,
    }],
    ['rot_unit', {
        mat  => \&gen_rot_unit_mat,
        matw => \&gen_rot_unit_matw,
        mati => \&gen_rot_unit_mati,
    }],
    ['rot_v', {
        mat  => \&gen_rot_v_mat,
        matw => \&gen_rot_v_mat,
        mati => \&gen_rot_v_mat,
    }],
    ['rot_unit_into_z', {
        mat  => \&gen_rot_unit_into_z_mat,
        matw => \&gen_rot_unit_into_z_matw,
        mati => \&gen_rot_unit_into_z_mati,
    }],
    ['rot_into_z', {
        mat  => \&gen_rot_into_z_mat,
        matw => \&gen_rot_into_z_mat,
        mati => \&gen_rot_into_z_mat,
    }],
    ['rot_ij', {
        mat  => \&gen_rot_ij_mat,
        matw => \&gen_rot_ij_matw,
        mati => \&gen_rot_ij_mati,
    }],
    ['rot_x', {
        mat  => \&gen_rot_x_mat,
        matw => \&gen_rot_xy_matw,
        mati => \&gen_rot_xy_mati,
    }],
    ['rot_y', {
        mat  => \&gen_rot_y_mat,
        matw => \&gen_rot_xy_matw,
        mati => \&gen_rot_xy_mati,
    }],
    ['rot_z', {
        mat  => \&gen_rot_z_mat,
        matw => \&gen_rot_z_matw,
        mati => \&gen_rot_z_mati,
    }],
    ['mirror_unit', {
        mat  => \&gen_mirror_unit_mat,
        matw => \&gen_mirror_v_matw,
        mati => \&gen_mirror_v_mati,
    }],
    ['mirror_v', {
        mat  => \&gen_mirror_v_mat,
        matw => \&gen_mirror_v_mat,
        mati => \&gen_mirror_v_mat,
    }],
    ['xlat', {
        mat  => \&gen_xlat_mat,
        matw => \&gen_xlat_matw,
        mati => \&gen_xlat_mati,
    }],
    ['xlat_v', {
        mat  => \&gen_xlat_v_mat,
        matw => \&gen_xlat_v_mat,
        mati => \&gen_xlat_v_mat,
    }],
    ['mul', {
        mat  => \&gen_mul_mat,
        matw => \&gen_mul_matw,
        mati => \&gen_mul_mati,
    }],
    ['inv', {
        mat  => \&gen_inv_mat,
        matw => \&gen_inv_mat,
        mati => \&gen_inv_mati,
    }],
    ['det', {
        mat  => \&gen_det_mat,
        matw => \&gen_det_mat,
        mati => \&gen_det_mati,
    }],
    ['get_idx', {
        mat  => \&gen_get_idx_mat,
        matw => \&gen_get_idx_matw,
    }],
    ['get_ptr', {
        mat  => \&gen_get_ptr_mat,
        matw => \&gen_get_ptr_mat,
    }],
    ['get', {
        mat  => \&gen_get_mat,
        matw => \&gen_get_mat,
    }],
    ['set', {
        mat  => \&gen_set_mat,
        matw => \&gen_set_mat,
    }],
);

sub gen_all($)
{
    my ($oc) = @_;
    for my $g (@gen) {
        my ($elem, $genmap) = @$g;
        for my $t (@type) {
            if (my $f = $genmap->{$t->{kind}}) {
                $f->($oc, $t, $elem);
            }
        }
    }
}

sub lines(@);
sub lines(@)
{
    my $s = join("\n", @_);
    $s =~ s/\b(_*)X_([a-z])/$1${Plc}$2/g;
    $s =~ s/\b(_*)X_([A-Z])/$1${Puc}$2/g;
    return $s;
}

my $oc = { out => {} };
gen_all($oc);

my %file = (
    'tam_h' => {
        file => "include/$I/mat_gen_tam.h",
        ifndef => "__${Puc}MAT_GEN_TAM_H",
        include => [
            "$I/def.h",
            "$I/vec.h",
        ],
    },
    'inl_h' => {
        file => "include/$I/mat_gen_inl.h",
        ifndef => "__${Puc}MAT_GEN_INL_H",
        include => [
            "$I/mat_gen_tam.h",
            "$I/mat_gen_ext.h",
            "$I/arith.h",
            "$I/algo.h",
        ],
    },
    'ext_h' => {
        file => "include/$I/mat_gen_ext.h",
        ifndef => "__${Puc}MAT_GEN_H",
        include => [
            "$I/stream_tam.h",
            "$I/mat_gen_tam.h",
        ],
    },
    'ext_c' => {
        file => "src/mat_gen_ext.c",
        include => [
            "$I/arith.h",
            "$I/algo.h",
            "$I/stream.h",
            "$I/mat_tam.h",
            "$I/mat_gen_tam.h",
            "$I/mat_gen_ext.h",
            "$I/mat_gen_inl.h",
        ],
    },
);
for my $ext (sort keys %{ $oc->{out} }) {
    my $x = $file{$ext};
    my $ifndef = $x->{ifndef};

    die "Unknown file: $ext" unless $x;

    open(my $f, '>', "$x->{file}.new") or die "open: $@";

    print {$f} "/* -*- Mode: C -*- */\n";
    print {$f} "\n";
    if ($ifndef) {
        print {$f} "#ifndef $ifndef\n";
        print {$f} "#define $ifndef\n";
        print {$f} "\n";
    }
    if ($x->{include}) {
        for my $inc (@{ $x->{include} }) {
            print {$f} "#include <$inc>\n";
        }
        print {$f} "\n";
    }

    print {$f} lines(@{ $oc->{out}{$ext} });

    if ($ifndef) {
        print {$f} "\n";
        print {$f} "#endif /* $ifndef */\n";
    }

    close $f;

    rename "$x->{file}.new", "$x->{file}" or die "rename: $@";
}

0;
