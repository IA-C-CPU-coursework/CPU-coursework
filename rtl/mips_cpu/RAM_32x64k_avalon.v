// 32-bit x 64k RAM, synchonous read/write, one cycle delay
// This RAM uses Avalon compatible memory-mapped interface, performs as a Avalon mm slave. 
// `waitrequest` is asserted at the posedge of an incoming read or write operation. 

// ----------------------------------------------------------------------------
// Timing Example for read operation
//
// @1 
// `read` is asserted by avalon mm master indicating a read operation to address01, 
// `waitrequest` is asserted by the avalon mm slave, telling the master to maintain `read` and `address` 
// @2
// `address` and `read` is maintained by master,
// `waitrequest` is deasserted by asserted `pending`, indicate completed read operation,
// data from address01 is avaliable on `readdata`,
// @3
// `read` is asserted by avalon mm master indicating another read operation to address02, 
// `waitrequest` is asserted by the avalon mm slave, telling the master to maintain `read` and `address` 
// @4 (what if master does not maintain `address`)
// `address` is changed by master to addr03
// data from previous address is avaliable on `readdata`
// read to new address will wait until next cycle
// @5
// execute read operation to addr03
// @6
// data from addr03 avaliable on `readdata`
//
//           1____     2____     3____     4____     5____     6____     7____ 
// clk     |_|    |____|    |____|    |____|    |____|    |____|    |____|    |
//          _ ___________________ _________ ___________________________________
// address |_X_____addr01________X_addr02__X_____________addr03________________
//            _________________________________________________________________
// read    |_|                                                                 
//            _________           _________           _________                
// waitreq |_|         |_________|         |_________|         |_______________
//          ___________ ___________________ ___________________ _______________
// readdata|___________X__data_on_addr01___X__data_on_addr02___X_data_on_addr03
//                      _________           _________           __________     
// pending |___________|         |_________|         |_________|          |____
//
// ----------------------------------------------------------------------------


