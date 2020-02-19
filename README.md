### STM32 Projects

Projects to begin learning about low-level embedded programming on the STM32 platform
The examples are created for the STM32F429-DISC1 Discovery board 
but should be portable to any other STM32 mcu


#### References
- General Embedded systems
  - https://www.coursera.org/learn/introduction-embedded-systems
    - Excellent cource about embedded systems. Not using high level IDE and stuff. In parallel check out the section on understanding ELF.  
  - https://www.coursera.org/learn/embedded-software-hardware

- Understanding ELF files and some basic tools to analyze them
    - https://www.youtube.com/watch?v=xkD2NyRpvI4 
        - Requires some microcontroller knowledge
        - Important point to remember is that all peripherals in a processor have an address associated with it, even the GPIO has an address.
    - https://www.youtube.com/watch?v=t09LFtfy4JU&list=PLUFkSN0XLZ-n_Na6jwqopTt1Ki57vMIc3&index=36
      - A couple of lectures of this course are related to elf From Day2P18 to Day2P28
      - Teaches about readelf and hexdump, objdump -d (disassembly)
    - https://linux-audit.com/elf-binaries-on-linux-understanding-and-analysis/
