/* -*- Mode: C -*- */
/* Copyright (C) 2018 by Henrik Theiling, License: GPLv3, see LICENSE file */

#ifndef __CP_ARITH_TAM_H
#define __CP_ARITH_TAM_H

#include <hob3lbase/def.h>

typedef struct {
    double min;
    double step;
    size_t cnt;
} cp_range_t;

/**
 * Iterator for circles */
typedef struct {
    cp_dim_t cos;
    cp_dim_t sin;
    size_t idx;
    size_t _i;
    size_t _n;
    cp_angle_t _a;
} cp_circle_iter_t;

#define cp_deg(rad) (((rad) / (cp_f_t)180) * CP_PI)

#endif /* __CP_ARITH_H */
