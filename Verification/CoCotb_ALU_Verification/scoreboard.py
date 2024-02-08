from transactions import * 
from cocotb.triggers import * 
import cocotb
import cocotb.queue


class Scoreboard() :
   
    def __init__(self ,name = "SCOREBOARD"): 
       self.name                = name
       self.t_score             = transactions()
       self.score_mail          = cocotb.queue.Queue()
       self.passed_test_cases   = 0
       self.failed_test_cases   = 0
       self.Golden_ALU_OUT      = 0
       self.Golden_Arith_Flag   = 0
       self.Golden_Logic_Flag   = 0
       self.Golden_CMP_Flag     = 0
       self.Golden_Shift_Flag   = 0




    async def run_scoreboard (self) : 
        while(True):
            self.t_score = transactions()
            cocotb.log.info("[Scoreboard] receiving from monitor..... ") 
            self.t_score = await self.score_mail.get() 
            #self.t_score.display("SCOREBOARD")
            """**************************  TEST CASES **************************"""
            if self.t_score.RST == 0:
                self.reset_test_case()
            elif self.t_score.ALU_FUN in [0 , 1 , 2 , 3] :
                self.arithmatic_test_case()    
            elif self.t_score.ALU_FUN in [4 , 5 , 6 , 7 , 8 , 9]:
                self.logical_test_case()
            elif self.t_score.ALU_FUN in [10 , 11 , 12 ]:
                self.cmp_test_case()
            elif self.t_score.ALU_FUN in [13 , 14  ]:
                self.shift_test_case()
            """******************************************************************"""


    def reset_test_case (self) :

        if self.t_score.ALU_OUT == self.Golden_ALU_OUT :
            self.passed_test_cases += 1
            cocotb.log.info("Reset Test Case Passed ")
        else:
            self.failed_test_cases += 1
            cocotb.log.info("Reset Test Case Failed ")

    def arithmatic_test_case(self) :
        if  self.t_score.ALU_FUN == 0:
            self.Golden_ALU_OUT = self.t_score.A + self.t_score.B
        elif self.t_score.ALU_FUN == 1:
            self.Golden_ALU_OUT =     self.t_score.A - self.t_score.B   
        elif self.t_score.ALU_FUN == 2:
            self.Golden_ALU_OUT = self.t_score.A * self.t_score.B
        else:
            self.Golden_ALU_OUT = int (self.t_score.A / self.t_score.B)
        if self.Golden_ALU_OUT < 0 :
            self.Golden_ALU_OUT = 2**32 + self.Golden_ALU_OUT

        self.Golden_Arith_Flag  = 1 
        
        if self.t_score.ALU_OUT == self.Golden_ALU_OUT and self.t_score.Arith_Flag == self.Golden_Arith_Flag :
            self.passed_test_cases += 1
            cocotb.log.info("arithmatic Test Case Passed ")
        else:
            self.failed_test_cases += 1
            cocotb.log.info("arithmatic Test Case Failed ")
            cocotb.log.info("GOLDEN OUT :"+str(self.Golden_ALU_OUT))

    def logical_test_case(self):
        if  self.t_score.ALU_FUN == 4:
            self.Golden_ALU_OUT = self.t_score.A & self.t_score.B
        elif self.t_score.ALU_FUN == 5:
            self.Golden_ALU_OUT =     self.t_score.A | self.t_score.B   
        elif self.t_score.ALU_FUN == 6:
            self.Golden_ALU_OUT = ~ ( self.t_score.A & self.t_score.B )
        elif self.t_score.ALU_FUN == 7:
            self.Golden_ALU_OUT = ~ (self.t_score.A | self.t_score.B)
        elif self.t_score.ALU_FUN == 8:
            self.Golden_ALU_OUT = self.t_score.A ^ self.t_score.B
        elif self.t_score.ALU_FUN == 9:
            self.Golden_ALU_OUT = ~ ( self.t_score.A ^ self.t_score.B )

        if self.Golden_ALU_OUT < 0 :
            self.Golden_ALU_OUT = 2**32 + self.Golden_ALU_OUT
        self.Golden_Logic_Flag  = 1 
        
        if self.t_score.ALU_OUT == self.Golden_ALU_OUT and self.t_score.Logic_Flag == self.Golden_Logic_Flag :
            self.passed_test_cases += 1
            cocotb.log.info("Logic Test Case Passed ")
        else:
            self.failed_test_cases += 1
            cocotb.log.info("Logic Test Case Failed ")
            cocotb.log.info("GOLDEN OUT :"+str(self.Golden_ALU_OUT))

    def cmp_test_case(self):
        if  self.t_score.ALU_FUN == 10:
            if self.t_score.A ==  self.t_score.B :
                self.Golden_ALU_OUT = 1
            else :
                self.Golden_ALU_OUT = 0
        elif self.t_score.ALU_FUN == 11:
            if self.t_score.A >  self.t_score.B :
                self.Golden_ALU_OUT = 2 
            else :
                self.Golden_ALU_OUT = 0 
        elif self.t_score.ALU_FUN == 12:
            if self.t_score.A <  self.t_score.B :
                self.Golden_ALU_OUT = 3  
            else :
                self.Golden_ALU_OUT = 0

        self.Golden_CMP_Flag = 1 

        if self.t_score.ALU_OUT == self.Golden_ALU_OUT and self.t_score.CMP_Flag == self.Golden_CMP_Flag :
            self.passed_test_cases += 1
            cocotb.log.info("CMP Test Case Passed ")
        else:
            self.failed_test_cases += 1
            cocotb.log.info("CMP Test Case Failed ")
            cocotb.log.info("GOLDEN OUT :"+str(self.Golden_ALU_OUT))

    def shift_test_case(self) :
        if  self.t_score.ALU_FUN == 13:
            self.Golden_ALU_OUT = self.t_score.A >> 1
        elif self.t_score.ALU_FUN == 14:
            self.Golden_ALU_OUT = self.t_score.A << 1 

        self.Golden_Shift_Flag  = 1 
        
        if self.t_score.ALU_OUT == self.Golden_ALU_OUT and self.t_score.Shift_Flag == self.Golden_Shift_Flag :
            self.passed_test_cases += 1
            cocotb.log.info("Shift Test Case Passed ")
        else:
            self.failed_test_cases += 1
            cocotb.log.info("Shift Test Case Failed ")
            cocotb.log.info("GOLDEN OUT :"+str(self.Golden_ALU_OUT))

    def report_test_cases(self):
        self.total_test_cases = self.passed_test_cases + self.failed_test_cases
        cocotb.log.info("The Number Of Total  Test Cases is :  " + str(self.total_test_cases)) 
        cocotb.log.info("The Number Of Passed Test Cases is :  " + str(self.passed_test_cases))  
        cocotb.log.info("The Number Of Failed Test Cases is :  " + str(self.failed_test_cases))           


