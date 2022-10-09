DASM_HOME=../dasm
DASM=$(DASM_HOME)/bin/dasm
DASM_INC=$(DASM_HOME)/machines/atari2600
BUILD=./build/
TASK=kernel.bin

create-build:
	mkdir -p $(BUILD)

build: create-build
	@$(DASM) src/main.asm -I$(DASM_INC) -f3 -v5 -o$(BUILD)$(TASK)

.PHONY: build
