//-----------------------------------------------------------------------------
// Copyright 2025 Space Cubics, LLC
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

parameter ADDR_DECODE_MASK = 32'h0000_FFFC;
parameter RESERVED_ADDR_SIZE = 256;

// Version Register
//----------------------------------
typedef struct packed {
  logic [7:0]  major_ver;
  logic [7:0]  minor_ver;
  logic [15:0] patch_ver;
} IPVER_s;

// Static Variable
const IPVER_s IPVER_init = '{major_ver: 1, minor_ver: 0, patch_ver: 0};

// Register access attributes
const sc_reg_attr_t IPVER_attr =  '{wr:     32'h0000_0000,     // WR
                                    w1s:    32'h0000_0000,     // W1S
                                    w1c:    32'h0000_0000,     // W1C
                                    fixed:  32'h0000_0000};    // FIXED

// Register descriptor
const sc_reg_desc_t IPVER_desc =  '{32'h0000_0000,             // ADDR
                                    ADDR_DECODE_MASK,          // DMASK
                                    32'h0000_0000,             // OFFSET
                                    IPVER_attr,                // RATTR
                                    IPVER_init};               // INIT


// Standard Register
//----------------------------------
typedef struct packed {
  logic [7:0] reserved;
  logic [7:0] field3;
  logic [7:0] field2;
  logic [7:0] field1;
} STDREG_s;

// Register access attributes
const sc_reg_attr_t STDREG_attr = '{wr:     32'h00FF_FFFF,
                                    default: '0};

// Register descriptor
const sc_reg_desc_t STDREG_desc = '{32'h0000_0004,             // ADDR
                                    ADDR_DECODE_MASK,          // DMASK
                                    32'h0000_0000,             // OFFSET
                                    STDREG_attr,               // REG ATTR
                                    32'h00FF0000};             // INIT

