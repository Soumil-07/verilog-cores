OUT = adder_tb
FILES = adder_cla.v adder_behavioral.v adder_tb.v

.PHONY: all run
all run: $(OUT)
	vvp $(OUT)

.PHONY: cla 
cla:
	iverilog -o $(OUT) -DADDER_MODULE=adder_cla $(FILES)

.PHONY: behavioral
$(OUT) behavioral:
	iverilog -o $(OUT) -DADDER_MODULE=adder_behavioral $(FILES)

.PHONY: clean
clean:
	rm $(OUT) $(OUT).vcd

