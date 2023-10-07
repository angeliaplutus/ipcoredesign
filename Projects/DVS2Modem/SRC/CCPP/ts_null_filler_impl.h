

#pragma once

#include <stdint.h>
#include "ts_null_filler.h"

#define TS_PACKET_SIZE 188

class ts_null_filler_bb_impl : public ts_null_filler_bb
{
private:
    unsigned char   null_ts_packet[TS_PACKET_SIZE];
    int             null_ts_num;
    uint64_t        null_ts_dt_ms;
    uint64_t        tlast;

public:
    ts_null_filler_bb_impl(int pps);
    ~ts_null_filler_bb_impl();

    void forecast(int noutput_items, gr_vector_int &ninput_items_required);

    int general_work(int noutput_items,
                     gr_vector_int &ninput_items,
                     gr_vector_const_void_star &input_items,
                     gr_vector_void_star &output_items);
};
