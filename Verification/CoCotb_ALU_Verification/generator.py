from transactions import * 
from cocotb.triggers import * 
import cocotb
import cocotb.queue


class generator() :
   
    def __init__(self ,join_any,name = "GENERATOR"): 
       self.name             = name
       self.t_gen            = transactions()
       self.gen_mail         = cocotb.queue.Queue()
       self.gen_handover     = Event(name=None) 
       self.join_any         = join_any

    async def run_generator (self,dut_generator) : 
        iteration_number = 1000 ; 
        for i in range(iteration_number): 
            self.gen_handover.clear() 
            if (i == 0 ) :
                await self.reset_sequence()


            else :
                await self.arithmatic_sequence()
                await self.logic_sequence()
                await self.cmp_sequence()
                await self.shift_sequence()

        await FallingEdge(dut_generator.CLK)
        self.join_any.set()

    """ ************* **************** Sequence Generation ****************** ***************"""
    async def reset_sequence (self):
        self.t_gen = transactions()
        self.t_gen.randomize_with(lambda RST: RST == 0  )
        #self.t_gen.display("GENERATOR")
        cocotb.log.info("[Generator] Sending To The Driver..... ") 
        await self.gen_mail.put(self.t_gen)  
        await self.gen_handover.wait()      

    async def arithmatic_sequence(self) :
        self.gen_handover.clear() 
        self.t_gen = transactions()
        self.t_gen.randomize_with(lambda RST :RST == 1 ,lambda ALU_FUN : ALU_FUN in [0,1,2,3 ] )
        #self.t_gen.display("GENERATOR")
        cocotb.log.info("[Generator] Sending To The Driver..... ")
        await self.gen_mail.put(self.t_gen) 
        await self.gen_handover.wait()

    async def logic_sequence(self) :
        self.gen_handover.clear() 
        self.t_gen = transactions()
        self.t_gen.randomize_with(lambda RST :RST == 1 ,lambda ALU_FUN :ALU_FUN in [4,5,6,7,8,9] )
        #self.t_gen.display("GENERATOR")
        cocotb.log.info("[Generator] Sending To The Driver..... ")
        await self.gen_mail.put(self.t_gen) 
        await self.gen_handover.wait()
     
    async def cmp_sequence(self) :
        self.gen_handover.clear() 
        self.t_gen = transactions()
        self.t_gen.randomize_with(lambda RST :RST == 1 ,lambda ALU_FUN :ALU_FUN in [10,11,12] )
        #self.t_gen.display("GENERATOR")
        cocotb.log.info("[Generator] Sending To The Driver..... ")
        await self.gen_mail.put(self.t_gen) 
        await self.gen_handover.wait()
    
    async def shift_sequence(self) :
        self.gen_handover.clear() 
        self.t_gen = transactions()
        self.t_gen.randomize_with(lambda RST :RST == 1 ,lambda ALU_FUN :ALU_FUN in [13,14] )
        #self.t_gen.display("GENERATOR")
        cocotb.log.info("[Generator] Sending To The Driver..... ")
        await self.gen_mail.put(self.t_gen) 
        await self.gen_handover.wait()