module RAM_32x64k_avalon(
    input logic rst,
    input logic clk,
    input logic[31:0] address,
    input logic write,
    input logic read,
    output logic waitrequest, // signal indicating the memory device is busy
    input logic[31:0] writedata,
    input logic[3:0] byteenable, // select bytes in the word, one bit for a corresponding byte
    output logic p, // 🐛 for debug purpose only
    output logic[31:0] readdata
);

    logic[29:0] word_address;
    assign word_address = address[31:2];
    // `address` is byte based, a word contains 4 byte in 32-bit memory,
    // thus word based address `word_address` is the most significant 30 bits in `address`

    logic pending; 
    // a signal indicating the required operation has finished and await for conformation from master
    // `pending` is just waitrequest being delayed by one cycle

    assign p = pending; // 🐛 for debug purpose only

    assign waitrequest = rst || (write || read) && !pending;
    // assign waitrequest = (write || read) && !pending || !(write || read) && pending;

    parameter RAM_INSTR_INIT_FILE = "";
    parameter RAM_INSTR_SIZE= 10; 
    parameter RAM_DATA_INIT_FILE = "";
    parameter RAM_DATA_SIZE= 10;

    reg[31:0] memory [0:2**16-1]; // 🚧 2^32 is too huge for simulation: doing so cause error [-1:0]
    // 📒 Note
    // bit [31:0] memory[int]; 
    // associative array(likes dictionary in python) might be more efficient to simulate large memory, 
    // however this is a feature of systemverilog, and have not been supported by iverilog yet


    //------------------------------------------------------------------------
    // Initialisation 
    //------------------------------------------------------------------------

    initial begin
        for (int i=0; i<2**16; i++) begin
        // Initialise memory to zero 
            memory[i]=0;
        end

        if (RAM_INSTR_INIT_FILE != "") begin
        // Load instruction contents from file if specified 
            $display("[RAM] : INIT : Loading instruction contents from %s", RAM_INSTR_INIT_FILE);
            $readmemh(RAM_INSTR_INIT_FILE, memory, 0, RAM_INSTR_SIZE-1);
        end

        if (RAM_DATA_INIT_FILE != "") begin
        // Load data contents from file if specified 
            $display("[RAM] : INIT : Loading data contents from %s", RAM_DATA_INIT_FILE);
            $readmemh(RAM_DATA_INIT_FILE, memory, 32'h100, 32'h100+RAM_DATA_SIZE-1);
        end

        $display("==== [Start] Content in the instruction section before execution ====");
        for (int j=0; j<RAM_INSTR_SIZE; j++) begin
            $display("PRE_INSTR_MEM[%h] = %h", (j*4 + 32'hBFC00000), memory[j + 32'h000]);
        end
        $display("==== [End]   Content in the instruction section before execution ====");

        $display("==== [Start] Content in the data section before execution ===========");
        for (int j=0; j<RAM_DATA_SIZE; j++) begin
            $display("PRE_DATA_MEM[%h] = %h", (j*4 + 32'hBFC00400), memory[j + 32'h100]);
        end
        $display("==== [End] Content in the data section before execution =============");

        pending <= 1'b0;
    end


    //------------------------------------------------------------------------
    // Reset 
    //------------------------------------------------------------------------

    always @(posedge clk) begin
        if (rst) begin
            $display("[RAM] : RESET ");

            for (int i=0; i<2**16; i++) begin
            // Reset memory to zero
                memory[i]=0;
            end

            if (RAM_INSTR_INIT_FILE != "") begin
            // Load instruction content from file if specified 
                $display("[RAM] : INIT : Loading instruction contents from %s", RAM_INSTR_INIT_FILE);
                $readmemh(RAM_INSTR_INIT_FILE, memory, 0, RAM_INSTR_SIZE-1);
            end

            if (RAM_DATA_INIT_FILE != "") begin
            // Load data content from file if specified 
                $display("[RAM] : INIT : Loading data contents from %s", RAM_DATA_INIT_FILE);
                $readmemh(RAM_DATA_INIT_FILE, memory, 32'h100, 32'h100+RAM_DATA_SIZE-1);
            end
        end
    end


    //------------------------------------------------------------------------
    // Assertions 
    //------------------------------------------------------------------------

    always @(*) begin
        assert(!(read===1 & write===1)); // read and write operation are not allowed to take at the same time
        else begin 
            $fatal(1, "read and write at the same time. read %b write %b", read, write);
        end
    end


    //------------------------------------------------------------------------
    // Pending Logic 
    //------------------------------------------------------------------------

    always @(posedge clk) begin
        pending <= !rst && waitrequest;
    end


    //------------------------------------------------------------------------
    // Read Logic
    //------------------------------------------------------------------------

    always @(posedge clk) begin
        if (waitrequest && read) begin
            // $display("[RAM] 📚📚📚📚📚 Reading")
            case(byteenable)
                // From Page 15, Avalon Memory-Mapped Interfaces
                // "If an interface does not have a byteenable signal, the transfer proceeds 
                // as if all byteenables are asserted. 
                // When more than one bit of the byteenable signal is asserted, all asserted 
                // lanes are adjacent." 
                4'b0001: readdata <= memory[word_address][07:00]; // ooox
                4'b0010: readdata <= memory[word_address][15:08]; // ooxx
                4'b0100: readdata <= memory[word_address][23:16]; // oxoo
                4'b1000: readdata <= memory[word_address][31:24]; // xooo
                4'b0011: readdata <= memory[word_address][15:00]; // ooxx
                4'b1100: readdata <= memory[word_address][31:16]; // xxoo
                4'b1110: readdata <= memory[word_address][31:08]; // xxxo
                4'b0111: readdata <= memory[word_address][23:00]; // 0xxx
                4'b1111: readdata <= memory[word_address][31:00]; // xxxx
                default: readdata <= memory[word_address];        // xxxx 
            endcase;
        end
        if(read) begin
            // $display("[RAM] : LOG : 📚📚📚 receive read instruction");
            // $display("[RAM] : LOG : waitrequest %b", waitrequest);
            // $display("[RAM] : LOG : readdata %h, word_address %h, memory[word_address] %h, waitrequest %b", readdata, word_address, memory[word_address], waitrequest); 
        end
    end


    //------------------------------------------------------------------------
    // Write Logic
    //------------------------------------------------------------------------
    always @(posedge clk) begin
        if (!waitrequest && write) begin 
            // $display("[RAM] 📝📝📝📝📝 Writing")
            case(byteenable)
                4'b0001: memory[word_address][07:00] <= writedata; // ooox
                4'b0010: memory[word_address][15:08] <= writedata; // ooxx
                4'b0100: memory[word_address][23:16] <= writedata; // oxoo
                4'b1000: memory[word_address][31:24] <= writedata; // xooo
                4'b0011: memory[word_address][15:00] <= writedata; // ooxx
                4'b1100: memory[word_address][31:16] <= writedata; // xxoo
                4'b1111: memory[word_address][31:00] <= writedata; // xxxx
                default: memory[word_address]        <= writedata; // xxxx 
            endcase;
        end
        if(write) begin
            // $display("[RAM] : LOG : 📝📝📝 receive write instruction");
            // $display("[RAM] : LOG : waitrequest %b", waitrequest);
            // $display("[RAM] : LOG : writedata %h, word_address %h, memory[word_address] %h, waitrequest %b", writedata, word_address, memory[word_address], waitrequest); 
        end
    end

endmodule
