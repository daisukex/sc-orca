//-----------------------------------------------------------------------------
// Copyright 2025 Space Cubics Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------------------
// Space Cubics Register Framework
// + Register source template
//-----------------------------------------------------------------------------

module register_template
  import screg_pkg::*;
(
  // System Interface
  input CLK,
  input RESETN,
  output INTERRUPT,

  // Register Interface
  input [31:0] REG_WADR,
  input [9:0] REG_WTYP,
  input [3:0] REG_WENB,
  input [31:0] REG_WDAT,
  output logic REG_WWAT,
  output logic REG_WERR,

  input [31:0] REG_RADR,
  input [9:0] REG_RTYP,
  input REG_RENB,
  output logic [31:0] REG_RDAT,
  output logic REG_RWAT,
  output logic REG_RERR

  // Definition of register I/O signals
);

// Declaration of base variable for register framework
//------------------------------------------------------
`include "register_template.svh"

sc_regbus_t bus;
always_comb begin
  bus.wadr = REG_WADR;
  bus.wtyp = REG_WTYP;
  bus.wenb = REG_WENB;
  bus.wdat = REG_WDAT;
  REG_WWAT = bus.wwat;
  REG_WERR = bus.werr;
  bus.radr = REG_RADR;
  bus.rtyp = REG_RTYP;
  bus.renb = REG_RENB;
  REG_RDAT = bus.rdat;
  REG_RWAT = bus.rwat;
  REG_RERR = bus.rerr;
end

sc_reg_entry_t [0:(RESERVED_ADDR_SIZE>>2)-1] reg_table = '0;


// Version Register
//----------------------------------
IPVER_s IPVER;
always_comb reg_table[get_idx(IPVER_desc, 0)] = '{desc: IPVER_desc, data: IPVER, regid: 0};

always_comb begin
  IPVER = reg_reset(reg_table[get_idx(IPVER_desc, 0)]);
end

// Standard Register
//----------------------------------
STDREG_s STDREG;
always_comb reg_table[get_idx(STDREG_desc, 0)] = '{desc: STDREG_desc, data: STDREG, regid: 0};

always_ff @ (posedge CLK) begin
  if (!RESETN)
    STDREG <= reg_reset(reg_table[get_idx(STDREG_desc, 0)]);
  else
    STDREG <= reg_write(reg_table[get_idx(STDREG_desc, 0)], bus);
end

// Register Read Logic
//----------------------------------
always_ff @ (posedge CLK) begin
  sc_reg_event_t re;
  if (!RESETN)
    bus.rdat <= '0;
  else begin
    for(int i=0; i<(RESERVED_ADDR_SIZE>>2); i++) begin
      if (is_valid_reg_read(reg_table[i], bus, re))
        bus.rdat <= re.data;
    end
  end
end

assign bus.wwat = 1'b0;
assign bus.werr = 1'b0;
assign bus.rwat = 1'b0;
assign bus.rerr = 1'b0;

endmodule
