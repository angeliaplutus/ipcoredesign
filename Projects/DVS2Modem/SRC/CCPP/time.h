

#pragma once

#include <stdint.h>
#include <sys/time.h>

#ifdef __cplusplus
extern "C"
{
#endif


inline uint64_t time_ms(void)
{
    struct timeval  tval;

    gettimeofday(&tval, NULL);

    return 1e3 * tval.tv_sec + 1e-3 * tval.tv_usec;
}

inline uint64_t time_us(void)
{
    struct timeval  tval;

    gettimeofday(&tval, NULL);

    return 1e6 * tval.tv_sec + tval.tv_usec;
}


#ifdef __cplusplus
}
#endif
