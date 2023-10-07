

#pragma once

#include <gnuradio/block.h>
#include <gnuradio/attributes.h>

#ifdef gnuradio_mod_EXPORTS
#  define MOD_API __GR_ATTR_EXPORT
#else
#  define MOD_API __GR_ATTR_IMPORT
#endif

class MOD_API ts_null_filler_bb : virtual public gr::block
{
public:
    typedef boost::shared_ptr<ts_null_filler_bb> sptr;

    static sptr make(int pps);
};
