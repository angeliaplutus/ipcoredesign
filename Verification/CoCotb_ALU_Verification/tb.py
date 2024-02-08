import cocotb
from environment     import * 
from cocotb.triggers import * 
from cocotb.clock    import Clock


@cocotb.test()
async def tb(dut):
    e = environment()
    cocotb.log.info(" WE ARE STARTING THE SIMULATION ")
    CLK = Clock(dut.CLK, 10, units="ns")
    await cocotb.start(CLK.start())
    cocotb.start_soon(e.run_environment(dut))
    await e.join_any.wait()
    e.s.report_test_cases()
    #e.su.coverage_report()
    coverage_db.export_to_xml(filename="ALU_coverage.xml")

    


