module mips_alu_tb;
    logic clk;
    logic [4:0]control;//input alu control
    logic [31:0]src_1;//input of alu
    logic [31:0]src_2;//input of alu
    logic [31:0]result;//testbench result for comparesion
    logic branch;
    //logic [63:0] HILO;





    initial begin 
        $dumpfile("mips_alu_testwave.vcd");
        $dumpvars(0, mips_alu_testwave);


        clk=0;

        #5;

        repeat(10000)begin
            #10 clk = !clk;
        end

        $fatal(2,"clock time too short");


    end

    mips_alu alutb(
        .clk(clk),
        .branch(branch),
        .ALUControl(control),
        .alu_src_1(src_1),
        .alu_src_2(src_2),
        .alu_result(result)
    );




    initial begin 
        src_1=10;
        src_2=5;


                
        //@(posedge clk);//testcase for deflut
        //#2;
        //assert(result==32'bxxxxxxxx);
        //$display("result of input control %1 is %2",$control, $result);
        //else
        //$display("result of input control %1 failed with result %2",$control, $result);



        @(posedge clk);//testcase for add
        control=0;
        #2;
        assert(result==15)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        
        
        
        @(posedge clk);//test case for and
        control=1;
        #2;
        assert(result==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);       
        
                
        
        
        @(posedge clk);//test case for 1 == 2
        control=3;//greater
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);

        #1;//equal
        src_1=5;
        src_2=5;
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//less
        src_1=5;
        src_2=10;
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//get to original value 
        src_1=10;
        src_2=5;
               



        
        
        @(posedge clk);//test case for 1 > 2
        control=4;//greater
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);

        #1;//equal
        src_1=5;
        src_2=5;
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//less
        src_1=5;
        src_2=10;
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//get to original value 
        src_1=10;
        src_2=5;




       
       
        @(posedge clk);//test case for 1 >= 2
        control=5;//greater
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);

        #1;//equal
        src_1=5;
        src_2=5;
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//less
        src_1=5;
        src_2=10;
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//get to original value 
        src_1=10;
        src_2=5;
               
    
        
        
        @(posedge clk);//test case for 1 < 2
        control=6;//greater
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);

        #1;//equal
        src_1=5;
        src_2=5;
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//less
        src_1=5;
        src_2=10;
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//get to original value 
        src_1=10;
        src_2=5;

        
        
        
        @(posedge clk);//test case for 1 <= 2
        control=7;//greater
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);

        #1;//equal
        src_1=5;
        src_2=5;
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//less
        src_1=5;
        src_2=10;
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//get to original value 
        src_1=10;
        src_2=5;








        @(posedge clk);//test case for 1 not equal to 2
        control=9;//greater
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);

        #1;//equal
        src_1=5;
        src_2=5;
        #1;
        assert(branch==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//less
        src_1=5;
        src_2=10;
        #1;
        assert(branch==1)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        
        #1;//get to original value 
        src_1=10;
        src_2=5;


        @(posedge clk);//testcase for or
        control=10;
        #2;
        assert(result==15)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);




        @(posedge clk);//testcase for left shift
        control=11;
        #2;
        assert(result==320)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);



        @(posedge clk);//testcase for right shift
        control=12;
        #2;
        assert(result==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);







        @(posedge clk);//testcase for right shift
        control=13;
        #2;
        assert(result==0)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);     





        @(posedge clk);//testcase for sub
        control=14;
        #2;
        assert(result==5)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);          






        @(posedge clk);//testcase for xor
        control=15;
        #2;
        src_1=12;
        src_2=13;
        #1;
        assert(result==6)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        #1
        control = 16;



        @(posedge clk);//testcase for move high and move from high
        #2;
        control=17;
        #1;
        assert(result==6)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);  
        #1;
        control=18;


        @(posedge clk);//testcase for move low and move from low
        #2;
        control=19;
        #1;
        assert(result==6)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);  
        
        #1;
        control=2;
        src_1=32'h11111111;
        src_2=32'h00000088;
        #2;


       

        @(posedge clk);//testcase for /
        #1;
        control = 17;
        #1;
        assert(result==32'h00000011)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        #1;
        control = 19;
        #1;       
        assert(result==32'h00202020)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result); 
        #1;
        control=8;


        @(posedge clk);//testcase for *
        #1;
        control = 17;
        #1;
        assert(result==32'h00000009)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result);
        #1;
        control = 19;
        #1;       
        assert(result==32'h11111108)
        $display("result of input control %1 is %2",$control, $result);
        else
        $display("result of input control %1 failed with result %2",$control, $result); 
        
        $finish(0);

    end
endmodule         
        
  