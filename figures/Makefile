.PHONY: all clean 

FIGURES = elmod.pdf BB.pdf Hmix.pdf average-ICOHP.pdf

all: $(FIGURES)

%.pdf: %.gpl
	gnuplot $< > $@

clean:
	rm -f *~ $(FIGURES)
