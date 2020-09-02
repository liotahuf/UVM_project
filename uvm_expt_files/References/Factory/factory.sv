// set_inst_override_by_name
`include "uvm_macros.svh"
import uvm_pkg::*;

//--------------------uvm_object------------------------------
class A extends uvm_object;
  `uvm_object_utils(A)
 
  function new (string name="A");
    super.new(name);
    `uvm_info(get_full_name, $sformatf("A new"), UVM_LOW);
  endfunction : new
 
  virtual function hello();
    `uvm_info(get_full_name, $sformatf("HELLO from Original class 'A'"), UVM_LOW);
  endfunction : hello 
endclass : A

class A_ovr extends A;
  `uvm_object_utils(A_ovr)
 
  function new (string name="A_ovr");
    super.new(name);
    `uvm_info(get_full_name, $sformatf("A_ovr new"), UVM_LOW);
  endfunction : new
 
  function hello();
    `uvm_info(get_full_name, $sformatf("HELLO from override class 'A_ovr'"), UVM_LOW);
  endfunction : hello
endclass : A_ovr

class A_override extends A_ovr;
  `uvm_object_utils(A_override)
 
  function new (string name="A_override");
    super.new(name);
    `uvm_info(get_full_name, $sformatf("A_override new"), UVM_LOW);
  endfunction : new
 
  function hello();
    `uvm_info(get_full_name, $sformatf("HELLO from override class 'A_override'"), UVM_LOW);
  endfunction : hello
endclass : A_override

//--------------------env class--------------------
class environment extends uvm_env;
  `uvm_component_utils(environment)
  A a1, a2;

  function new(string name="environment", uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a1 = A::type_id::create("a1", this);
    a2 = A::type_id::create("a2", this);
 
    a1.hello(); // This will print from overridden class A_ovr
    a2.hello(); // This will print from overridden class A_override
  endfunction : build_phase
endclass : environment

//-------------------test class--------------------------
class test extends uvm_test;
  // goel uvm_factory factory;
  `uvm_component_utils(test)
  environment env;
 
  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = environment::type_id::create("env", this);
    `uvm_info(get_full_name, $sformatf("TEST set_inst_override_by_name"), UVM_LOW);

  endfunction : build_phase
endclass : test

module top();
import uvm_pkg::run_test;
  initial begin
    run_test("test");
  end
endmodule : top
