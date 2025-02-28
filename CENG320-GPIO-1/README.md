# CENG320 GPIO 1

## Git Setup:
	git config --global user.name "zackery.holloway"
	git config --global user.email "zackery.holloway@mines.sdsmt.edu"
	git clone https://gitlab.com/tambourinee/CENG320-GPIO-1.git
		
## How to see GPIO Setup:
	raspi-gpio get
	
## GPIO Pin Out
	VCC			Pin  1,		3.3V
	GPIO 26, 	Pin 37,		MSB, 		GPFSEL2
	GPIO 16,	Pin 36					GPFSEL1
	GPIO  6,	Pin 31					GPFSEL0
	GPIO  5,	Pin 29,		LSB			GPFSEL0
	GPIO  2,	Pin  3,		Count Up	GPFSEL0	
	GPIO  3, 	Pin  5,		Count Down 	GPFSEL0
	GND			Pin 39,		0V

## Add your files

	git add (file name)
	git commit -m "Message"
	git push


## Test and Deploy

	How to compile the code:
		gcc -o team-project setup_io.c GPIO.S
		./team-project

***
