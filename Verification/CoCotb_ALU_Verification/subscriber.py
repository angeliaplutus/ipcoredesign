from transactions import * 
from cocotb.triggers import * 
import cocotb
import cocotb.queue
from cocotb_coverage.coverage import *


@CoverPoint("top.ALU_OUT"      , vname="ALU_OUT"      , bins=list(range(0, 2 ** 16  ))) 
@CoverPoint("top.Arith_Flag"   , vname="Arith_Flag"   , bins=list(range(0, 2  ))) 
@CoverPoint("top.Logic_Flag"   , vname="Logic_Flag"   , bins=list(range(0, 2  ))) 
@CoverPoint("top.CMP_Flag"     , vname="CMP_Flag"     , bins=list(range(0, 2  ))) 
@CoverPoint("top.Shift_Flag"   , vname="Shift_Flag"   , bins=list(range(0, 2  ))) 
def sample(ALU_OUT,Arith_Flag,Logic_Flag,CMP_Flag,Shift_Flag):
    pass

class subscriber() :
   
    def __init__(self ,name = "SUBSCRIBER"): 
       self.name               = name
       self.t_sub              = transactions()
       self.sub_mail           = cocotb.queue.Queue()

    async def run_subscriber (self) : 
        while(True):
            self.t_sub = transactions()
            cocotb.log.info("[subscriber] receiving from monitor..... ") 
            self.t_sub = await self.sub_mail.get() 
            #self.t_sub.display("SUBSCRIBER")
            cocotb.log.info("[subscriber] receiving from monitor..... ") 
            sample(self.t_sub.ALU_OUT,self.t_sub.Arith_Flag,self.t_sub.Logic_Flag,self.t_sub.CMP_Flag,self.t_sub.Shift_Flag)
 
    def coverage_report(self):
        ALU_OUT       = coverage_db["top.RdData_tb"].coverage          
        ALU_OUT_p     = coverage_db["top.RdData_tb"].cover_percentage  
        cocotb.log.info("The ALU_OUT   coverage is : "+str(ALU_OUT))
        cocotb.log.info("The ALU_OUT_p coverage percentage is : "+str(ALU_OUT_p))

                