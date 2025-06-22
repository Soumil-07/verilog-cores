OUT = arbiter_tb
FILES = rr_arbiter_tb.v arbiter_rr_muxlog.v arbiter_fixed.v

all: $(OUT)
	vvp $(OUT)

wave: $(OUT)
	gtkwave *.vcd

$(OUT): $(FILES)
	iverilog -o $(OUT) $(FILES)

clean:
	rm $(OUT) *.vcd
