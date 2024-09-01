hello.o: hello.s
	riscv32-none-elf-as -g hello.s -o hello.o

hello: hello.o
	riscv32-none-elf-ld -T qemu.ld hello.o -o hello

echo.o: echo.s
	riscv32-none-elf-as -g echo.s -o echo.o

echo: echo.o
	riscv32-none-elf-ld -T qemu.ld echo.o -o echo

day01.o: day01.s
	riscv32-none-elf-as -g day01.s -o day01.o

day01: day01.o
	riscv32-none-elf-ld -T qemu.ld day01.o -o day01

.PHONY: run clean

clean:
	rm -rf \
	 hello.o hello \
	 echo.o echo \
	 day01.o day01 \

# To exit: Ctrl-A X
X?=hello
run: $(X)
	qemu-system-riscv32 -machine virt -nographic -kernel $(X) -bios none

DAY?=day01
day: $(DAY)
	(cat inputs/$(DAY).txt && echo -e "\0") | \
	qemu-system-riscv32 -machine virt -nographic -kernel $(DAY) -bios none
