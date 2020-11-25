SRCFILES = src/*.ml

OCAMLFORMAT = ocamlformat \
	--inplace \
	$(SRCFILES)

OCPINDENT = ocp-indent \
	--inplace \
	$(SRCFILES)

.PHONY: all
all :
	dune build @all

.PHONY: run
run: all
	rm -f ../bw-scripts/*.sh
	rm -f ../seccomp-bpf/*.c
	rm -f ../seccomp-bpf/*.exe
	rm -f ../seccomp-bpf/*.bpf
	dune exec gen

.PHONY: format
format :
	$(OCAMLFORMAT)
	$(OCPINDENT)

.PHONY: cinaps
cinaps :
	cinaps -i $(SRCFILES)
	$(OCAMLFORMAT)
	$(OCPINDENT)

.PHONY : clean
clean:
	dune clean
