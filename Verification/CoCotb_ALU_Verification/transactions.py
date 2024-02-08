import cocotb 
import random
from cocotb_coverage.crv import *

"""***************************************************************************************************************
* Check This Important Link For Coverage And Constraints 
https://cocotb-coverage.readthedocs.io/en/latest/reference.html#cocotb_coverage.crv.Randomized.randomize_with

* The Source Code With Examples 
https://cocotb-coverage.readthedocs.io/en/latest/_modules/cocotb_coverage/crv.html#Randomized.add_constraint

* Check This Link For Extra Information about Constraints 
https://cocotb-coverage.readthedocs.io/en/latest/introduc

tion.html#constrained-random-verification-features-in-systemverilog
* Another link but it is so important 
https://cocotb-coverage.readthedocs.io/en/latest/tutorials.html

*****************************************************************************************************************"""
class  transactions(Randomized):
    def __init__(self ,name = "TRANSACTIONS"):
        Randomized.__init__(self)
        self.name = name
        self.RST         =  0  
        self.A           =  0
        self.B           =  0
        self.ALU_FUN     =  0
        self.Arith_Flag  =  0 
        self.Logic_Flag  =  0 
        self.CMP_Flag    =  0 
        self.Shift_Flag  =  0 
        self.ALU_OUT     =  0

        self.add_rand("RST"        , list(range(0,2)       )   ) 
        self.add_rand("A"          , list(range(0,65536)   )   ) 
        self.add_rand("B"          , list(range(0,65536)   )   )
        self.add_rand("ALU_FUN"    , list(range(0,16)      )   )


        self.add_constraint(lambda ALU_FUN :  ALU_FUN < 15)

    """     Another Implementation 
        def Unique(RdEn_tb, WrEn_tb):
            if (RdEn_tb == 0) :
                return WrEn_tb == 1 
            elif (WrEn_tb==0):
                return RdEn_tb == 1 
            elif (RdEn_tb==1) :
                return WrEn_tb == 0 
            elif (WrEn_tb==1):
                return RdEn_tb == 0 
        self.add_constraint(Unique)
    
    """

    def display(self,name = "TRANSACTION"):
        cocotb.log.info("******************"+str(name)+"*******************")
        cocotb.log.info("the Value of RST         is   " + str(self.RST        ))
        cocotb.log.info("the Value of A           is   " + str(self.A          ))
        cocotb.log.info("the Value of B           is   " + str(self.B          ))
        cocotb.log.info("the Value of ALU_FUN     is   " + str(self.ALU_FUN    ))
        cocotb.log.info("the Value of Arith_Flag  is   " + str(self.Arith_Flag ))
        cocotb.log.info("the Value of Logic_Flag  is   " + str(self.Logic_Flag ))
        cocotb.log.info("the Value of CMP_Flag    is   " + str(self.CMP_Flag   ))
        cocotb.log.info("the Value of Shift_Flag  is   " + str(self.Shift_Flag ))
        cocotb.log.info("the Value of ALU_OUT     is   " + str(self.ALU_OUT    ))
        cocotb.log.info("**************************************************")


