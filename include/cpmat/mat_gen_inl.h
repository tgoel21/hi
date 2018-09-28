/* -*- Mode: C -*- */

#ifndef __CP_MAT_GEN_INL_H
#define __CP_MAT_GEN_INL_H

#include <cpmat/mat_gen_tam.h>
#include <cpmat/mat_gen_ext.h>
#include <cpmat/arith.h>
#include <cpmat/algo.h>

static inline int cp_vec2_lex_cmp(
    cp_vec2_t const* a,
    cp_vec2_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_vec3_lex_cmp(
    cp_vec3_t const* a,
    cp_vec3_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_vec4_lex_cmp(
    cp_vec4_t const* a,
    cp_vec4_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_mat2_lex_cmp(
    cp_mat2_t const* a,
    cp_mat2_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_mat2w_lex_cmp(
    cp_mat2w_t const* a,
    cp_mat2w_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_mat2i_lex_cmp(
    cp_mat2i_t const* a,
    cp_mat2i_t const* b)
{
    return cp_mat2_lex_cmp(&a->n, &b->n);
}

static inline int cp_mat2wi_lex_cmp(
    cp_mat2wi_t const* a,
    cp_mat2wi_t const* b)
{
    return cp_mat2w_lex_cmp(&a->n, &b->n);
}

static inline int cp_mat3_lex_cmp(
    cp_mat3_t const* a,
    cp_mat3_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_mat3w_lex_cmp(
    cp_mat3w_t const* a,
    cp_mat3w_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_mat3i_lex_cmp(
    cp_mat3i_t const* a,
    cp_mat3i_t const* b)
{
    return cp_mat3_lex_cmp(&a->n, &b->n);
}

static inline int cp_mat3wi_lex_cmp(
    cp_mat3wi_t const* a,
    cp_mat3wi_t const* b)
{
    return cp_mat3w_lex_cmp(&a->n, &b->n);
}

static inline int cp_mat4_lex_cmp(
    cp_mat4_t const* a,
    cp_mat4_t const* b)
{
    return cp_lex_cmp(a->v, b->v, cp_countof(a->v));
}

static inline int cp_mat4i_lex_cmp(
    cp_mat4i_t const* a,
    cp_mat4i_t const* b)
{
    return cp_mat4_lex_cmp(&a->n, &b->n);
}

static inline bool cp_vec2_equ(
    cp_vec2_t const* a,
    cp_vec2_t const* b)
{
    return cp_vec2_lex_cmp(a,b) == 0;
}

static inline bool cp_vec3_equ(
    cp_vec3_t const* a,
    cp_vec3_t const* b)
{
    return cp_vec3_lex_cmp(a,b) == 0;
}

static inline bool cp_vec4_equ(
    cp_vec4_t const* a,
    cp_vec4_t const* b)
{
    return cp_vec4_lex_cmp(a,b) == 0;
}

static inline bool cp_mat2_equ(
    cp_mat2_t const* a,
    cp_mat2_t const* b)
{
    return cp_mat2_lex_cmp(a,b) == 0;
}

static inline bool cp_mat2w_equ(
    cp_mat2w_t const* a,
    cp_mat2w_t const* b)
{
    return cp_mat2w_lex_cmp(a,b) == 0;
}

static inline bool cp_mat2i_equ(
    cp_mat2i_t const* a,
    cp_mat2i_t const* b)
{
    return cp_mat2i_lex_cmp(a,b) == 0;
}

static inline bool cp_mat2wi_equ(
    cp_mat2wi_t const* a,
    cp_mat2wi_t const* b)
{
    return cp_mat2wi_lex_cmp(a,b) == 0;
}

static inline bool cp_mat3_equ(
    cp_mat3_t const* a,
    cp_mat3_t const* b)
{
    return cp_mat3_lex_cmp(a,b) == 0;
}

static inline bool cp_mat3w_equ(
    cp_mat3w_t const* a,
    cp_mat3w_t const* b)
{
    return cp_mat3w_lex_cmp(a,b) == 0;
}

static inline bool cp_mat3i_equ(
    cp_mat3i_t const* a,
    cp_mat3i_t const* b)
{
    return cp_mat3i_lex_cmp(a,b) == 0;
}

static inline bool cp_mat3wi_equ(
    cp_mat3wi_t const* a,
    cp_mat3wi_t const* b)
{
    return cp_mat3wi_lex_cmp(a,b) == 0;
}

static inline bool cp_mat4_equ(
    cp_mat4_t const* a,
    cp_mat4_t const* b)
{
    return cp_mat4_lex_cmp(a,b) == 0;
}

static inline bool cp_mat4i_equ(
    cp_mat4i_t const* a,
    cp_mat4i_t const* b)
{
    return cp_mat4i_lex_cmp(a,b) == 0;
}

static inline cp_sqrdim_t cp_vec2_sqr_len(
    cp_vec2_t const* a)
{
    return cp_vec2_dot(a,a);
}

static inline cp_sqrdim_t cp_vec3_sqr_len(
    cp_vec3_t const* a)
{
    return cp_vec3_dot(a,a);
}

static inline cp_sqrdim_t cp_vec4_sqr_len(
    cp_vec4_t const* a)
{
    return cp_vec4_dot(a,a);
}

static inline cp_dim_t cp_vec2_len(
    cp_vec2_t const* a)
{
    return sqrt(cp_vec2_sqr_len(a));
}

static inline cp_dim_t cp_vec3_len(
    cp_vec3_t const* a)
{
    return sqrt(cp_vec3_sqr_len(a));
}

static inline cp_dim_t cp_vec4_len(
    cp_vec4_t const* a)
{
    return sqrt(cp_vec4_sqr_len(a));
}

static inline bool cp_vec2_has_len1(
    cp_vec2_t const* a)
{
    return cp_sqr_equ(cp_vec2_sqr_len(a), 1);
}

static inline bool cp_vec3_has_len1(
    cp_vec3_t const* a)
{
    return cp_sqr_equ(cp_vec3_sqr_len(a), 1);
}

static inline bool cp_vec4_has_len1(
    cp_vec4_t const* a)
{
    return cp_sqr_equ(cp_vec4_sqr_len(a), 1);
}

static inline bool cp_vec2_has_len0_or_1(
    cp_vec2_t const* a)
{
    return cp_vec2_has_len0(a) || cp_vec2_has_len1(a);
}

static inline bool cp_vec3_has_len0_or_1(
    cp_vec3_t const* a)
{
    return cp_vec3_has_len0(a) || cp_vec3_has_len1(a);
}

static inline bool cp_vec4_has_len0_or_1(
    cp_vec4_t const* a)
{
    return cp_vec4_has_len0(a) || cp_vec4_has_len1(a);
}

static inline cp_dim_t cp_vec2_dist(
    cp_vec2_t const* a,
    cp_vec2_t const* b)
{
    return sqrt(cp_vec2_sqr_dist(a,b));
}

static inline cp_dim_t cp_vec3_dist(
    cp_vec3_t const* a,
    cp_vec3_t const* b)
{
    return sqrt(cp_vec3_sqr_dist(a,b));
}

static inline cp_dim_t cp_vec4_dist(
    cp_vec4_t const* a,
    cp_vec4_t const* b)
{
    return sqrt(cp_vec4_sqr_dist(a,b));
}

static inline void cp_mat2_scale(
    cp_mat2_t * r,
    cp_scale_t x,
    cp_scale_t y)
{
    CP_ZERO(r);
    r->m[0][0] = x;
    r->m[1][1] = y;
}

static inline void cp_mat2w_scale(
    cp_mat2w_t * r,
    cp_scale_t x,
    cp_scale_t y)
{
    CP_ZERO(r);
    r->b.m[0][0] = x;
    r->b.m[1][1] = y;
}

static inline void cp_mat3_scale(
    cp_mat3_t * r,
    cp_scale_t x,
    cp_scale_t y,
    cp_scale_t z)
{
    CP_ZERO(r);
    r->m[0][0] = x;
    r->m[1][1] = y;
    r->m[2][2] = z;
}

static inline void cp_mat3w_scale(
    cp_mat3w_t * r,
    cp_scale_t x,
    cp_scale_t y,
    cp_scale_t z)
{
    CP_ZERO(r);
    r->b.m[0][0] = x;
    r->b.m[1][1] = y;
    r->b.m[2][2] = z;
}

static inline void cp_mat4_scale(
    cp_mat4_t * r,
    cp_scale_t x,
    cp_scale_t y,
    cp_scale_t z)
{
    CP_ZERO(r);
    r->m[0][0] = x;
    r->m[1][1] = y;
    r->m[2][2] = z;
    r->m[3][3] = 1;
}

static inline void cp_mat2_scale1(
    cp_mat2_t * r,
    cp_scale_t a)
{
    cp_mat2_scale(r, a, a);
}

static inline void cp_mat2w_scale1(
    cp_mat2w_t * r,
    cp_scale_t a)
{
    cp_mat2w_scale(r, a, a);
}

static inline void cp_mat2i_scale1(
    cp_mat2i_t * r,
    cp_scale_t a)
{
    cp_mat2i_scale(r, a, a);
}

static inline void cp_mat2wi_scale1(
    cp_mat2wi_t * r,
    cp_scale_t a)
{
    cp_mat2wi_scale(r, a, a);
}

static inline void cp_mat3_scale1(
    cp_mat3_t * r,
    cp_scale_t a)
{
    cp_mat3_scale(r, a, a, a);
}

static inline void cp_mat3w_scale1(
    cp_mat3w_t * r,
    cp_scale_t a)
{
    cp_mat3w_scale(r, a, a, a);
}

static inline void cp_mat3i_scale1(
    cp_mat3i_t * r,
    cp_scale_t a)
{
    cp_mat3i_scale(r, a, a, a);
}

static inline void cp_mat3wi_scale1(
    cp_mat3wi_t * r,
    cp_scale_t a)
{
    cp_mat3wi_scale(r, a, a, a);
}

static inline void cp_mat4_scale1(
    cp_mat4_t * r,
    cp_scale_t a)
{
    cp_mat4_scale(r, a, a, a);
}

static inline void cp_mat4i_scale1(
    cp_mat4i_t * r,
    cp_scale_t a)
{
    cp_mat4i_scale(r, a, a, a);
}

static inline void cp_mat2_scale_v(
    cp_mat2_t * r,
    cp_vec2_t const* a)
{
    cp_mat2_scale(r, a->x, a->y);
}

static inline void cp_mat2w_scale_v(
    cp_mat2w_t * r,
    cp_vec2_t const* a)
{
    cp_mat2w_scale(r, a->x, a->y);
}

static inline void cp_mat2i_scale_v(
    cp_mat2i_t * r,
    cp_vec2_t const* a)
{
    cp_mat2i_scale(r, a->x, a->y);
}

static inline void cp_mat2wi_scale_v(
    cp_mat2wi_t * r,
    cp_vec2_t const* a)
{
    cp_mat2wi_scale(r, a->x, a->y);
}

static inline void cp_mat3_scale_v(
    cp_mat3_t * r,
    cp_vec3_t const* a)
{
    cp_mat3_scale(r, a->x, a->y, a->z);
}

static inline void cp_mat3w_scale_v(
    cp_mat3w_t * r,
    cp_vec3_t const* a)
{
    cp_mat3w_scale(r, a->x, a->y, a->z);
}

static inline void cp_mat3i_scale_v(
    cp_mat3i_t * r,
    cp_vec3_t const* a)
{
    cp_mat3i_scale(r, a->x, a->y, a->z);
}

static inline void cp_mat3wi_scale_v(
    cp_mat3wi_t * r,
    cp_vec3_t const* a)
{
    cp_mat3wi_scale(r, a->x, a->y, a->z);
}

static inline void cp_mat4_scale_v(
    cp_mat4_t * r,
    cp_vec3_t const* a)
{
    cp_mat4_scale(r, a->x, a->y, a->z);
}

static inline void cp_mat4i_scale_v(
    cp_mat4i_t * r,
    cp_vec3_t const* a)
{
    cp_mat4i_scale(r, a->x, a->y, a->z);
}

static inline void cp_mat2_unit(
    cp_mat2_t * r)
{
    cp_mat2_scale1(r, 1);
}

static inline void cp_mat2w_unit(
    cp_mat2w_t * r)
{
    cp_mat2w_scale1(r, 1);
}

static inline void cp_mat2i_unit(
    cp_mat2i_t * r)
{
    cp_mat2i_scale1(r, 1);
}

static inline void cp_mat2wi_unit(
    cp_mat2wi_t * r)
{
    cp_mat2wi_scale1(r, 1);
}

static inline void cp_mat3_unit(
    cp_mat3_t * r)
{
    cp_mat3_scale1(r, 1);
}

static inline void cp_mat3w_unit(
    cp_mat3w_t * r)
{
    cp_mat3w_scale1(r, 1);
}

static inline void cp_mat3i_unit(
    cp_mat3i_t * r)
{
    cp_mat3i_scale1(r, 1);
}

static inline void cp_mat3wi_unit(
    cp_mat3wi_t * r)
{
    cp_mat3wi_scale1(r, 1);
}

static inline void cp_mat4_unit(
    cp_mat4_t * r)
{
    cp_mat4_scale1(r, 1);
}

static inline void cp_mat4i_unit(
    cp_mat4i_t * r)
{
    cp_mat4i_scale1(r, 1);
}

static inline void cp_mat3_rot_unit(
    cp_mat3_t * r,
    cp_vec3_t const* u,
    cp_vec2_t const* sc)
{
    cp_dim3_rot_unit(&r->row[0], &r->row[1], &r->row[2], u, sc);
}

static inline void cp_mat3w_rot_unit(
    cp_mat3w_t * r,
    cp_vec3_t const* v,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_unit(&r->b, v, sc);
    CP_ZERO(&r->w);
}

static inline void cp_mat4_rot_unit(
    cp_mat4_t * r,
    cp_vec3_t const* u,
    cp_vec2_t const* sc)
{
    CP_ZERO(r);
    r->m[3][3] = 1;
    cp_dim3_rot_unit(&r->row[0].b, &r->row[1].b, &r->row[2].b, u, sc);
}

static inline void cp_mat3_rot_unit_into_z(
    cp_mat3_t * r,
    cp_vec3_t const* u)
{
    cp_dim3_rot_unit_into_z(&r->row[0], &r->row[1], &r->row[2], u);
}

static inline void cp_mat3w_rot_unit_into_z(
    cp_mat3w_t * r,
    cp_vec3_t const* v)
{
    cp_mat3_rot_unit_into_z(&r->b, v);
    CP_ZERO(&r->w);
}

static inline void cp_mat4_rot_unit_into_z(
    cp_mat4_t * r,
    cp_vec3_t const* u)
{
    CP_ZERO(r);
    r->m[3][3] = 1;
    cp_dim3_rot_unit_into_z(&r->row[0].b, &r->row[1].b, &r->row[2].b, u);
}

static inline void cp_mat2w_rot_ij(
    cp_mat2w_t * r,
    size_t i,
    size_t j,
    cp_vec2_t const* sc)
{
    cp_mat2_rot_ij(&r->b, i, j, sc);
    CP_ZERO(&r->w);
}

static inline void cp_mat3w_rot_ij(
    cp_mat3w_t * r,
    size_t i,
    size_t j,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_ij(&r->b, i, j, sc);
    CP_ZERO(&r->w);
}

static inline void cp_mat3_rot_x(
    cp_mat3_t * r,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_ij(r, 1, 2, sc);
}

static inline void cp_mat3w_rot_x(
    cp_mat3w_t * r,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_x(&r->b, sc);
    CP_ZERO(&r->w);
}

static inline void cp_mat4_rot_x(
    cp_mat4_t * r,
    cp_vec2_t const* sc)
{
    cp_mat4_rot_ij(r, 1, 2, sc);
}

static inline void cp_mat3_rot_y(
    cp_mat3_t * r,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_ij(r, 2, 0, sc);
}

static inline void cp_mat3w_rot_y(
    cp_mat3w_t * r,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_y(&r->b, sc);
    CP_ZERO(&r->w);
}

static inline void cp_mat4_rot_y(
    cp_mat4_t * r,
    cp_vec2_t const* sc)
{
    cp_mat4_rot_ij(r, 2, 0, sc);
}

static inline void cp_mat2_rot(
    cp_mat2_t * r,
    cp_vec2_t const* sc)
{
    cp_mat2_rot_ij(r, 0, 1, sc);
}

static inline void cp_mat2w_rot(
    cp_mat2w_t * r,
    cp_vec2_t const* sc)
{
    cp_mat2_rot(&r->b, sc);
    CP_ZERO(&r->w);
}

static inline void cp_mat3_rot_z(
    cp_mat3_t * r,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_ij(r, 0, 1, sc);
}

static inline void cp_mat3w_rot_z(
    cp_mat3w_t * r,
    cp_vec2_t const* sc)
{
    cp_mat3_rot_z(&r->b, sc);
    CP_ZERO(&r->w);
}

static inline void cp_mat4_rot_z(
    cp_mat4_t * r,
    cp_vec2_t const* sc)
{
    cp_mat4_rot_ij(r, 0, 1, sc);
}

static inline void cp_mat2_mirror_unit(
    cp_mat2_t * r,
    cp_vec2_t const* u)
{
    cp_dim2_mirror_unit(&r->row[0], &r->row[1], u);
}

static inline void cp_mat2w_mirror_unit(
    cp_mat2w_t * r,
    cp_vec2_t const* v)
{
    cp_mat2_mirror_unit(&r->b, v);
    CP_ZERO(&r->w);
}

static inline void cp_mat3_mirror_unit(
    cp_mat3_t * r,
    cp_vec3_t const* u)
{
    cp_dim3_mirror_unit(&r->row[0], &r->row[1], &r->row[2], u);
}

static inline void cp_mat3w_mirror_unit(
    cp_mat3w_t * r,
    cp_vec3_t const* v)
{
    cp_mat3_mirror_unit(&r->b, v);
    CP_ZERO(&r->w);
}

static inline void cp_mat4_mirror_unit(
    cp_mat4_t * r,
    cp_vec3_t const* u)
{
    CP_ZERO(r);
    r->m[3][3] = 1;
    cp_dim3_mirror_unit(&r->row[0].b, &r->row[1].b, &r->row[2].b, u);
}

static inline void cp_mat2w_xlat(
    cp_mat2w_t * r,
    cp_dim_t x,
    cp_dim_t y)
{
    cp_mat2_unit(&r->b);
    CP_INIT(&r->w, x, y);
}

static inline void cp_mat2wi_xlat(
    cp_mat2wi_t * r,
    cp_dim_t x,
    cp_dim_t y)
{
    cp_mat2w_xlat(&r->n, x, y);
    cp_mat2w_xlat(&r->i, -x, -y);
    r->d = 1;
}

static inline void cp_mat3_xlat(
    cp_mat3_t * r,
    cp_dim_t x,
    cp_dim_t y)
{
    cp_mat3_unit(r);
    r->m[0][2] = x;
    r->m[1][2] = y;
}

static inline void cp_mat3w_xlat(
    cp_mat3w_t * r,
    cp_dim_t x,
    cp_dim_t y,
    cp_dim_t z)
{
    cp_mat3_unit(&r->b);
    CP_INIT(&r->w, x, y, z);
}

static inline void cp_mat3i_xlat(
    cp_mat3i_t * r,
    cp_dim_t x,
    cp_dim_t y)
{
    cp_mat3_xlat(&r->n, x, y);
    cp_mat3_xlat(&r->i, -x, -y);
    r->d = 1;
}

static inline void cp_mat3wi_xlat(
    cp_mat3wi_t * r,
    cp_dim_t x,
    cp_dim_t y,
    cp_dim_t z)
{
    cp_mat3w_xlat(&r->n, x, y, z);
    cp_mat3w_xlat(&r->i, -x, -y, -z);
    r->d = 1;
}

static inline void cp_mat4_xlat(
    cp_mat4_t * r,
    cp_dim_t x,
    cp_dim_t y,
    cp_dim_t z)
{
    cp_mat4_unit(r);
    r->m[0][3] = x;
    r->m[1][3] = y;
    r->m[2][3] = z;
}

static inline void cp_mat4i_xlat(
    cp_mat4i_t * r,
    cp_dim_t x,
    cp_dim_t y,
    cp_dim_t z)
{
    cp_mat4_xlat(&r->n, x, y, z);
    cp_mat4_xlat(&r->i, -x, -y, -z);
    r->d = 1;
}

static inline void cp_mat2w_xlat_v(
    cp_mat2w_t * r,
    cp_vec2_t const* v)
{
    cp_mat2w_xlat(r, v->x, v->y);
}

static inline void cp_mat2wi_xlat_v(
    cp_mat2wi_t * r,
    cp_vec2_t const* v)
{
    cp_mat2wi_xlat(r, v->x, v->y);
}

static inline void cp_mat3_xlat_v(
    cp_mat3_t * r,
    cp_vec2_t const* v)
{
    cp_mat3_xlat(r, v->x, v->y);
}

static inline void cp_mat3w_xlat_v(
    cp_mat3w_t * r,
    cp_vec3_t const* v)
{
    cp_mat3w_xlat(r, v->x, v->y, v->z);
}

static inline void cp_mat3i_xlat_v(
    cp_mat3i_t * r,
    cp_vec2_t const* v)
{
    cp_mat3i_xlat(r, v->x, v->y);
}

static inline void cp_mat3wi_xlat_v(
    cp_mat3wi_t * r,
    cp_vec3_t const* v)
{
    cp_mat3wi_xlat(r, v->x, v->y, v->z);
}

static inline void cp_mat4_xlat_v(
    cp_mat4_t * r,
    cp_vec3_t const* v)
{
    cp_mat4_xlat(r, v->x, v->y, v->z);
}

static inline void cp_mat4i_xlat_v(
    cp_mat4i_t * r,
    cp_vec3_t const* v)
{
    cp_mat4i_xlat(r, v->x, v->y, v->z);
}

static inline cp_det_t cp_mat2i_det(
    cp_mat2i_t const* a)
{
    return a->d;
}

static inline cp_det_t cp_mat2wi_det(
    cp_mat2wi_t const* a)
{
    return a->d;
}

static inline cp_det_t cp_mat3i_det(
    cp_mat3i_t const* a)
{
    return a->d;
}

static inline cp_det_t cp_mat3wi_det(
    cp_mat3wi_t const* a)
{
    return a->d;
}

static inline cp_det_t cp_mat4i_det(
    cp_mat4i_t const* a)
{
    return a->d;
}

static inline size_t cp_mat2_get_idx(
    size_t x,
    size_t y)
{
    assert(x < 2);
    assert(y < 2);
    return cp_offsetof(cp_mat2_t, m[y][x]);
}

static inline size_t cp_mat2w_get_idx(
    size_t x,
    size_t y)
{
    assert(y < 2);
    if (x == 2) {
        return cp_offsetof(cp_mat2w_t, w.v[y]);
    }
    assert(x < 2);
    return cp_offsetof(cp_mat2w_t, b.m[y][x]);
}

static inline size_t cp_mat3_get_idx(
    size_t x,
    size_t y)
{
    assert(x < 3);
    assert(y < 3);
    return cp_offsetof(cp_mat3_t, m[y][x]);
}

static inline size_t cp_mat3w_get_idx(
    size_t x,
    size_t y)
{
    assert(y < 3);
    if (x == 3) {
        return cp_offsetof(cp_mat3w_t, w.v[y]);
    }
    assert(x < 3);
    return cp_offsetof(cp_mat3w_t, b.m[y][x]);
}

static inline size_t cp_mat4_get_idx(
    size_t x,
    size_t y)
{
    assert(x < 4);
    assert(y < 4);
    return cp_offsetof(cp_mat4_t, m[y][x]);
}

static inline cp_dim_t* cp_mat2_get_ptr(
    cp_mat2_t * r,
    size_t x,
    size_t y)
{
    return &r->v[cp_mat2_get_idx(x,y)];
}

static inline cp_dim_t* cp_mat2w_get_ptr(
    cp_mat2w_t * r,
    size_t x,
    size_t y)
{
    return &r->v[cp_mat2w_get_idx(x,y)];
}

static inline cp_dim_t* cp_mat3_get_ptr(
    cp_mat3_t * r,
    size_t x,
    size_t y)
{
    return &r->v[cp_mat3_get_idx(x,y)];
}

static inline cp_dim_t* cp_mat3w_get_ptr(
    cp_mat3w_t * r,
    size_t x,
    size_t y)
{
    return &r->v[cp_mat3w_get_idx(x,y)];
}

static inline cp_dim_t* cp_mat4_get_ptr(
    cp_mat4_t * r,
    size_t x,
    size_t y)
{
    return &r->v[cp_mat4_get_idx(x,y)];
}

static inline cp_dim_t cp_mat2_get(
    cp_mat2_t const* a,
    size_t x,
    size_t y)
{
    return a->v[cp_mat2_get_idx(x,y)];
}

static inline cp_dim_t cp_mat2w_get(
    cp_mat2w_t const* a,
    size_t x,
    size_t y)
{
    return a->v[cp_mat2w_get_idx(x,y)];
}

static inline cp_dim_t cp_mat3_get(
    cp_mat3_t const* a,
    size_t x,
    size_t y)
{
    return a->v[cp_mat3_get_idx(x,y)];
}

static inline cp_dim_t cp_mat3w_get(
    cp_mat3w_t const* a,
    size_t x,
    size_t y)
{
    return a->v[cp_mat3w_get_idx(x,y)];
}

static inline cp_dim_t cp_mat4_get(
    cp_mat4_t const* a,
    size_t x,
    size_t y)
{
    return a->v[cp_mat4_get_idx(x,y)];
}

static inline void cp_mat2_set(
    cp_mat2_t * r,
    size_t x,
    size_t y,
    cp_dim_t c)
{
    *cp_mat2_get_ptr(r,x,y) = c;
}

static inline void cp_mat2w_set(
    cp_mat2w_t * r,
    size_t x,
    size_t y,
    cp_dim_t c)
{
    *cp_mat2w_get_ptr(r,x,y) = c;
}

static inline void cp_mat3_set(
    cp_mat3_t * r,
    size_t x,
    size_t y,
    cp_dim_t c)
{
    *cp_mat3_get_ptr(r,x,y) = c;
}

static inline void cp_mat3w_set(
    cp_mat3w_t * r,
    size_t x,
    size_t y,
    cp_dim_t c)
{
    *cp_mat3w_get_ptr(r,x,y) = c;
}

static inline void cp_mat4_set(
    cp_mat4_t * r,
    size_t x,
    size_t y,
    cp_dim_t c)
{
    *cp_mat4_get_ptr(r,x,y) = c;
}

#endif /* __CP_MAT_GEN_INL_H */
