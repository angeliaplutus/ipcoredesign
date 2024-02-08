from cocotb.triggers import *
from transactions import *
import cocotb
import cocotb.queue

class monitor ():
   t_monitor    = transactions()
   mon_mail_s   = cocotb.queue.Queue()
   mon_mail_su  = cocotb.queue.Queue()
   def __int__(self,name = "MONITOR"):
        self.name= name
      
   async def run_monitor (self,dut_monitor):
      cocotb.log.info("[Monitor] STARTING.")
      await RisingEdge(dut_monitor.CLK)
      while(True):
        cocotb.log.info("[Monitor] waiting for item ...")
        await RisingEdge(dut_monitor.CLK)
        await ReadOnly()
        self.t_monitor.RST            =   int(dut_monitor.RST)
        self.t_monitor.A              =   int(dut_monitor.A)    
        self.t_monitor.B              =   int(dut_monitor.B.value )    
        self.t_monitor.ALU_FUN        =   int(dut_monitor.ALU_FUN.value  )
        self.t_monitor.Arith_Flag     =   int(dut_monitor.Arith_Flag.value )
        self.t_monitor.Logic_Flag     =   int(dut_monitor.Logic_Flag.value  )
        self.t_monitor.Shift_Flag     =   int(dut_monitor.Shift_Flag.value  )
        self.t_monitor.CMP_Flag       =   int(dut_monitor.CMP_Flag.value  )
        self.t_monitor.ALU_OUT        =   int(dut_monitor.ALU_OUT.value  )
        #self.t_monitor.display("MONITOR")  
        await self.mon_mail_s.put(self.t_monitor)  
        await self.mon_mail_su.put(self.t_monitor)
