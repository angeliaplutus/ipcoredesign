from transactions import * 
from cocotb.triggers import * 
import cocotb
import cocotb.queue

class driver ():

   def __int__(self,name = "DRIVER"):
      self.name = name
      self.driv_mail      = cocotb.queue.Queue()
      self.t_drive        = transactions()
      self.driv_handover  = Event(name=None) 
      
   async def run_driver (self,dut_driver):
      cocotb.log.info("[Driver] STARTING.")
      while(True):
         cocotb.log.info("[Driver] waiting for item ...")
         self.t_drive = await self.driv_mail.get()
         cocotb.log.info("[Driver] Recieved items is  ...")
         await FallingEdge(dut_driver.CLK)
         #self.t_drive.display("DRIVER")
         dut_driver.RST.value      = self.t_drive.RST
         dut_driver.A.value        = self.t_drive.A
         dut_driver.B.value        = self.t_drive.B
         dut_driver.ALU_FUN.value  = self.t_drive.ALU_FUN
         self.driv_handover.set() 
